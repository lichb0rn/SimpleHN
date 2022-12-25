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
        try super.tearDownWithError()
    }
    
    // MARK: - Test doubles
    class StoriesInteractorSpy: StoriesLogic {
        var stories: [Story]?
        
        var interactorLoaded: Bool = false
        var fetchCalled: Bool = false
        var storiesRequest: Stories.Fetch.Request?
        
        func fetch(request: Stories.Fetch.Request) async {
            fetchCalled = true
            storiesRequest = request
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
}
