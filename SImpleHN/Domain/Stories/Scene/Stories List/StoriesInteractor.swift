//
//  StoriesInteractor.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import Foundation

protocol StoriesLogic {
    func fetch(request: Stories.Fetch.Request) async
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

extension StoriesInteractor: StoriesStore {

}

extension StoriesInteractor: StoriesLogic {
    func fetch(request: Stories.Fetch.Request) async {
        do {
            let newStoriesIds = try await worker.fetchLatest()
            let stories = await fetchStories(withIds: newStoriesIds)
            self.stories = stories
            let response = Stories.Fetch.Response(stories: stories)
            presenter?.presentStories(response: response)
        } catch (let error) {
            let errorResponse = Stories.Fetch.Response(error: error)
            presenter?.presentStories(response: errorResponse)
        }
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
}
