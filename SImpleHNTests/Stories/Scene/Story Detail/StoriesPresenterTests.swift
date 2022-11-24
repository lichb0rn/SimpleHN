//
//  StoriesPresenterTests.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import XCTest
@testable import SImpleHN


final class StoriesPresenterTests: XCTestCase {
    
    var sut: StoriesPresenter!
    var viewSpy: StoriesViewSpy!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StoriesPresenter()
        viewSpy = StoriesViewSpy()
        sut.view = viewSpy
    }

    override func tearDownWithError() throws {
        viewSpy = nil
        sut = nil
        try super.tearDownWithError()
    }


    // MARK: - Test doubles
    class StoriesViewSpy: StoriesDisplayLogic {
        var displayTopStoriesCalled = false
        var viewModel: Stories.Fetch.ViewModel?
        
        func displayStories(viewModel: Stories.Fetch.ViewModel) {
            self.displayTopStoriesCalled = true
            self.viewModel = viewModel
        }
    }
    
    // MARK: - Tests
    
    func test_presentStories_passSuccessViewModelToView() throws {
        let repsonse = Stories.Fetch.Response(stories: Seeds.stories)
        var viewModel = Stories.Fetch.ViewModel(success: true)
        viewModel.stories = Seeds.stories.map {
            Stories.Fetch.ViewModel.DisplayStory(story: $0, timePosted: "")
        }
        
        sut.presentStories(response: repsonse)
        
        let receivedViewModel = try XCTUnwrap(viewSpy.viewModel)
        XCTAssertTrue(viewSpy.displayTopStoriesCalled)
        XCTAssertTrue(receivedViewModel.success)
        XCTAssertEqual(viewModel.stories?.count, viewSpy.viewModel?.stories?.count)
    }
    
    func test_presentStories_passErrorViewModelToView() throws {
        let repsonse = Stories.Fetch.Response(error: NetworkError.badServerResponse)
        
        sut.presentStories(response: repsonse)
        
        let viewModel = try XCTUnwrap(viewSpy.viewModel)
        XCTAssertFalse(viewModel.success)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
}
