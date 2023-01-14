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
        sut.topLevelCommentIds = [TestDTO.comment1.id]
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
        
        func getCommentReplies(request: Comments.GetCommentsList.ReplyRequest) async {
            
        }
    }
    
    // MARK: Helpers
    func makeCommentsViewModel(fromDTO dto: HNItem = TestDTO.comment1) -> Comments.GetCommentsList.ViewModel {
        var viewModel = Comments.GetCommentsList.ViewModel()
        let posted = RelativeTimeFormatter.formatTimeString(timeInterval: dto.time ?? 0)
        let comment = Comments.GetCommentsList.ViewModel.DisplayedComment(
            id: dto.id,
            author: dto.by ?? "",
            text: dto.text ?? "",
            parent: dto.parent,
            repliesCount: "\(dto.kids?.count ?? 1) reply",
            timePosted: posted)
        viewModel.observableComments = [
            ObservableComment(comment: comment)
        ]
        return viewModel
    }
        
    // MARK: Tests
    func test_givenTopLevelCommentIds_callsInteractor() async throws {
        sut.topLevelCommentIds = [TestDTO.comment1.id]
        
        await sut.getComments()
        
        let receivedReuest = try XCTUnwrap(interactorySpy.request)
        XCTAssertTrue(interactorySpy.getCalled)
        XCTAssertEqual(receivedReuest.ids, [TestDTO.comment1.id])
    }
    
    func test_onStart_commentsStatusIsIdle() {
        XCTAssertEqual(sut.status, .idle)
    }
    
    func test_onStart_commentsAreEmpty() {
        XCTAssertTrue(sut.comments.isEmpty)
    }

    
    func test_onGetComments_statusIsFetching() async {
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
                XCTAssertEqual($0, .fetched)
                expectaion.fulfill()
            }
            .store(in: &cancellables)

        sut.displayComments(viewModel: viewModel)

        wait(for: [expectaion], timeout: 1)
    }
    
    func test_onReceivedComments_commentsPublisherIsNotEmpty() {
        let expectation = expectation(description: "Receieved comments")
        let viewModel = makeCommentsViewModel()
        sut.$comments
            .dropFirst()
            .sink {
                XCTAssertEqual($0, viewModel.observableComments)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.displayComments(viewModel: viewModel)
        
        wait(for: [expectation], timeout: 1)
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
    
    func test_onReceivedChildComments_mergesParent() throws {
        let parentViewModel = makeCommentsViewModel()
        sut.displayComments(viewModel: parentViewModel)
        let childViewModel = makeCommentsViewModel(fromDTO: TestDTO.comment2)
        let expectation = expectation(description: "Add child")
        sut.$comments
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.displayComments(viewModel: childViewModel)
        
        wait(for: [expectation], timeout: 1)
        let child = try XCTUnwrap(sut.comments.first?.replies)
        XCTAssertEqual(child, childViewModel.observableComments)
    }
}
