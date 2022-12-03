//
//  MockService.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 26.11.2022.
//

import Foundation
@testable import SImpleHN


struct MockService: Service {
    let mustFail: Bool
    let story = Story.previewStory
    let item = HNItem.previewItem
    
    init(mustFail: Bool = false) {
        self.mustFail = mustFail
    }
    
    func fetchLatest() async throws -> [Story.ID] {
        try failIfMust()
        return [story.id]
    }
    
    func fetch(by id: Int) async throws -> HNItem {
        try failIfMust()
        return item
    }
    
    func fetch(by ids: [Int]) async throws -> [HNItem] {
        try failIfMust()
        return [item]
    }
    
    private func failIfMust() throws {
        if mustFail {
            throw NetworkError.badServerResponse
        }
    }
}

extension MockService: StoriesService {}
