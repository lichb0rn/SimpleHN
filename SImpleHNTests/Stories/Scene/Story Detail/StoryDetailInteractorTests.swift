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
    var story = Story(hnItem: TestDTO.story)
    
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
        var storyResponse: Story?
        var commentsRespone: [Comment]?
        var error: Error?
        
        
        func presentStory(response: StoryDetail.GetStory.Response) {
            presentCalled = true
            switch response.result {
            case .success(let received): self.storyResponse = received
            case .failure(let error): self.error = error
            }
        }
    }
    
    
    // MARK: Tests
    func test_presentStoryCalled_withStory() async {
        let dummyRequest = StoryDetail.GetStory.Request()
        
        await sut.getStory(request: dummyRequest)
        
        XCTAssertTrue(presenterSpy.presentCalled)
        XCTAssertEqual(sut.story.id, presenterSpy.storyResponse?.id)
        XCTAssertNil(presenterSpy.error)
    }
    
    func test_presentStoryCalled_withError() async {
        let mockService = MockService(mustFail: true)
        sut = StoryDetailInteractor(story: story, worker: mockService)
        sut.presenter = presenterSpy
        let request = StoryDetail.GetStory.Request()
        
        await sut.getStory(request: request)
        
        XCTAssertTrue(presenterSpy.presentCalled)
        XCTAssertNotNil(presenterSpy.error)
        XCTAssertNil(presenterSpy.storyResponse)
    }
}
