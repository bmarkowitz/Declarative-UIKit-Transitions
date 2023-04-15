import UIKit

final class DestinationViewController: UIViewController {
    let contentView = DestinationContentView()

    override func loadView() {
        contentView.delegate = self
        view = contentView
    }
}

extension DestinationViewController: DestinationContentViewDelegate {
    func didTapCard() {
        dismiss(animated: true)
    }
}
