# SimpleHN

This is a simple HackerNews reader iOS app.

<p float="left">
    <img src="iphone.png" width="19%">
    <img src="ipad.png" width="80%">
</p>

## Motivation

My main goal is to practice Clean Swift (VIP) architecure.
You can read more about it here: https://clean-swift.com

## Technology stack

- SwiftUI
- Swift Concurency (async/await)
- iOS 16 navgiation (NavigationSplitView, NavigationStack)

## Random thoughts about it

- Unidirectional flow control is trully awesome. Easy to test, easy to reason about what goes where.
- Sometimes it feels like fighting the framework. I.e. I'd rather have `@Published` properties in the presenter, although it's "forbidden" by the architecture since views do know nothing about presenters.
- Nested types look a little bit weird, i.e `Comments.GetCommentsList.ViewModel.DisplayedComment`. 
- Navigation feels awkward, but that's probably SwiftUI problem.
