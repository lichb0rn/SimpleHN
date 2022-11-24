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
        var viewModel: StoryDetail.GetStory.ViewModel?
        
        func displayStory(viewModel: StoryDetail.GetStory.ViewModel) {
            displayCalled = true
            self.viewModel = viewModel
        }
    }
    
    // MARK: Tests
    
    func test_displayStoryCalled_withCorrectViewModel() {
        let response = StoryDetail.GetStory.Response(story: Story.previewStory)
        
        sut.presentStory(response: response)
        
        XCTAssertTrue(viewSpy.displayCalled)
        XCTAssertEqual(response.story.id, viewSpy.viewModel?.displayedStory.id)
    }
}
