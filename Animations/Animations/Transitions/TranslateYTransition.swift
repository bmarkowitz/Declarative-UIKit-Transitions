import UIKit

final class TranslateYTransition: Transition {

    private let distance: CGFloat
    private let viewToAnimate: UIView
    private let canvasView: UIView
    private let isInsertion: Bool

    public var animations: () -> Void = {}
    public var completion: () -> Void = {}

    init(distance: CGFloat,
         viewToAnimate: UIView,
         canvasView: UIView,
         isInsertion: Bool) {
        self.distance = distance
        self.viewToAnimate = viewToAnimate
        self.canvasView = canvasView
        self.isInsertion = isInsertion
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animateYTranslation(transitionContext: transitionContext)
    }

    // MARK: - Animation

    private func animateYTranslation(transitionContext: UIViewControllerContextTransitioning) {
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
