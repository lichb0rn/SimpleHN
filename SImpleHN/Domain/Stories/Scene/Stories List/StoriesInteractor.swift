//
//  StoriesInteractor.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import Foundation

protocol StoriesLogic {
    func fetch(request: Stories.Fetch.Request) async
    func search(text: String)
}

protocol StoriesStore {
    var stories: [Story]? { get }
}

class StoriesInteractor {
    var presenter: StoriesPresentationLogic?
    
    var stories: [Story]? = []
    
    private let worker: StoriesService
    private let maxStories = 30
    
    init(worker: StoriesService = NetworkService()) {
        self.worker = worker
    }
}

extension StoriesInteractor: StoriesStore { }

extension StoriesInteractor: StoriesLogic {
    func fetch(request: Stories.Fetch.Request) async {
        do {
            var storiesIds: [Int]
            switch request.type {
            case .top: storiesIds = try await fetchTop()
            case .new: storiesIds = try await fetchNew()
            }
            
            let stories = await fetchStories(withIds: storiesIds)
            self.stories = stories
            let response = Stories.Fetch.Response(stories: stories)
            presenter?.presentStories(response: response)
        } catch (let error) {
            let errorResponse = Stories.Fetch.Response(error: error)
            presenter?.presentStories(response: errorResponse)
        }
    }
    
    private func fetchNew() async throws -> [Story.ID] {
        let newStoriesIds = try await worker.fetchNewStories()
        return newStoriesIds
    }
    
    private func fetchTop() async throws -> [Story.ID] {
        let topStoriesIds = try await worker.fetchTopStories()
        return topStoriesIds
    }
    
    private func fetchStories(withIds ids: [Story.ID]) async -> [Story] {
        let maxStories = Array(ids.prefix(maxStories))
        do {
            let hnItems = try await worker.fetch(by: maxStories)
            let stories = hnItems.map(Story.init)
            return stories
        } catch {
            return []
        }
    }
    
    func search(text: String) {
        guard let stories = self.stories else { return }
        
        var response = Stories.Fetch.Response()
        if !text.isEmpty {
            let filtered = stories.filter { $0.title.lowercased().contains(text.lowercased()) }
            response.stories = filtered
        } else {
            response.stories = stories
        }
    
        presenter?.presentStories(response: response)
    }
}
