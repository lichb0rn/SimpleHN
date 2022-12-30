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
        var storyRequest: StoryDetail.GetStory.Request?
        var commentsRequest: StoryDetail.GetCommentsList.Request?
        var error: Error?
        
        func getStory(request: StoryDetail.GetStory.Request) {
            getCalled = true
            storyRequest = request
        }
        
        func getComments(request: StoryDetail.GetCommentsList.Request) async {
            getCalled = true
            commentsRequest = request
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
    
    func makeCommentsViewModel() -> StoryDetail.GetCommentsList.ViewModel {
        let posted = RelativeTimeFormatter.formatTimeString(timeInterval: TestDTO.comment1.time ?? 0)
        let comment = Comment(hnItem: TestDTO.comment1)
        let expectedComments = StoryDetail.GetCommentsList.ViewModel()
        expectedComments.displayedComments = [.init(id: comment.id,
                                                    author: comment.by,
                                                    text: comment.text,
                                                    parent: comment.parent,
                                                    repliesCount: comment.replies.count,
                                                    timePosted: posted)
        ]
        return expectedComments
    }
    
    // MARK: Life cycle tests
    func test_viewState_getComments_callesInteractor_getComments() async {
        await sut.getComments()
        
        XCTAssertTrue(interactorySpy.getCalled)
        XCTAssertNotNil(interactorySpy.commentsRequest)
    }
    
    func test_onAppear_inProgressIsFalse() {
        let expectation = expectation(description: "inProgress Initial Status")
        sut.$inProgress
            .sink(receiveValue: {
                XCTAssertFalse($0)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    
    // MARK: - Story Tests
    func test_onStart_storyStatusIsIdle() {
        let expectation = expectation(description: "Idle Status")
        
        sut.$storyStatus
            .sink {
                XCTAssertEqual($0, .idle)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_getStory_changesStatusToFetching() async {
        let expectation = expectation(description: "Idle Status")
        sut.$storyStatus
            .dropFirst()
            .sink {
                XCTAssertEqual($0, .fetching)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await sut.getStory()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_getStory_callsInteractor_getStory() async {
        await sut.getStory()
        
        XCTAssertTrue(interactorySpy.getCalled)
        XCTAssertNotNil(interactorySpy.storyRequest)
    }
    
    func test_onReceivedStory_statusIsFetched() {
        let expectedViewModel = makeStoryViewModel()
        let notExpected = StoryDetail.GetStory.ViewModel.DisplayedStory(story: Story(hnItem: HNItem.previewItem),
                                                                        timePosted: "")
        
        let expectation = expectation(description: "Fetching Status")
        sut.$storyStatus
            .dropFirst()
            .sink {
                XCTAssertEqual($0, .fetched(expectedViewModel.displayedStory ?? notExpected))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.displayStory(viewModel: expectedViewModel)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_onRecievedStoryError_statusIsError() {
        let expectedViewModel = StoryDetail.GetStory.ViewModel(error: "Test error")
        let expectation = expectation(description: "Error Received")
        sut.$storyStatus
            .dropFirst()
            .sink {
                XCTAssertEqual($0, .error("Test error"))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.displayStory(viewModel: expectedViewModel)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_onReceivedStory_commentsStartFetching() {
        let receivedStoryViewModel = makeStoryViewModel()
        let expectation = expectation(description: "Comments status is Fetching")
        sut.$commentsStatus
            .dropFirst()
            .sink {
                XCTAssertEqual($0, .fetching)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.displayStory(viewModel: receivedStoryViewModel)
        
        wait(for: [expectation], timeout: 1)
    }

    // MARK: Comments tests
    func test_onStart_commentsStatusIsIdle() {
        let expectation = expectation(description: "Idle Status")
        
        sut.$commentsStatus
            .sink {
                XCTAssertEqual($0, .idle)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_getComments_changesStatusToFetching() async {
        let expectation = expectation(description: "Fetching Comments Status")
        sut.$commentsStatus
            .dropFirst()
            .sink {
                XCTAssertEqual($0, .fetching)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await sut.getComments()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_onReceivedComments_changesStatusToFetched() {
        let expectaion = expectation(description: "Fetched")
        let viewModel = makeCommentsViewModel()
        sut.$commentsStatus
            .dropFirst()
            .sink {
                XCTAssertEqual($0, .fetched(viewModel.displayedComments ?? []))
                expectaion.fulfill()
            }
            .store(in: &cancellables)
        
        sut.displayComments(viewModel: viewModel)
        
        wait(for: [expectaion], timeout: 1)
    }
    
    func test_onReceivedCommentsError_changesStatusToError() {
        let expectation = expectation(description: "Error Status")
        let errorViewModel = StoryDetail.GetCommentsList.ViewModel(error: "Test error")
        sut.$commentsStatus
            .dropFirst()
            .sink {
                XCTAssertEqual($0, .error("Test error"))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.displayComments(viewModel: errorViewModel)
        
        wait(for: [expectation], timeout: 1)
    }
}