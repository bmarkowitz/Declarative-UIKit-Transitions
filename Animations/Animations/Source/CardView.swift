import UIKit

final class CardView: UIView {
    let transitionIdentifier = BottomSheet.foregroundView

    public let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        style()
        constrain()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Where to?"

        addSubview(label)
    }

    private func style() {
        layer.borderColor = UIColor.secondarySystemFill.cgColor
        layer.borderWidth = 1.5
        layer.cornerCurve = .continuous
        layer.cornerRadius = 30

        backgroundColor = .systemBackground
    }

    private func constrain() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: topAnchor, constant: 30)
        ])
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        layer.borderColor = UIColor.secondarySystemFill.cgColor
    }
}

// MARK: - Transitionable

extension CardView: Transitionable {
    func snapshot(into view: UIView) -> UIView {
        return copy(into: view)
    }
}
