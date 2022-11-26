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
