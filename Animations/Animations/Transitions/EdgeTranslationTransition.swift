import UIKit

final class EdgeTranslationTransition: Transition {

    private let source: EdgeTranslationSource
    private let viewToAnimate: UIView
    private let canvasView: UIView
    private let isInsertion: Bool

    public var animations: () -> Void = {}
    public var completion: () -> Void = {}

    init(source: EdgeTranslationSource,
         viewToAnimate: UIView,
         canvasView: UIView,
         isInsertion: Bool) {
        self.source = source
        self.viewToAnimate = viewToAnimate
        self.canvasView = canvasView
        self.isInsertion = isInsertion
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animateEdgeTranslation(transitionContext: transitionContext)
    }

    // MARK: - Animation

    private func animateEdgeTranslation(transitionContext: UIViewControllerContextTransitioning) {
        guard let transitionableView = viewToAnimate as? Transitionable
        else {
            return
        }

        let snapshot = transitionableView.snapshot(into: canvasView)
        snapshot.frame = viewToAnimate.frame

        if isInsertion {
            snapshot.alpha = 0
            snapshot.center = .init(x: canvasView.frame.midX,
                                    y: calculateSnapshotCenterY(snapshot: snapshot))
        }
        else {
            snapshot.alpha = 1
            snapshot.center = viewToAnimate.center
        }

        viewToAnimate.isHidden = true

        animations = {
            if self.isInsertion {
                snapshot.alpha = 1
                snapshot.frame = snapshot.frame
                snapshot.center = self.viewToAnimate.center
            }
            else {
                snapshot.alpha = 0
                snapshot.frame = snapshot.frame
                snapshot.center = .init(x: self.canvasView.frame.midX,
                                        y: self.calculateSnapshotCenterY(snapshot: snapshot))
            }
        }

        completion = {
            self.viewToAnimate.isHidden = false
        }
    }

    // MARK: - Helpers
    
    private func calculateSnapshotCenterY(snapshot: UIView) -> CGFloat {
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
