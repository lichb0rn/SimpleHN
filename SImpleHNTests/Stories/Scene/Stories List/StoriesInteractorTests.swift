//
//  StoriesInteractorTests.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import XCTest
@testable import SImpleHN

final class StoriesInteractorTests: XCTestCase {
    
    var sut: StoriesInteractor!
    var presenterSpy: StoriesPresenterSpy!
    var story = Story.previewStory
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        presenterSpy = StoriesPresenterSpy()
        sut = StoriesInteractor()
    }

    override func tearDownWithError() throws {
        sut = nil
        presenterSpy = nil
        try super.tearDownWithError()
    }

    
    // MARK: - Test doubles
    class StoriesPresenterSpy: StoriesPresentationLogic {
        var presentCalled: Bool = false
        var stories: [Story]?
        
        func presentStories(response: Stories.Fetch.Response) {
            presentCalled = true
            stories = response.stories
        }
    }

    
    // MARK: - Tests
    func test_successFetch_callsPresenter_withNonEmptyRepsonse() async {
        sut = StoriesInteractor(worker: MockService())
        sut.presenter = presenterSpy
        let stories = [story]
        
        let request = Stories.Fetch.Request(type: .top)
        await sut.fetch(request: request)
        
        XCTAssertTrue(presenterSpy.presentCalled)
        XCTAssertEqual(presenterSpy.stories, stories)
    }
    
    func test_failedFetch_callsPresenter_withNilRepsonse() async {
        let mockService = MockService(mustFail: true)
        sut = StoriesInteractor(worker: mockService)
        sut.presenter = presenterSpy
        
        let request = Stories.Fetch.Request(type: .top)
        await sut.fetch(request: request)
        
        XCTAssertTrue(presenterSpy.presentCalled)
        XCTAssertNil(presenterSpy.stories)
    }
    

}
