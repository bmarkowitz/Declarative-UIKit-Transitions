import UIKit

protocol SourceContentViewDelegate: AnyObject {
    func didTapCard()
}

final class SourceContentView: UIView {
    weak var delegate: SourceContentViewDelegate?

    var properties: Properties = .default { didSet { render(from: oldValue, to: properties) } }

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

        switch AnimationFeatureFlag().variant {
        case .airbnb:
            addSubview(cardView)
        case .bottomSheet:
            return
        }
    }

    private func style() {
        backgroundColor = .systemBackground
    }

    private func constrain() {
        var constraints: [NSLayoutConstraint] = [
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            cardView.heightAnchor.constraint(equalToConstant: 60)
        ]

        switch AnimationFeatureFlag().variant {
        case .airbnb:
            constraints.append(cardView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor))
        case .bottomSheet:
            return
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

extension SourceContentView {
    struct Properties: Equatable {

        static let `default` = Properties()
    }
}
