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
        
        func presentComments(response: StoryDetail.GetCommentsList.Respose) {
            presentCalled = true
            switch response.result {
            case .success(let comments): self.commentsRespone = comments
            case .failure(let error): self.error = error
            }
        }
    }
    
    
    // MARK: Story tests
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
    
    // MARK: Comments Test
    func test_presentCommentsCalled_withEmptyComments() async throws {
        let emptyStory = Story(hnItem: TestDTO.storyWithOutComments)
        sut = StoryDetailInteractor(story: emptyStory, worker: worker)
        sut.presenter = presenterSpy
        let commentsRequest = StoryDetail.GetCommentsList.Request()
        
        await sut.getComments(request: commentsRequest)
        
        let receivedComments = try XCTUnwrap(presenterSpy.commentsRespone)
        XCTAssertTrue(presenterSpy.presentCalled)
        XCTAssertEqual(receivedComments, [])
    }
    
    func test_presentCommentsCalled_withComments() async throws {
        let request = StoryDetail.GetCommentsList.Request()
        
        await sut.getComments(request: request)
        
        let receivedComments = try XCTUnwrap(presenterSpy.commentsRespone)
        XCTAssertTrue(presenterSpy.presentCalled)
        XCTAssert(receivedComments.count > 0)
    }
    
    func test_presentComments_withErrorCalled() async {
        let mockService = MockService(mustFail: true)
        sut = StoryDetailInteractor(story: story, worker: mockService)
        sut.presenter = presenterSpy
        let request = StoryDetail.GetCommentsList.Request()
        
        await sut.getComments(request: request)

        
        XCTAssertTrue(presenterSpy.presentCalled)
        XCTAssertNotNil(presenterSpy.error)
    }
    
    func test_presentCommentsCalled_withNestedComments() async throws {
        let request = StoryDetail.GetCommentsList.Request()
        
        await sut.getComments(request: request)
        
        let receivedComments = try XCTUnwrap(presenterSpy.commentsRespone)
        XCTAssertTrue(presenterSpy.presentCalled)
        XCTAssertEqual(receivedComments[0].id, TestDTO.comment1.id)
        XCTAssertEqual(receivedComments[1].id, TestDTO.comment2.id)
        XCTAssertEqual(receivedComments[1].replies[0].id, TestDTO.comment3.id)
    }
}
