# Declarative UIKit Transitions

This project is a very basic attempt to recreate the basics of Airbnb's internal declarative transition framework, as described in [this](https://medium.com/airbnb-engineering/motion-engineering-at-scale-5ffabfc878) Medium blog post by Cal Stephens ([@calda](https://github.com/calda)) -- it's a really great read, I highly recommend checking it out first.

At its core, the code makes use of a generic `UIViewControllerAnimatedTransitioning` implementation to transition from one view controller to another.

The transitions are driven by a `TransitionDefinition` object, which is a `typealias` for a key-value mapping of a `String` to an `AnimationType`.

The `AnimationType` looks like this:

```
enum  AnimationType {
    case crossfade
    case edgeTranslation(_ source: EdgeTranslationSource)
    case sharedElement
    case translateY(_ distance: CGFloat)
}
```

Views that would like to be involved in a view controller transition conform to `Transitionable`, which requires they provide a `transitionIdentifier`, which is just a `String` value to identify the element in the broader context of the transition, and optionally a custom snapshot implementation. If a custom implementation is not provided, the view is simple snapshotted using the native UIKit implementation.

In the project's current state, there are 2 views that conform to `Transitionable` - `CardView` and `TabView`.

`CardView` has a custom snapshot implementation, since it is involved in a shared element transition in which it grows from its initial state to its final state. The custom implementation creates an actual copy of the view by reinstantiating it.

A simple snapshot of the view - essentially an image - would cause the card to appear stretched during the transition as its frame is animated.

`TabView` does not have a custom implementation since it simply moves in and doesn't change size.

The `AnimationController` is provided with the `TransitionDefinition` and creates an `IdentifierHierarchy` for the source and destination views. This basic implementation doesn't really create a hierarchy, but rather a flat array of `Identifier` objects by traversing both view hierarchies and looking for `Transitionable` views.

The hierarchies are then diffed, resulting in an `IdentifierDiff` object which holds the insertions, removals, and shared identifiers between the 2 hierarchies.

For each set of identifiers, the animations are determined by switching on the `Identifier` object's desired `AnimationType`.

Then, there are 3 separate implementations of a `Transition` protocol - `EdgeTranslationTransition`, `SharedElementTransition`, and `TranslateYTransition` - which will create the animations and any necessary completion cleanup for the particular `AnimationType`.

The animations are added as key frames within a standard `UIView.animate` block and executed to completion.

<img src="https://github.com/bmarkowitz/declarative-uikit-transitions/blob/main/shared-element.gif" width="250" />
