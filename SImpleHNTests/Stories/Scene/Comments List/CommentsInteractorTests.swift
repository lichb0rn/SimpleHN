//
//  CommentsInteractorTests.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 05.01.2023.
//

import XCTest
@testable import SImpleHN

final class CommentsInteractorTests: XCTestCase {
    
    var sut: CommentsInteractor!
    var presenterSpy: CommentsPresenterSpy!
    var worker: MockService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        worker = MockService()
        sut = CommentsInteractor(worker: worker)
        presenterSpy = CommentsPresenterSpy()
        sut.presenter = presenterSpy
    }

    override func tearDownWithError() throws {
        sut = nil
        presenterSpy = nil
        worker = nil
        try super.tearDownWithError()
    }

    // MARK: Test doubles
    class CommentsPresenterSpy: CommentsPresentationLogic {
        var presentCalled: Bool = false
        var response: [Comment]?
        var error: Error?
        
        func presentComments(response: Comments.GetCommentsList.Respose) {
            presentCalled = true
            switch response.result {
            case .success(let comments): self.response = comments
            case .failure(let error): self.error = error
            }
        }
    }
    
    // MARK: Tests
    func test_presentCommentsCalled_withEmptyComments() async throws {
        let commentsRequest = Comments.GetCommentsList.Request(ids: [])
        
        await sut.getComments(request: commentsRequest)
        
        let receivedComments = try XCTUnwrap(presenterSpy.response)
        XCTAssertTrue(presenterSpy.presentCalled)
        XCTAssertEqual(receivedComments, [])
    }
    
    func test_presentCommentsCalled_withComments() async throws {
        let expectedCommentIds = [TestDTO.comment1.id]
        let request = Comments.GetCommentsList.Request(ids: expectedCommentIds)

        await sut.getComments(request: request)

        let receivedComments = try XCTUnwrap(presenterSpy.response)
        let receivedIds = receivedComments.map { $0.id }
        XCTAssertTrue(presenterSpy.presentCalled)
        XCTAssertEqual(receivedIds, expectedCommentIds)
    }

    func test_presentComments_withErrorCalled() async {
        let mockService = MockService(mustFail: true)
        sut = CommentsInteractor(worker: mockService)
        sut.presenter = presenterSpy
        let expectedCommentIds = [TestDTO.comment1.id]
        let request = Comments.GetCommentsList.Request(ids: expectedCommentIds)

        await sut.getComments(request: request)

        XCTAssertTrue(presenterSpy.presentCalled)
        XCTAssertNotNil(presenterSpy.error)
    }

    func test_filtersDeletedComment() async throws {
        let requestedComments = [TestDTO.comment4.id, TestDTO.deletedComment.id]
        let request = Comments.GetCommentsList.Request(ids: requestedComments)
        
        await sut.getComments(request: request)
        
        let receivedComments  = try XCTUnwrap(presenterSpy.response)
        XCTAssertEqual(receivedComments.count, 1)
        XCTAssertEqual(receivedComments.first?.id, TestDTO.comment4.id)
    }
}
