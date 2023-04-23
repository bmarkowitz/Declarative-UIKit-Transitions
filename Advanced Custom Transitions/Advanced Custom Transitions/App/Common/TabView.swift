import UIKit

protocol TabViewDelegate: AnyObject {
}

final class TabView: UIView, Transitionable {
    var transitionIdentifier = SearchInput.topBar

    weak var delegate: TabViewDelegate?

    var properties: Properties = .default { didSet { render(from: oldValue, to: properties) } }

    private let stackView = UIStackView()
    private let leftTabLabel = UILabel()
    private let rightTabLabel = UILabel()

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
        translatesAutoresizingMaskIntoConstraints = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 12

        leftTabLabel.text = "Stays"
        leftTabLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        rightTabLabel.text = "Experiences"
        rightTabLabel.font = UIFont.systemFont(ofSize: 16)
        rightTabLabel.textColor = .secondaryLabel

        stackView.addArrangedSubview(leftTabLabel)
        stackView.addArrangedSubview(rightTabLabel)
        addSubview(stackView)
    }

    private func style() {
        backgroundColor = .clear
    }

    private func constrain() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func render(from old: Properties, to new: Properties) {
        guard old != new else { return }
    }
}

// MARK: - View Properties

extension TabView {
    struct Properties: Equatable {

        static let `default` = Properties()
    }
}
