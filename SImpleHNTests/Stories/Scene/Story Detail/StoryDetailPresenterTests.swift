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
        
        func displayStory(viewModel: StoryDetail.GetStory.ViewModel) {
            displayCalled = true
            self.storyViewModel = viewModel
        }
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
}


