//
//  MetaInforamtionView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 25.11.2022.
//

import SwiftUI

struct MetaInformationView: View {
    
    var author: String
    var posted: String
    var repliesCount: String
    var score: String? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            if let score {
                glyph(name: "heart.fill", label: score)
            }
            glyph(name: "person.fill", label: author)
            glyph(name: "clock.arrow.circlepath", label: posted)
            glyph(name: "bubble.left.fill", label: repliesCount)
        }
    }
    
    private func glyph(name: String, label: String) -> some View {
        HStack(spacing: 2) {
            Image(systemName: name)
            Text(label)
        }
    }
}

struct MetaInforamtionView_Previews: PreviewProvider {
    static var previews: some View {
        MetaInformationView(
            author: "paprika",
            posted: "1 minute ago",
            repliesCount: "170",
            score: "315"
        )
    }
}
