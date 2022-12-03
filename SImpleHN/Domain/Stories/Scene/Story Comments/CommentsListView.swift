//
//  CommentsView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 26.11.2022.
//

import SwiftUI

protocol CommentsDisplayLogic {
    func displayComment(viewModel:  Comments.GetCommentsList.ViewModel)
}

struct CommentsListView: View {
    
    
    var dummy: [String] = {
        var a = [String]()
        for i in 0...20 {
            a.append("Hello world \(i)")
        }
        return a
    }()
    
    var body: some View {
        LazyVStack {
            ForEach(dummy, id: \.self) { str in
                Text(str)
            }
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsListView()
    }
}
