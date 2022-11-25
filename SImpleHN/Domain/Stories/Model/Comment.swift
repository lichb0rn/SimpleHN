//
//  Comment.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 25.11.2022.
//

import Foundation

struct Comment: Codable {
    let by: String
    let id: Int
    let kids: [Int]
    let parent: Int
    let text: String
    let time: TimeInterval
}
