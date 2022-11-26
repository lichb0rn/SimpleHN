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
    var worker: MockService!
    var story = Story.previewStory
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        worker = MockService()
        sut = StoryDetailInteractor(story: story, worker: worker)
        presenterSpy = StoryDetailPresenterSpy()
        sut.presenter = presenterSpy
    }

    override func tearDownWithError() throws {
        sut = nil
        presenterSpy = nil
        worker = nil
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
    
    func test_presentStoryCalled_withCorrectResponse() async {
        let dummyRequest = StoryDetail.GetStory.Request()
        
        await sut.getStory(request: dummyRequest)
        
        XCTAssertTrue(presenterSpy.presentCalled)
        XCTAssertEqual(sut.story, presenterSpy.response?.story)
    }
}
