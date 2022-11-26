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
    var story = Story.previewStory

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
        var getStoryCalled: Bool = false
        
        func getStory(request: StoryDetail.GetStory.Request) async {
            getStoryCalled = true
        }
    }
    
    // MARK: Tests
    
    func test_viewCalls_interactor() async {
        await sut.getStory()
        
        XCTAssertTrue(interactorySpy.getStoryCalled)
    }
}
