import UIKit

protocol DestinationContentViewDelegate: AnyObject {
    func didTapCard()
}

final class DestinationContentView: UIView {
    weak var delegate: DestinationContentViewDelegate?

    var properties: Properties = .default { didSet { render(from: oldValue, to: properties) } }

    private let tabView = TabView()
    private let cardView = CardView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        style()
        constrain()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func configure() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCard)))
        cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCard)))

        addSubview(tabView)
        addSubview(cardView)
    }

    private func style() {
        backgroundColor = .systemBackground
    }

    private func constrain() {
        let horizontalInset: CGFloat

        switch AnimationFeatureFlag().variant {
        case .airbnb:
            horizontalInset = 12
        case .bottomSheet:
            horizontalInset = 20
        }

        var constraints: [NSLayoutConstraint] = [
            tabView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            tabView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            tabView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            tabView.centerXAnchor.constraint(equalTo: centerXAnchor),

            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalInset),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalInset),
            cardView.heightAnchor.constraint(equalToConstant: 300)
        ]

        switch AnimationFeatureFlag().variant {
        case .airbnb:
            constraints.append(cardView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 65))
        case .bottomSheet:
            constraints.append(cardView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor))
        }

        NSLayoutConstraint.activate(constraints)
    }

    private func render(from old: Properties, to new: Properties) {
        guard old != new else { return }
    }

    @objc private func didTapCard() {
        delegate?.didTapCard()
    }
}

// MARK: - View Properties

extension DestinationContentView {
    struct Properties: Equatable {

        static let `default` = Properties()
    }
}
