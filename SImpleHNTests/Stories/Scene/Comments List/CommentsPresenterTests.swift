//
//  CommentsPresenterTests.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 05.01.2023.
//

import XCTest
@testable import SImpleHN

@MainActor
final class CommentsPresenterTests: XCTestCase {
    
    var sut: CommentsPresenter!
    var viewSpy: CommentsListViewSpy!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CommentsPresenter()
        viewSpy = CommentsListViewSpy()
        sut.view = viewSpy
    }

    override func tearDownWithError() throws {
        sut = nil
        viewSpy = nil
        try super.tearDownWithError()
    }
    
    // MARK: Test doubles
    class CommentsListViewSpy: CommentsDisplayLogic {
        var displayCalled: Bool = false
        var viewModel: Comments.GetCommentsList.ViewModel?
        
        
        func displayComments(viewModel: Comments.GetCommentsList.ViewModel) {
            displayCalled = true
            self.viewModel = viewModel
        }
    }
    
    // MARK: Helpers
    func commentTree() -> Comment {
        var root = Comment(hnItem: TestDTO.comment1)
        var childLevel1 = Comment(hnItem: TestDTO.comment2)
        let childLevel21 = Comment(hnItem: TestDTO.comment3)
        let childLevel22 = Comment(hnItem: TestDTO.comment4)
        childLevel1.replies = [childLevel21, childLevel22]
        root.replies = [childLevel1]
        return root
    }

    
    // MARK: Tests
    
    func test_givenEmptyComments_displayCalled_withEmptyViewModel() throws {
        let response = Comments.GetCommentsList.Respose(result: .success([]))

        sut.presentComments(response: response)

        let viewModel = try XCTUnwrap(viewSpy.viewModel)
        XCTAssertTrue(viewSpy.displayCalled)
        XCTAssertTrue(viewModel.displayedComments?.isEmpty ?? false)
    }

    func test_givenComments_displayCalled_withNonEmptyViewModel() throws {
        let comment = [Comment(hnItem: TestDTO.comment1)]
        let repsonse = Comments.GetCommentsList.Respose(result: .success(comment))

        sut.presentComments(response: repsonse)

        let receivedComment = try XCTUnwrap(viewSpy.viewModel?.displayedComments?.first)
        XCTAssertEqual(receivedComment.id, TestDTO.comment1.id)
    }
//
    func test_givenError_displayCalled_wthErrorViewModel() throws {
        let response = Comments.GetCommentsList.Respose(result: .failure(NetworkError.badServerResponse))

        sut.presentComments(response: response)

        let viewModel = try XCTUnwrap(viewSpy.viewModel)
        XCTAssertNotNil(viewModel.error)
        XCTAssertNil(viewModel.displayedComments)
    }

    func test_givenNestedComments_displayedCommentHasNestComments() throws {
        let root = commentTree()
        let response = Comments.GetCommentsList.Respose(result: .success([root]))

        sut.presentComments(response: response)

        let receivedDisplayedComments = try XCTUnwrap(viewSpy.viewModel?.displayedComments)
        XCTAssertEqual(receivedDisplayedComments[0].id, root.id)
        XCTAssertEqual(receivedDisplayedComments[0].replies?[0].id, root.replies[0].id)
        XCTAssertEqual(receivedDisplayedComments[0].replies?[0].replies?[0].id, root.replies[0].replies[0].id)
    }
}
