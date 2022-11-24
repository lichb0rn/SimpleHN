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
        var presentTopStoriesCalled: Bool = false
        var stories: [Story]?
        
        func presentStories(response: Stories.Fetch.Response) {
            presentTopStoriesCalled = true
            stories = response.stories
        }
    }
    
    actor MockService: Service {
        let mustFail: Bool
        
        init(mustFail: Bool = false) {
            self.mustFail = mustFail
        }
        
        func fetchLatest() async throws -> [Story.ID] {
            try failIfMust()
            return [Seeds.story.id]
        }
        
        func fetch(by id: Story.ID) async throws -> Story {
            try failIfMust()
            return Seeds.story
        }
        
        func fetch(by ids: [Story.ID]) async throws -> [Story] {
            try failIfMust()
            return Seeds.stories
        }
        
        private func failIfMust() throws {
            if mustFail {
                throw URLError(.badServerResponse)
            }
        }
    }

    
    // MARK: - Tests
    func test_successFetch_callsPresenter_withNonEmptyRepsonse() async {
        sut = StoriesInteractor(worker: MockService())
        sut.presenter = presenterSpy
        let stories = Seeds.stories
        
        let request = Stories.Fetch.Request()
        await sut.fetch(request: request)
        
        XCTAssertTrue(presenterSpy.presentTopStoriesCalled)
        XCTAssertEqual(presenterSpy.stories, stories)
    }
    
    func test_failedFetch_callsPresenter_withNilRepsonse() async {
        let mockService = MockService(mustFail: true)
        sut = StoriesInteractor(worker: mockService)
        sut.presenter = presenterSpy
        
        let request = Stories.Fetch.Request()
        await sut.fetch(request: request)
        
        XCTAssertTrue(presenterSpy.presentTopStoriesCalled)
        XCTAssertNil(presenterSpy.stories)
    }
}