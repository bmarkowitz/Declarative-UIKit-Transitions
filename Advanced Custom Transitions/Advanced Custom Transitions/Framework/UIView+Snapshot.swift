import UIKit

extension UIView {
    func copy(into containerView: UIView) -> UIView {
        let copiedView = type(of: self).init(frame: frame)

        // Setting this to true lets us manipulate the copy's positioning and size
        // via `frame` and `center` rather than Auto Layout constraints
        copiedView.translatesAutoresizingMaskIntoConstraints = true
        containerView.addSubview(copiedView)

        return copiedView
    }

    func snapshot(view: UIView, afterUpdates: Bool) -> UIView {
        let snapshot = view.snapshotView(afterScreenUpdates: afterUpdates) ?? UIView()
        self.addSubview(snapshot)
        snapshot.frame = self.convert(view.bounds, from: view)
        return snapshot
    }
}
