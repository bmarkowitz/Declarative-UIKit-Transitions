import UIKit

protocol DestinationContentViewDelegate: AnyObject {
    func didTapCard()
}

final class DestinationContentView: UIView {
    weak var delegate: DestinationContentViewDelegate?

    var properties: Properties = .default { didSet { render(from: oldValue, to: properties) } }

    let tabView = TabView()
    let cardView = CardView()

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
        cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCard)))

        addSubview(tabView)
        addSubview(cardView)
    }

    private func style() {
        backgroundColor = .systemBackground
    }

    private func constrain() {
        NSLayoutConstraint.activate([
            tabView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            tabView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            tabView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            tabView.centerXAnchor.constraint(equalTo: centerXAnchor),

            cardView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            cardView.heightAnchor.constraint(equalToConstant: 250)
        ])
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
