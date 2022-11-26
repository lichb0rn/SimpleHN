//
//  MockService.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 26.11.2022.
//

import Foundation
@testable import SImpleHN

actor MockService: Service {
    let mustFail: Bool
    let story = Story.previewStory
    
    init(mustFail: Bool = false) {
        self.mustFail = mustFail
    }
    
    func fetchLatest() async throws -> [Story.ID] {
        try failIfMust()
        return [story.id]
    }
    
    func fetch(by id: Story.ID) async throws -> Story {
        try failIfMust()
        return story
    }
    
    func fetch(by ids: [Story.ID]) async throws -> [Story] {
        try failIfMust()
        return [story]
    }
    
    private func failIfMust() throws {
        if mustFail {
            throw NetworkError.badServerResponse
        }
    }
}
