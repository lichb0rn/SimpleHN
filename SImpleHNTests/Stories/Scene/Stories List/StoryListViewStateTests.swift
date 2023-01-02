//
//  StoryListViewStateTests.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 25.12.2022.
//

import XCTest
import Combine
@testable import SImpleHN

@MainActor
final class StoryListViewStateTests: XCTestCase {

    var sut: StoryListViewState!
    var cancellables = Set<AnyCancellable>()
    var interactorSpy: StoriesInteractorSpy!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StoryListViewState()
        interactorSpy = StoriesInteractorSpy()
        sut.interactor = interactorSpy
    }

    override func tearDownWithError() throws {
        interactorSpy = nil
        sut = nil
        cancellables.removeAll()
        try super.tearDownWithError()
    }
    
    // MARK: - Test doubles
    class StoriesInteractorSpy: ObservableObject, StoriesLogic {
        var stories: [Story]?
        
        @Published var fetchCalled: Bool = false
        var storiesRequest: Stories.Fetch.Request?
        
        func fetch(request: Stories.Fetch.Request) async {
            fetchCalled = true
            storiesRequest = request
        }
        
        func search(text: String) {
            
        }
    }
    
    
    // MARK: - Helpers
    func makeViewModel() -> Stories.Fetch.ViewModel {
        let story = Story(hnItem: TestDTO.story)
        let posted = RelativeTimeFormatter.formatTimeString(timeInterval: story.time)
        var viewModel = Stories.Fetch.ViewModel(success: true)
        viewModel.stories = [Stories.Fetch.ViewModel.DisplayedStory(story: story, timePosted: posted)]
        return viewModel
    }
    
    
    // MARK: - Tests
    func test_onStart_statusIsIdle() {
        let expectation = expectation(description: "Idle Status")
        
        sut.$status
            .sink {
                XCTAssertEqual($0, .idle)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_onStart_newStoriesOptionIsSet() {
        let expectation = expectation(description: "New Stories")
        
        sut.$requestType
            .sink {
                XCTAssertEqual($0, .new)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_getStories_callsInteractor() async {
        await sut.getStories()
        
        XCTAssertTrue(interactorSpy.fetchCalled)
        XCTAssertNotNil(interactorSpy.storiesRequest)
    }
    
    func test_getStories_changesStatusToFetching() async {
        let expectation = expectation(description: "Fetching Status")
        
        sut.$status
            .dropFirst()
            .sink {
                XCTAssertEqual($0, .fetching)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await sut.getStories()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_onReceivedStories_statusIsFetched() {
        let expectedViewModel = makeViewModel()
        let expectation = expectation(description: "ViewModel Received")
        sut.$status
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertEqual($0, .fetched(expectedViewModel.stories ?? []))
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        sut.displayStories(viewModel: expectedViewModel)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_onReceivedError_statusIsError() {
        let expectedViewModel = Stories.Fetch.ViewModel(success: false, errorMessage: "Test error")
        let expectation = expectation(description: "Error Received")
        sut.$status
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertEqual($0, .error("Test error"))
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        sut.displayStories(viewModel: expectedViewModel)
        
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - Story Type
    func test_whenNewStoriesOptionIsChosen_requestsNewStoriesFromInteractor() throws {
        let expectation = expectation(description: "Interactor Called")
        interactorSpy.$fetchCalled
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
        
        sut.changeStoryType(to: .new)
        
        wait(for: [expectation], timeout: 1)
        
        let receivedRequest = try XCTUnwrap(interactorSpy.storiesRequest)
        XCTAssertEqual(receivedRequest.type, .new)
    }
    
    func test_whenTopStoriesOptionIsChosen_requestsTopStoriesFromInteractor() throws {
        let expectation = expectation(description: "Interactor Called")
        interactorSpy.$fetchCalled
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
        
        sut.changeStoryType(to: .top)
        
        wait(for: [expectation], timeout: 1)
        
        let receivedRequest = try XCTUnwrap(interactorSpy.storiesRequest)
        XCTAssertEqual(receivedRequest.type, .top)
    }
    
    // MARK: - Search
    
    func test_onStart_searchTextIsEmpty() {
        let expectation = expectation(description: "searchText is empty")
        sut.$searchText
            .sink {
                XCTAssertTrue($0.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_givenExistingKeyword_publishesNonEmptyStoriesList() {
        let textForSearch = "venture"
        var viewModel = makeViewModel()
        viewModel.stories?.append(.init(story: Story(hnItem: TestDTO.storyWithOutComments), timePosted: ""))
        sut.displayStories(viewModel: viewModel)
        let expecation = expectation(description: "Story with with venture keyword")
        sut.$status
            .sink {
                if case let .fetched(stories) = $0 {
                    XCTAssertEqual(stories.count, 1)
                    XCTAssertTrue(stories.contains(where: { $0.title.contains(textForSearch)}))
                }
                expecation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.searchText = textForSearch
        
        wait(for: [expecation], timeout: 1)
    }
    
    func test_givenNonExistentKeyword_publishesEmptyStoriesList() {
        let textForSearch = "ThereIsNoSuchWord"
        var viewModel = makeViewModel()
        viewModel.stories?.append(.init(story: Story(hnItem: TestDTO.storyWithOutComments), timePosted: ""))
        sut.displayStories(viewModel: viewModel)
        let expecation = expectation(description: "Empty stories")
        sut.$status
            .sink {
                if case let .fetched(stories) = $0 {
                    XCTAssertTrue(stories.isEmpty)
                }
                expecation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.searchText = textForSearch
        
        wait(for: [expecation], timeout: 1)
    }
    
    func test_givenEmptySearchText_fetchesStories() {
        let expecation = expectation(description: "Interactor called")
        interactorSpy.$fetchCalled
            .dropFirst()
            .sink { _ in expecation.fulfill() }
            .store(in: &cancellables)
        
        sut.searchText = ""
        
        wait(for: [expecation], timeout: 1)
        
        XCTAssertTrue(interactorSpy.fetchCalled)
    }
}
