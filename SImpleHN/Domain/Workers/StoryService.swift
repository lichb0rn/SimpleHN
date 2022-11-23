//
//  StoryService.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 23.11.2022.
//

import Foundation


protocol Service {
    func fetchLatest() async throws -> [Story.ID]
    func fetch(by id: Story.ID) async throws -> Story
    func fetch(by ids: [Story.ID]) async throws -> [Story]
}

actor StoriesRepository: Service {
    private let networkWorker:Networking = NetworkWorker()
    
    private var cache: [Story.ID:Story] = [:]
    
    func fetchLatest() async throws -> [Story.ID] {
        let newStoriesRequest = NewStoriesRequest()
        let newStoriesIds = try await networkWorker.fetch(newStoriesRequest)
        return newStoriesIds
    }
    
    func fetch(by id: Story.ID) async throws -> Story {
        if let story = self.cache[id] {
            return story
        }
        
        guard let request = StoryRequest(from: id) else {
            throw NetworkError.badRequest(id)
        }
        let story = try await networkWorker.fetch(request)
        add(story)
        return story
    }
    
    private func add(_ story: Story) {
        self.cache[story.id] = story
    }
    
    func fetch(by ids: [Story.ID]) async throws -> [Story] {
        // We are doing a lot of requests here
        // So, some of them with fail
        // Don't care about that
        let stories = await withTaskGroup(of: Story?.self) { group in
            ids.forEach { id in
                group.addTask {
                    return try? await self.fetch(by: id)
                }
            }
            
            var fetched = [Story]()
            fetched.reserveCapacity(ids.count)
            
            for await item in group.compactMap({$0}) {
                fetched.append(item)
            }
            return fetched
        }
        return stories
    }
}
