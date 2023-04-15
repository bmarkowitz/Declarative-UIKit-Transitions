import UIKit

final class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let transitionDefinition: TransitionDefinition

    private var animations: [() -> Void] = []
    private var completions: [() -> Void] = []

    init(transitionDefinition: TransitionDefinition) {
        self.transitionDefinition = transitionDefinition
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to),
              let toView = transitionContext.view(forKey: .to)
        else {
            transitionContext.completeTransition(true)
            return
        }

        // Hide the `to` view and add it to the container view
        // Our snapshots will serve as visual stand-ins during the animation
        // And the `to` view will be unhidden at the very end
        let containerView = transitionContext.containerView
        toView.frame = transitionContext.finalFrame(for: toViewController)
        toView.alpha = 0
        containerView.addSubview(toView)

        // Create a separate canvas to animate our snapshots in
        // This way, we can just get rid of the canvas at the end
        // Which will also get rid of the snapshots inside of it
        let canvas = UIView(frame: containerView.bounds)
        containerView.addSubview(canvas)
        containerView.layoutIfNeeded()

        containerView.backgroundColor = fromView.backgroundColor

        // Create identifier hierarchy of source and destination views
        let fromHierarchy = createHierarchy(for: fromView)
        let toHierarchy = createHierarchy(for: toView)

        // Diff the hierarchies to determine inserted, removed, & shared identifiers
        let diff = toHierarchy.diffed(with: fromHierarchy)

        // Create animations for insertions
        for identifier in diff.inserted {
            determineAnimation(for: identifier, in: canvas, with: transitionContext, isInsertion: true)
        }

        // Create animations for removals
        for identifier in diff.removed {
            determineAnimation(for: identifier, in: canvas, with: transitionContext, isInsertion: false)
        }

        // Create animations for shared elements
        for identifier in diff.shared {
            determineAnimation(for: identifier, in: canvas, with: transitionContext)
        }

        // Loop through animations provided by our Transition objects, adding each one as a key frame
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 0,
                       options: [.curveEaseInOut],
                       animations: {
            for animation in self.animations {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: animation)
            }

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0) {
                canvas.backgroundColor = toView.backgroundColor
            }
        }) { completed in
            for completion in self.completions {
                completion()
            }
            self.animations = []
            self.completions = []
            canvas.removeFromSuperview()
            toView.alpha = 1
            transitionContext.completeTransition(completed)
        }
    }

    // MARK: - Helpers

    private func createHierarchy(for view: UIView) -> [Identifier] {
        var identifierHierarchy: [Identifier] = []

        // Go through each subview of the source view
        for view in view.subviews {
            guard let transitionableView = view as? Transitionable,
                  transitionDefinition.keys.contains(transitionableView.transitionIdentifier)
            else { continue }

            // If it's transitionable, create an Identifier object
            let identifier = Identifier(view: view,
                                        transitionIdentifier: transitionableView.transitionIdentifier)
            identifierHierarchy.append(identifier)
        }

        return identifierHierarchy
    }

    private func determineAnimation(for identifier: Identifier, in canvas: UIView, with transitionContext: UIViewControllerContextTransitioning, isInsertion: Bool = false) {
        guard let animationType = transitionDefinition[identifier.transitionIdentifier] else { return }

        let transition: Transition

        switch animationType {
        case .crossfade:
            return
        case .edgeTranslation(let source):
            transition = EdgeTranslationTransition(source: source,
                                                   viewToAnimate: identifier.view,
                                                   canvasView: canvas,
                                                   isInsertion: isInsertion)
        case .sharedElement:
            transition = SharedElementTransition(fromView: identifier.view,
                                                 toView: identifier.sharedView ?? UIView(),
                                                 canvasView: canvas)

        case .translateY(let distance):
            transition = TranslateYTransition(distance: distance,
                                              viewToAnimate: identifier.view,
                                              canvasView: canvas,
                                              isInsertion: isInsertion)
        }

        transition.animateTransition(using: transitionContext)
        animations.append(transition.animations)
        completions.append(transition.completion)
    }
}

// MARK: - SamplePresentationController

final class SamplePresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool {
        return true
    }
}
