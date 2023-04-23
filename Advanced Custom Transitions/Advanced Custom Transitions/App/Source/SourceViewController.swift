import SwiftUI
import UIKit

final class SourceViewController: UIViewController {
    private let state = State()
    
    private let contentView = SourceContentView()
    
    override func loadView() {
        contentView.delegate = self
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        render()
    }
    
    private func render() {
        contentView.properties = state.mapToViewProperties()
    }
}

// MARK: - SourceViewDelegate

extension SourceViewController: SourceContentViewDelegate {
    func didTapCard() {
        let viewController = DestinationViewController()

        viewController.modalPresentationStyle = .fullScreen
        viewController.transitioningDelegate = self
        present(viewController, animated: true)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension SourceViewController: UIViewControllerTransitioningDelegate {
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        nil
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let transitionDefinition: TransitionDefinition = AnimationFeatureFlag().transitionDefinition

        return AnimationController(transitionDefinition: transitionDefinition)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transitionDefinition: TransitionDefinition = AnimationFeatureFlag().transitionDefinition

        return AnimationController(transitionDefinition: transitionDefinition)
    }
}

// MARK: - State

extension SourceViewController {
    final class State {
        
        func mapToViewProperties() -> SourceContentView.Properties {
            return .init()
        }
    }
}
