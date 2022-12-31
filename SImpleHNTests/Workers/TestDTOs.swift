//
//  TestDTOs.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 17.12.2022.
//

import Foundation
@testable import SImpleHN

enum TestDTO {
    static var allDTO = [TestDTO.story, TestDTO.comment1, TestDTO.comment2, TestDTO.comment3, TestDTO.comment4]
    
    static var story = HNItem.previewItem
    static var storyWithOutComments = HNItem(id: 1000,
                                             type: .story,
                                             by: "theyeti",
                                             time: 1425261906,
                                             kids: nil,
                                             title: "Test story for testing purposes",
                                             descendants: 100,
                                             score: 100,
                                             url: URL(string: "http://reactionwheel.net/2015/01/80s-vc.html")!,
                                             parent: 999,
                                             text: "Aw shucks, guys ... you make me blush with your compliments.<p>Tell you what, Ill make a deal: I'll keep writing if you keep reading. K?")
    
    static var comment1 = HNItem(id: 1,
                                 type: .comment,
                                 by: "test1",
                                 time: Date.now.timeIntervalSinceNow,
                                 kids: [2],
                                 title: nil,
                                 descendants: nil,
                                 score: nil,
                                 url: nil,
                                 parent: TestDTO.story.id,
                                 text: "test comment 1")
    
    static var comment2 = HNItem(id: 2,
                                 type: .comment,
                                 by: "test2",
                                 time: Date.now.timeIntervalSinceNow,
                                 kids: [3, 4],
                                 title: nil,
                                 descendants: nil,
                                 score: nil,
                                 url: nil,
                                 parent: TestDTO.comment1.id,
                                 text: "test comment 2")
    
    static var comment3 = HNItem(id: 3,
                                 type: .comment,
                                 by: "test3",
                                 time: Date.now.timeIntervalSinceNow,
                                 kids: [],
                                 title: nil,
                                 descendants: nil,
                                 score: nil,
                                 url: nil,
                                 parent: TestDTO.comment2.id,
                                 text: "test comment 3")
    
    static var comment4 =  HNItem(id: 4,
                                  type: .comment,
                                  by: "test4",
                                  time: Date.now.timeIntervalSinceNow,
                                  kids: [],
                                  title: nil,
                                  descendants: nil,
                                  score: nil,
                                  url: nil,
                                  parent: TestDTO.comment2.id,
                                  text: "test comment 4")
}
