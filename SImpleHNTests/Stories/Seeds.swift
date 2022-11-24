//
//  Seeds.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import Foundation
@testable import SImpleHN

enum Seeds {
    static let stories: [Story] = [Seeds.story]
    
    static let story: Story = Story(id: 9129911,
                                    title: "Venture Capital in the 1980s",
                                    by: "theyeti",
                                    descendants: 16,
                                    score: 78,
                                    time: 1425261906,
                                    url: URL(string: "http://reactionwheel.net/2015/01/80s-vc.html")!
    )
}
