//
//  ContentTableViewCell.swift
//  Balina
//
//  Created by Roman on 9/24/23.
//

import SnapKit

final class ContentTableViewCell: UITableViewCell {
    // MARK: - Public Properties
    
    static let identifier = "ContentTableViewCell"
    
    // MARK: - Subview Properties
    
    private lazy var verticalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 15
    }
    
    private lazy var containerImageView = UIView()
    
    private lazy var customImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "Value: "
    }
    
    // MARK: - UIView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    public required init?(coder: NSCoder) { nil }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        verticalStackView.addArrangedSubview(titleLabel)
        containerImageView.addSubview(customImageView)
        verticalStackView.addArrangedSubview(containerImageView)
        addSubview(verticalStackView)
    }
    
    private func makeConstraints() {
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        customImageView.snp.makeConstraints { make in
            make.top.leading.trailing.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.size.equalTo(50)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - Configurable

extension ContentTableViewCell: Configurable {
    struct ViewModel: Hashable, Equatable {
        let title: String
        let imageURLString: String
    }
    
    public func configure(with viewModel: ContentTableViewCell.ViewModel) {
        titleLabel.text = viewModel.title
        
        let imageURL = URL(string: viewModel.imageURLString)
        containerImageView.isHidden = imageURL == nil
        guard let url = imageURL else { return }
        let data = try? Data(contentsOf: url)
        guard let imageData = data else { return }
        customImageView.image = UIImage(data: imageData)
    }
}
