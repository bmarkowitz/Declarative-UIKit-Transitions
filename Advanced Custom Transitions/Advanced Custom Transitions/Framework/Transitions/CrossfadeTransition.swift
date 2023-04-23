import UIKit

final class CrossfadeTransition: Transition {

    private let viewToAnimate: UIView
    private let isInsertion: Bool

    var animations: () -> Void = {}
    var completion: () -> Void = {}

    init(viewToAnimate: UIView,
         isInsertion: Bool) {
        self.viewToAnimate = viewToAnimate
        self.isInsertion = isInsertion
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning, in canvasView: UIView) {
        animateCrossfadeTranslation(transitionContext: transitionContext,
                                    canvasView: canvasView)
    }

    // MARK: - Animation

    private func animateCrossfadeTranslation(transitionContext: UIViewControllerContextTransitioning, canvasView: UIView) {
        guard let transitionableView = viewToAnimate as? Transitionable
        else {
            return
        }

        let snapshot = transitionableView.snapshot(into: canvasView)
        snapshot.frame = viewToAnimate.frame
        snapshot.center = viewToAnimate.center

        if isInsertion {
            snapshot.alpha = 0
        }
        else {
            snapshot.alpha = 1
        }

        viewToAnimate.isHidden = true

        animations = {
            snapshot.frame = snapshot.frame

            if self.isInsertion {
                snapshot.alpha = 1
            }
            else {
                snapshot.alpha = 0
            }
        }

        completion = {
            self.viewToAnimate.isHidden = false
        }
    }
}
