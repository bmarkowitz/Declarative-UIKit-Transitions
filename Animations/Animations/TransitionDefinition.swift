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

struct BottomSheet {
    static let foregroundView = "BottomSheet.foregroundView"
}

struct Destination {
    static let tabView = "Destination.tabView"
}

// MARK: - Utilities

extension UIView {
    func copy(into containerView: UIView) -> UIView {
        let copiedView = type(of: self).init(frame: frame)
        copiedView.translatesAutoresizingMaskIntoConstraints = true
        containerView.addSubview(copiedView)

        return copiedView
    }

    func snapshotView(view: UIView, afterUpdates: Bool) -> UIView {
        let snapshot = view.snapshotView(afterScreenUpdates: afterUpdates) ?? UIView()
        self.addSubview(snapshot)
        snapshot.frame = convert(view.bounds, from: view)
        return snapshot
    }
}
