//
//  StoriesViewTests.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import XCTest
import SwiftUI
@testable import SImpleHN

final class StoriesViewTests: XCTestCase {
    
    var sut: StoriesView!
    var interactorSpy: StoriesInteractorSpy!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StoriesView()
        interactorSpy = StoriesInteractorSpy()
    }

    override func tearDownWithError() throws {
        interactorSpy = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Test doubles
    class StoriesInteractorSpy: StoriesLogic {
        var stories: [Story]?
        
        var interactorLoaded: Bool = false
        var fetchCalled: Bool = false
        
        func fetch(request: Stories.Fetch.Request) async {
            fetchCalled = true
        }
    }
    
    
    // MARK: Tests
    
    @MainActor
    func test_shoudFetchTopStories_onAppear() async {
        sut.interactor = interactorSpy
        
        await sut.fetch()
        
        XCTAssertTrue(interactorSpy.fetchCalled)
    }
}

