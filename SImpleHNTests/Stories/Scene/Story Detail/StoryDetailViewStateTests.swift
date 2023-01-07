//
//  StoryDetailViewStateTests.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 24.12.2022.
//

import XCTest
import Combine
@testable import SImpleHN


@MainActor
final class StoryDetailViewStateTests: XCTestCase {
    
    var sut: StoryDetailViewState!
    var interactorySpy: StoryDetailInteractorSpy!
    var story = Story(hnItem: TestDTO.story)
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        interactorySpy = StoryDetailInteractorSpy()
        sut = StoryDetailViewState()
        sut.interactor = interactorySpy
    }
    
    override func tearDownWithError() throws {
        cancellables.removeAll()
        sut = nil
        interactorySpy = nil
        try super.tearDownWithError()
    }
    
    
    // MARK: Test doubles
    class StoryDetailInteractorSpy: StoryDetailLogic {
        var getCalled: Bool = false
        var request: StoryDetail.GetStory.Request?
        var error: Error?
        
        func getStory(request: StoryDetail.GetStory.Request) {
            getCalled = true
            self.request = request
        }
    }
    
    // MARK: - Helpers
    func makeStoryViewModel() -> StoryDetail.GetStory.ViewModel {
        let posted = RelativeTimeFormatter.formatTimeString(timeInterval: story.time)
        let displayedStory = StoryDetail.GetStory.ViewModel.DisplayedStory(story: story,
                                                                           timePosted: posted)
        var viewModel = StoryDetail.GetStory.ViewModel()
        viewModel.displayedStory = displayedStory
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
    
    func test_onStart_startsFetchingStory() {
        let expectation = expectation(description: "Fetching Status")
        
        sut.$status
            .dropFirst()
            .sink {
                XCTAssertEqual($0, .fetching)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_onStart_repliesListIsEmpty() {
        let expectation = expectation(description: "Empty replies list")
        
        sut.$replies
            .sink {
                XCTAssertTrue($0.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_getStory_callsInteractor() async {
        await sut.getStory()
        
        XCTAssertTrue(interactorySpy.getCalled)
        XCTAssertNotNil(interactorySpy.request)
    }
    
    
    func test_onReceivedStory_statusIsFetched() {
        let expectedViewModel = makeStoryViewModel()
        let notExpected = StoryDetail.GetStory.ViewModel.DisplayedStory(story: Story(hnItem: HNItem.previewItem),
                                                                        timePosted: "")
        
        let expectation = expectation(description: "Fetched Status")
        sut.$status
            .dropFirst()
            .sink {
                XCTAssertEqual($0, .fetched(expectedViewModel.displayedStory ?? notExpected))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.displayStory(viewModel: expectedViewModel)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_onReceivedStoryWithReplies_updatesRepliesPublisher() {
        let expectedViewModel = makeStoryViewModel()
        let expectation = expectation(description: "Replies updated")
        sut.$replies
            .dropFirst()
            .sink { [weak self] in
                XCTAssertEqual($0, self?.story.kids)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.displayStory(viewModel: expectedViewModel)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_onRecievedStoryError_statusIsError() {
        let expectedViewModel = StoryDetail.GetStory.ViewModel(error: "Test error")
        let expectation = expectation(description: "Error Received")
        sut.$status
            .dropFirst(2)
            .sink {
                XCTAssertEqual($0, .error("Test error"))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.displayStory(viewModel: expectedViewModel)
        
        wait(for: [expectation], timeout: 1)
    }
}
