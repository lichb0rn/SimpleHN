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
    func test_viewState_getStory_callsInteractor_getStory() async {
        await sut.getStory()
        
        XCTAssertTrue(interactorySpy.getCalled)
        XCTAssertNotNil(interactorySpy.storyRequest)
    }
    
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
    func test_viewState_onDisplayStory_withStoryViewModel_stateUpdates() {
        let posted = RelativeTimeFormatter.formatTimeString(timeInterval: story.time)
        let displayedStory = StoryDetail.GetStory.ViewModel.DisplayedStory(story: story,
                                                                           timePosted: posted)
        var viewModel = StoryDetail.GetStory.ViewModel()
        viewModel.displayedStory = displayedStory
        
        let expectation = expectation(description: "Received Story ViewModel")
        sut.$story
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertEqual($0.id, displayedStory.id)
                
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        sut.displayStory(viewModel: viewModel)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_viewState_onDisplayStory_withErrorViewModel_stateUpdates() {
        let error = "Test error"
        let viewModel = StoryDetail.GetStory.ViewModel(error: error)
        
        let expectation = expectation(description: "Received Error")
        sut.$error
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertEqual($0, error)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        sut.displayStory(viewModel: viewModel)
        
        wait(for: [expectation], timeout: 1)
    }
    

    // MARK: Comments tests
    func test_onStartFetchingComments_inProgressUpdates() async {
        let expectation = expectation(description: "inProgress Status")
        sut.$inProgress
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertTrue($0)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        await sut.getComments()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_viewState_onDisplayComments_withCommentsViewModel_stateUpdates() {
        let expectedViewModel = makeCommentsViewModel()
        let expectation = expectation(description: "Received Comments")
        sut.$comments
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertEqual($0, expectedViewModel.displayedComments)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        sut.displayComments(viewModel: expectedViewModel)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_onReceiveCommentsViewModel_inProgressDisabled() {
        let expectedViewModel = makeCommentsViewModel()
        
        let expectation = expectation(description: "inProgress Status")
        sut.$inProgress
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertFalse($0)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        sut.displayComments(viewModel: expectedViewModel)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_viewState_onDisplayComments_withErrorViewModel_stateUpdates() {
        let viewModel = StoryDetail.GetCommentsList.ViewModel(error: "Could not fetch the comments")
        
        let expectation = expectation(description: "Received Error")
        sut.$error
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertEqual($0, "Could not fetch the comments")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        sut.displayComments(viewModel: viewModel)
        
        wait(for: [expectation], timeout: 1)
    }
}
