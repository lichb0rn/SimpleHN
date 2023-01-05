//
//  CommentsViewStateTests.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 05.01.2023.
//

import XCTest
import Combine
@testable import SImpleHN

@MainActor
final class CommentsViewStateTests: XCTestCase {
    
    var sut: CommentsViewState!
    var interactorySpy: CommentsInteractorSpy!
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        try super.setUpWithError()
        interactorySpy = CommentsInteractorSpy()
        sut = CommentsViewState()
        sut.interactor = interactorySpy
    }
    
    override func tearDownWithError() throws {
        cancellables.removeAll()
        sut = nil
        interactorySpy = nil
        try super.tearDownWithError()
    }
    
    // MARK: Test doubles
    class CommentsInteractorSpy: CommentsLogic {
        var getCalled: Bool = false
        var request: Comments.GetCommentsList.Request?
        var error: Error?
        
        
        func getComments(request: Comments.GetCommentsList.Request) async {
            getCalled = true
            self.request = request
        }
    }
    
    // MARK: Helpers
    func makeCommentsViewModel() -> Comments.GetCommentsList.ViewModel {
        let posted = RelativeTimeFormatter.formatTimeString(timeInterval: TestDTO.comment1.time ?? 0)
        let comment = Comment(hnItem: TestDTO.comment1)
        var expectedComments = Comments.GetCommentsList.ViewModel()
        expectedComments.displayedComments = [.init(id: comment.id,
                                                    author: comment.by,
                                                    text: comment.text,
                                                    parent: comment.parent,
                                                    repliesCount: "\(comment.replies.count) reply",
                                                    timePosted: posted)
        ]
        return expectedComments
    }
    
    // MARK: Tests
    func test_viewState_canCallInteractor() async {
        await sut.getComments()
        
        XCTAssertTrue(interactorySpy.getCalled)
        XCTAssertNotNil(interactorySpy.request)
    }
    
    func test_onStart_commentsStatusIsIdle() {
        let expectation = expectation(description: "Idle Status")
        
        sut.$status
            .sink {
                XCTAssertEqual($0, .idle)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }

    
    func test_getComments_changesStatusToFetching() async {
        let expectation = expectation(description: "Fetching Comments Status")
        sut.$status
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
        sut.$status
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
        let errorViewModel = Comments.GetCommentsList.ViewModel(error: "Test error")
        sut.$status
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
