//
//  StoryDetailPresenterTests.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import XCTest
@testable import SImpleHN

@MainActor
final class StoryDetailPresenterTests: XCTestCase {

    var sut: StoryDetailPresenter!
    var viewSpy: StoryDetailViewSpy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StoryDetailPresenter()
        viewSpy = StoryDetailViewSpy()
        sut.view = viewSpy
    }

    override func tearDownWithError() throws {
        sut = nil
        viewSpy = nil
        try super.tearDownWithError()
    }

    // MARK: Test doubles
    class StoryDetailViewSpy: StoryDetailDisplayLogic {
        var displayCalled: Bool = false
        var storyViewModel: StoryDetail.GetStory.ViewModel?
        var commentsViewModel: StoryDetail.GetCommentsList.ViewModel?
        
        func displayStory(viewModel: StoryDetail.GetStory.ViewModel) {
            displayCalled = true
            self.storyViewModel = viewModel
        }
        
        func displayComments(viewModel: StoryDetail.GetCommentsList.ViewModel) {
            displayCalled = true
            self.commentsViewModel = viewModel
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
    
    
    // MARK: - Story Tests
    
    func test_displayStoryCalled_withStory() throws {
        let story = Story(hnItem: TestDTO.story)
        let response = StoryDetail.GetStory.Response(result: .success(story))
        
        sut.presentStory(response: response)
        
        let viewModel = try XCTUnwrap(viewSpy.storyViewModel)
        XCTAssertTrue(viewSpy.displayCalled)
        XCTAssertEqual(viewModel.displayedStory?.id, story.id)
    }
    
    func test_displayStoryCalled_withError() throws {
        let response = StoryDetail.GetStory.Response(result: .failure(NetworkError.badServerResponse))
        
        sut.presentStory(response: response)
        
        let viewModel = try XCTUnwrap(viewSpy.storyViewModel)
        XCTAssertTrue(viewSpy.displayCalled)
        XCTAssertNotNil(viewModel.error)
        XCTAssertNil(viewModel.displayedStory)
    }
    
    // MARK: Comments Tests
    
    func test_displayCommentsCalled_withEmptyComments() throws {
        let response = StoryDetail.GetCommentsList.Respose(result: .success([]))
        
        sut.presentComments(response: response)
        
        let viewModel = try XCTUnwrap(viewSpy.commentsViewModel)
        XCTAssertTrue(viewSpy.displayCalled)
        XCTAssertTrue(viewModel.displayedComments?.isEmpty ?? false)
    }
    
    func test_displayCommentsCalled_withComment() throws {
        let comment = [Comment(hnItem: TestDTO.comment1)]
        let repsonse = StoryDetail.GetCommentsList.Respose(result: .success(comment))
        
        sut.presentComments(response: repsonse)
        
        let receivedComment = try XCTUnwrap(viewSpy.commentsViewModel?.displayedComments?.first)
        XCTAssertEqual(receivedComment.id, TestDTO.comment1.id)
    }
    
    func test_displayCommentsCalled_withError() throws {
        let response = StoryDetail.GetCommentsList.Respose(result: .failure(NetworkError.badServerResponse))
        
        sut.presentComments(response: response)
        
        let viewModel = try XCTUnwrap(viewSpy.commentsViewModel)
        XCTAssertNotNil(viewModel.error)
        XCTAssertNil(viewModel.displayedComments)
    }
    
    func test_presenterBuildsCommentTree() throws {
        let root = commentTree()
        let response = StoryDetail.GetCommentsList.Respose(result: .success([root]))
        
        sut.presentComments(response: response)
        
        let receivedDisplayedComments = try XCTUnwrap(viewSpy.commentsViewModel?.displayedComments)
        XCTAssertEqual(receivedDisplayedComments[0].id, root.id)
        XCTAssertEqual(receivedDisplayedComments[0].replies?[0].id, root.replies[0].id)
        XCTAssertEqual(receivedDisplayedComments[0].replies?[0].replies?[0].id, root.replies[0].replies[0].id)
    }
}


