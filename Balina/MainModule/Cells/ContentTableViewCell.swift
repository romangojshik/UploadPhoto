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
        addSubview(titleLabel)
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }
}

// MARK: - Configurable

extension ContentTableViewCell: Configurable {
    struct ViewModel: Hashable, Equatable {
       let title: String
   }

    public func configure(with viewModel: ContentTableViewCell.ViewModel) {
       titleLabel.text = viewModel.title
   }
}
