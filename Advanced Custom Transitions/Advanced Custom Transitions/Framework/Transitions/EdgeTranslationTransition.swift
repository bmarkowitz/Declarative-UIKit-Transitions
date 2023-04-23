import UIKit

final class EdgeTranslationTransition: Transition {

    private let source: EdgeTranslationSource
    private let viewToAnimate: UIView
    private let isInsertion: Bool

    var animations: () -> Void = {}
    var completion: () -> Void = {}

    init(source: EdgeTranslationSource,
         viewToAnimate: UIView,
         isInsertion: Bool) {
        self.source = source
        self.viewToAnimate = viewToAnimate
        self.isInsertion = isInsertion
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning, in canvasView: UIView) {
        animateEdgeTranslation(transitionContext: transitionContext,
                               canvasView: canvasView)
    }

    // MARK: - Animation

    private func animateEdgeTranslation(transitionContext: UIViewControllerContextTransitioning, canvasView: UIView) {
        guard let transitionableView = viewToAnimate as? Transitionable
        else {
            return
        }

        let snapshot = transitionableView.snapshot(into: canvasView)
        snapshot.frame = viewToAnimate.frame

        if isInsertion {
            snapshot.center = .init(x: canvasView.frame.midX,
                                    y: centerY(for: snapshot, in: canvasView))
        }
        else {
            snapshot.center = viewToAnimate.center
        }

        viewToAnimate.isHidden = true

        animations = {
            if self.isInsertion {
                snapshot.center = self.viewToAnimate.center
            }
            else {
                snapshot.center = .init(x: canvasView.frame.midX,
                                        y: self.centerY(for: snapshot, in: canvasView))
            }
        }

        completion = {
            self.viewToAnimate.isHidden = false
        }
    }

    // MARK: - Helpers
    
    private func centerY(for snapshot: UIView, in canvasView: UIView) -> CGFloat {
        let verticalOffset: CGFloat = 20
        let yOffset: CGFloat = (snapshot.frame.size.height / 2) + verticalOffset

        switch source {
        case .top:
            return canvasView.frame.minY - yOffset
        case .bottom:
            return canvasView.frame.maxY + yOffset
        }
    }
}
