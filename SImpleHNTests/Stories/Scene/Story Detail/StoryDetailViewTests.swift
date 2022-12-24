//
//  StoryDetailViewTests.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import XCTest
@testable import SImpleHN


final class StoryDetailViewTests: XCTestCase {
    
    var sut: StoryDetailView!
    var interactorySpy: StoryDetailInteractorSpy!
    var story = Story(hnItem: TestDTO.story)

    override func setUpWithError() throws {
        try super.setUpWithError()
        interactorySpy = StoryDetailInteractorSpy()
        sut = StoryDetailView()
        sut.interactor = interactorySpy
    }

    override func tearDownWithError() throws {
        sut = nil
        interactorySpy = nil
        try super.tearDownWithError()
    }
    
    // MARK: Test doubles
    class StoryDetailInteractorSpy: StoryDetailLogic {
        var getCalled: Bool = false
        var storyRequest: StoryDetail.GetStory.Request?
        
        func getStory(request: StoryDetail.GetStory.Request) {
            getCalled = true
            storyRequest = request
        }
        
        func getComments(request: StoryDetail.GetCommentsList.Request) async {
            getCalled = true
        }
    }
    
    // MARK: Tests
    
    func test_viewCalls_interactor_getStory() async {
        await sut.getStory()
        
        XCTAssertTrue(interactorySpy.getCalled)
        XCTAssertNotNil(interactorySpy.storyRequest)
    }
    
    func test_viewCalls_interactor_getComments() async {
        await sut.getComments()
        
        XCTAssertTrue(interactorySpy.getCalled)
    }
}

