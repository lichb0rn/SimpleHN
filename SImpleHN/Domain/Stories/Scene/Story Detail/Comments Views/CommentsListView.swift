//
//  CommentsView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 26.11.2022.
//

import SwiftUI


struct CommentsListView<Data, RowContent>: View where Data: RandomAccessCollection, Data.Element: Identifiable, RowContent: View {
    
    private let nodeView: NodeView<Data, RowContent>
    
    init(data: Data, children: KeyPath<Data.Element, Data?>, rowContent: @escaping (Data.Element) -> RowContent) {
        self.nodeView = NodeView(data: data, children: children, rowContent: rowContent)
    }
    
    var body: some View {
        List {
            nodeView
        }
        .listStyle(.plain)
    }
    
}

fileprivate struct NodeView<Data, RowContent>: View where Data: RandomAccessCollection, Data.Element: Identifiable, RowContent: View {
    
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
            }
        }
        
    }
    
    func hasChild(_ element: Data.Element) -> Bool {
        return element[keyPath: children] != nil
    }
}

fileprivate struct CommentDisclosureGroup<Label, Content>: View where Label: View, Content: View {
    @State var isExpanded: Bool = true
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
                .animation(.easeInOut, value: isExpanded)
        }
    }
}
