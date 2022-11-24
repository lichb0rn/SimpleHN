//
//  StoryDetailInteractorTests.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import XCTest
@testable import SImpleHN

final class StoryDetailInteractorTests: XCTestCase {

    var sut: StoryDetailInteractor!
    var presenterSpy: StoryDetailPresenterSpy!
    var story = Seeds.story
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StoryDetailInteractor(story: story)
        presenterSpy = StoryDetailPresenterSpy()
        sut.presenter = presenterSpy
    }

    override func tearDownWithError() throws {
        sut = nil
        presenterSpy = nil
        try super.tearDownWithError()
    }

    // MARK: Test doubles
    class StoryDetailPresenterSpy: StoryDetailPresentationLogic {
        var presentCalled: Bool = false
        var response: StoryDetail.GetStory.Response?
        
        func presentStory(response: StoryDetail.GetStory.Response) {
            presentCalled = true
            self.response = response
        }
    }
    
    // MARK: Tests
    
    func test_presentStoryCalled_withCorrectResponse() {
        let dummyRequest = StoryDetail.GetStory.Request()
        
        sut.getStory(request: dummyRequest)
        
        XCTAssertTrue(presenterSpy.presentCalled)
        XCTAssertEqual(sut.story, presenterSpy.response?.story)
    }
}
