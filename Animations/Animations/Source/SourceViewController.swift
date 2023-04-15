import UIKit

final class SourceViewController: UIViewController {
    private let state = State()
    
    let contentView = SourceContentView()
    
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

        let transitionDefinition: TransitionDefinition = [BottomSheet.foregroundView: .sharedElement,
                                                          Destination.tabView: .translateY(-40)]

        return AnimationController(transitionDefinition: transitionDefinition)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transitionDefinition: TransitionDefinition = [BottomSheet.foregroundView: .sharedElement,
                                                          Destination.tabView: .translateY(-40)]

        return AnimationController(transitionDefinition: transitionDefinition)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SamplePresentationController(presentedViewController: presented, presenting: presenting)
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
