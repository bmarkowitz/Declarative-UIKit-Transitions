import UIKit

protocol Transition {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning,
                           in canvasView: UIView)

    var animations: () -> Void { get }
    var completion: () -> Void { get }
}
