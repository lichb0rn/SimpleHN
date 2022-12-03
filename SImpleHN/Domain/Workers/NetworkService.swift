//
//  StoriesService.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 23.11.2022.
//

import Foundation

protocol Service {
    func fetch(by id: Int) async throws -> HNItem
    func fetch(by ids: [Int]) async throws -> [HNItem]
}

protocol StoriesService: Service {
    func fetchLatest() async throws -> [Story.ID]
}

actor NetworkService: Service {
    private enum State {
        case inProgress(Task<HNItem, Error>)
        case completed(HNItem)
        case failed
    }
    
    private let networking = NetworkWorker()
    private var cache: [Int: State] = [:]
    
    func fetchLatest() async throws -> [Story.ID] {
        let newStoriesRequest = NewStoriesRequest()
        let newStoriesIds = try await networking.fetch(newStoriesRequest)
        return newStoriesIds
    }
    
    func fetch(by id: Int) async throws -> HNItem {
        if let cached = cache[id] {
            switch cached {
            case .completed(let item):
                return item
            case .inProgress(let task):
                return try await task.value
            case .failed:
                throw NetworkError.badServerResponse
            }
        }
        
        let downloadTask: Task<HNItem, Error> = Task.detached {
            let request = ItemRequest<HNItem>(id: id)
            return try await self.networking.fetch(request)
        }
        
        cache[id] = .inProgress(downloadTask)
        do {
            let item = try await downloadTask.value
            add(item, key: id)
            return item
        } catch {
            cache[id] = .failed
            throw NetworkError.badRequest(id)
        }
    }
    
    private func add(_ item: HNItem, key: Int) {
        cache[key] = cache[key, default: .completed(item)]
    }
    
    func fetch(by ids: [Int]) async throws -> [HNItem] {
        // We are doing a lot of requests here
        // So, some of them with fail
        // Don't care about that
        let items = await withTaskGroup(of: HNItem?.self) { group in
            ids.forEach { id in
                group.addTask {
                    return try? await self.fetch(by: id)
                }
            }
            
            var fetched = [HNItem]()
            fetched.reserveCapacity(ids.count)
            
            for await item in group.compactMap({$0}) {
                fetched.append(item)
            }
            return fetched
        }
        return items
    }
}

extension NetworkService: StoriesService {}
