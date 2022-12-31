//
//  MockService.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 26.11.2022.
//

import Foundation
@testable import SImpleHN


class MockService: Service {
    enum StoryType {
        case new
        case top
    }

    let mustFail: Bool
    let story = Story.previewStory
    let item = HNItem.previewItem
    var storiesTypeCalled = StoryType.new
    
    init(mustFail: Bool = false) {
        self.mustFail = mustFail
    }
    
    func fetchNewStories() async throws -> [Story.ID] {
        try failIfMust()
        storiesTypeCalled = .new
        return [story.id]
    }
    
    func fetchTopStories() async throws -> [Story.ID] {
        try failIfMust()
        storiesTypeCalled = .top
        return [story.id]
    }
    
    func fetch(by id: Int) async throws -> HNItem {
        try failIfMust()
        return findItem(id)
    }
    
    func fetch(by ids: [Int]) async throws -> [HNItem] {
        try failIfMust()
        let items = TestDTO.allDTO.filter({ ids.contains($0.id) })
        return items
    }
    
    private func failIfMust() throws {
        if mustFail {
            throw NetworkError.badServerResponse
        }
    }
    
    private func findItem(_ id: Int) -> HNItem {
        TestDTO.allDTO.first(where: { $0.id == id }) ?? TestDTO.story
    }
}

extension MockService: StoriesService {}



