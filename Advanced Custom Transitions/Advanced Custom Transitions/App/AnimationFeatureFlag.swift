import Foundation

final class AnimationFeatureFlag {
    // Change the variant here to see the other transition
    let variant: AnimationFeatureFlag.Variant = .airbnb

    var transitionDefinition: TransitionDefinition {
        switch variant {
        case .airbnb:
            return [SearchInput.whereCard: .sharedElement,
                    SearchInput.topBar: .translateY(-40)]
        case .bottomSheet:
            return [SearchInput.whereCard: .edgeTranslation(.bottom),
                    SearchInput.topBar: .crossfade]
        }
    }
}

extension AnimationFeatureFlag {
    enum Variant {
        case airbnb
        case bottomSheet
    }
}
