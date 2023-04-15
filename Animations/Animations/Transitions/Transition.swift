import UIKit

protocol Transition {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)

    var animations: () -> Void { get }
    var completion: () -> Void { get }
}
