import UIKit

final class TranslateYTransition: Transition {

    private let distance: CGFloat
    private let viewToAnimate: UIView
    private let isInsertion: Bool

    var animations: () -> Void = {}
    var completion: () -> Void = {}

    init(distance: CGFloat,
         viewToAnimate: UIView,
         isInsertion: Bool) {
        self.distance = distance
        self.viewToAnimate = viewToAnimate
        self.isInsertion = isInsertion
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning, in canvasView: UIView) {
        animateYTranslation(transitionContext: transitionContext,
                            canvasView: canvasView)
    }

    // MARK: - Animation

    private func animateYTranslation(transitionContext: UIViewControllerContextTransitioning, canvasView: UIView) {
        guard let transitionableView = viewToAnimate as? Transitionable
        else {
            return
        }

        let snapshot = transitionableView.snapshot(into: canvasView)
        snapshot.frame = viewToAnimate.frame

        if isInsertion {
            snapshot.alpha = 0
            snapshot.center = .init(x: viewToAnimate.center.x,
                                    y: viewToAnimate.center.y + distance)
        }
        else {
            snapshot.alpha = 1
            snapshot.center = viewToAnimate.center
        }

        viewToAnimate.isHidden = true

        animations = {
            snapshot.frame = snapshot.frame

            if self.isInsertion {
                snapshot.alpha = 1
                snapshot.center = self.viewToAnimate.center
            }
            else {
                snapshot.alpha = 0
                snapshot.center = .init(x: self.viewToAnimate.center.x,
                                        y: self.viewToAnimate.center.y + self.distance)
            }
        }

        completion = {
            self.viewToAnimate.isHidden = false
        }
    }
}
