//
//  CommentsView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 26.11.2022.
//

import SwiftUI


struct CommentsListView: View {
    
    @ObservedObject var viewState: CommentsViewState
    
    var body: some View {
        renderCommentsState(viewState.status)
            .task {
                await viewState.getComments()
            }
    }
    
    @ViewBuilder
    private func renderCommentsState(_ state: CommentsViewState.Status) -> some View {
        Group {
            switch state {
            case .idle:
                Text("Nothing to show")
            case .fetching:
                Spacer()
                ProgressView()
                Spacer()
            case .fetched:
                LazyVStack(alignment: .leading) {
                    NodeView(data: viewState.comments, children: \.replies) { comment in
                        CommentView(displayedComment: comment.displayedComment)
                            .padding(.vertical, 4)
                            .task {
                                await viewState.getReplies(for: comment.id)
                            }
                    }
                    .transition(.move(edge: .leading))
                }
                .padding(.horizontal)
            case .error(let msg):
                Text(msg)
            }
        }
    }
}


fileprivate struct NodeView<Data, RowContent>: View
where Data: RandomAccessCollection,
        Data.Element: ObservableObject & Identifiable,
        RowContent: View {
    
    let data: Data
    let children: KeyPath<Data.Element, Data?>
    let rowContent: (Data.Element) -> RowContent

    var body: some View {
        ForEach(data) { child in
            if hasChild(child) {
                CommentDisclosureGroup {
                    NodeView(data: child[keyPath: self.children]!, children: self.children, rowContent: self.rowContent)
                        .padding(.leading)
                        .overlay(alignment: .leading) {
                            Rectangle()
                                .frame(width: 2)
                        }
                } label: {
                    self.rowContent(child)
                }
            } else {
                rowContent(child)
                Divider()
            }

        }
    }
    
    func hasChild(_ element: Data.Element) -> Bool {
        return element[keyPath: children] != nil
    }
}


fileprivate struct CommentDisclosureGroup<Label, Content>: View where Label: View, Content: View {
    @State var isExpanded: Bool = false
    @ViewBuilder var content: () -> Content
    @ViewBuilder var label: () -> Label
    
    @ViewBuilder
    var body: some View {
        Button(action: {
            withAnimation {
                self.isExpanded.toggle()
            }
        }, label: {
            label()
        })
        
        if isExpanded {
            content()
        }
    }
}
