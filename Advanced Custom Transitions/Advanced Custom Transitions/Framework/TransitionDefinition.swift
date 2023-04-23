import UIKit

// MARK: - Transition Definition API

typealias TransitionDefinition = [String: AnimationType]

enum AnimationType {
    case crossfade
    case edgeTranslation(_ source: EdgeTranslationSource)
    case sharedElement
    case translateY(_ distance: CGFloat)
}

enum EdgeTranslationSource {
    case top
    case bottom
}

// MARK: - Animation Tags

struct SearchInput {
    static let whereCard = "SearchInput.whereCard"
    static let whereCardContent = "SearchInput.whereCardContent"
    static let topBar = "SearchInput.topBar"
}
