import UIKit

final class SharedElementTransition: Transition {

    private let fromView: UIView
    private let toView: UIView

    var animations: () -> Void = {}
    var completion: () -> Void = {}

    init(fromView: UIView,
         toView: UIView) {
        self.fromView = fromView
        self.toView = toView
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning, in canvasView: UIView) {
        animateSharedElementTransition(transitionContext: transitionContext,
                                       canvasView: canvasView)
    }

    // MARK: - Animation

    private func animateSharedElementTransition(transitionContext: UIViewControllerContextTransitioning, canvasView: UIView) {
        guard let transitionableFromView = fromView as? Transitionable,
              let transitionableToView = toView as? Transitionable
        else {
            return
        }

        // Create copies of the from and to views
        let fromSnapshot = transitionableFromView.snapshot(into: canvasView)
        let toSnapshot = transitionableToView.snapshot(into: canvasView)

        // Store the final, desired positions
        let targetCenter = toView.center
        let targetFrame = toView.frame

        // Hide fromView, snapshot will serve as visual stand-in
        // toView already hidden in animation controller
        fromView.alpha = 0

        // Place fromSnapshot at starting point
        fromSnapshot.frame = fromView.frame
        fromSnapshot.center = fromView.center

        // Hide toSnapshot and position at starting point
        toSnapshot.alpha = 0
        toSnapshot.frame = fromSnapshot.frame
        toSnapshot.center = fromSnapshot.center

        animations = {
            // Animate fromSnapshot out + towards final position
            fromSnapshot.alpha = 0
            fromSnapshot.frame = targetFrame
            fromSnapshot.center = targetCenter

            // Animate toSnapshot in + towards final position
            toSnapshot.alpha = 1
            toSnapshot.frame = targetFrame
            toSnapshot.center = targetCenter
        }

        completion = {
            self.fromView.alpha = 1
        }
    }
}
