//
//  StoriesModel.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import Foundation

enum Stories {
    enum Fetch {
        struct Request {
            enum RequestType: String {
                case new = "New"
                case top = "Top"
            }
            let type: RequestType
        }
        
        struct Response {
            var stories: [Story]?
            var error: Error?
        }
        
        struct ViewModel {
            struct DisplayedStory: Identifiable, Hashable {
                let id: Int
                var title: String
                let score: String
                let author: String
                let commentsCount: String
                let timePosted: String
                let url: String?
                let glyph: StoryType
                
                init(story: Story, timePosted: String) {
                    self.id = story.id
                    self.title = story.title
                    self.score = "\(story.score)"
                    self.author = "\(story.by)"
                    self.commentsCount = "\(story.descendants)"
                    self.timePosted = timePosted
                    self.url = story.link
                    self.glyph = story.text == nil ? .link : .text
                }
            }
            
            var success: Bool
            var stories: [DisplayedStory]?
            var errorMessage: String?
        }
    }
}

extension Stories.Fetch.ViewModel.DisplayedStory {
    enum StoryType: String {
        case link = "globe"
        case text = "doc.text"
    }
}

extension Stories.Fetch.ViewModel {
    static func previewViewModel() -> Stories.Fetch.ViewModel {
        var vm = Stories.Fetch.ViewModel(success: true)
        vm.stories = []
        for _ in 0..<30 {
            vm.stories?.append(DisplayedStory(story: Story.previewStory,
                                              timePosted: RelativeTimeFormatter.relativeTime(fromInterval: Double.random(in: 1...100),
                                                                                             relativeTo: .now) ))
        }
        return vm
    }
}
