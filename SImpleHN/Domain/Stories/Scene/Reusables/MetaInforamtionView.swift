//
//  MetaInforamtionView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 25.11.2022.
//

import SwiftUI

struct MetaInforamtionView: View {
    
    let score: String
    let author: String
    let posted: String
    let commentsCount: String
    
    var body: some View {
        HStack(spacing: 12) {
            glyph(name: "plusminus", label: score)
            glyph(name: "person.fill", label: author)
            glyph(name: "clock.arrow.circlepath", label: posted)
            glyph(name: "bubble.left.fill", label: commentsCount)
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
        MetaInforamtionView(
            score: "315",
            author: "paprika",
            posted: "1 minute ago",
            commentsCount: "170"
        )
    }
}
