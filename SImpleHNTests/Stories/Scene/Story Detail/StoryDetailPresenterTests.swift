//
//  StoryDetailPresenterTests.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import XCTest
@testable import SImpleHN

final class StoryDetailPresenterTests: XCTestCase {

    var sut: StoryDetailPresenter!
    var viewSpy: StoryDetailViewSpy!
    var comments = [Comment(hnItem: HNItem.previewItem)]
    
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
    
    // MARK: Tests
    
    func test_displayStoryCalled_withCorrectViewModel() {
        let response = StoryDetail.GetStory.Response(story: Story.previewStory)
        
        sut.presentStory(response: response)
        
        XCTAssertTrue(viewSpy.displayCalled)
        XCTAssertEqual(response.story.id, viewSpy.storyViewModel?.displayedStory.id)
    }
    
    func test_displayCommentsCalled() {
        let response = StoryDetail.GetCommentsList.Respose(result: .success(comments))
        
        sut.presentComments(response: response)
        
        XCTAssertTrue(viewSpy.displayCalled)
        
    }
}
