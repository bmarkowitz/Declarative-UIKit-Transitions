import UIKit

// A protocol that lets us involve a view in a transition
// We tag it with a transition identifier, which will be used to determine
// If it's being inserted or removed from the visible view
// Or if it's being carried over (shared element) in a slightly different form (usually size)
protocol Transitionable {
    var transitionIdentifier: String { get }

    func snapshot(into containerView: UIView) -> UIView
}

// Default implementation of snapshotting for a Transitionable view
// We call an extension which snapshots the view using the native UIView API,
// and then converts the view's coordinates to the coordinate space of its container
// Ex: parent view at x: 25, y: 25 with a subview at x: 25, y: 25.
// Subview's new frame will be at x: 50, y: 50
extension Transitionable {
    func snapshot(into containerView: UIView) -> UIView {
        guard let viewToSnapshot = self as? UIView else { return UIView() }

        let snapshot = containerView.snapshot(view: viewToSnapshot, afterUpdates: true)
        return snapshot
    }
}
