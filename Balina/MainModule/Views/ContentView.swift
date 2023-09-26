//
//  ContentView.swift
//  Balina
//
//  Created by Roman on 9/23/23.
//

import UIKit

// MARK: - ContentViewProtocol
protocol ContentViewProtocol: AnyObject {
    func loadMoreInformation()
    func openCameraFromDevice(idTitle: Int)
}

public final class ContentView: UIView {
    // MARK: - Public Properties
    
    weak var delegate: ContentViewProtocol?
    
    // MARK: - Subview Properties
    
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = .lightGray
        $0.delegate = self
        $0.dataSource = self
        $0.register(
            ContentTableViewCell.self,
            forCellReuseIdentifier: ContentTableViewCell.identifier
        )
    }
    
    // MARK: - Private Properties
    
    private var contentViewModel: [ContentViewModel] = []
    private var isLoadingList : Bool = false
    
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(tableView)
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Configurable

extension ContentView: Configurable {
    public struct ViewModel {
        let contentViewModel: [ContentViewModel]
        let isLoadingList: Bool
    }
    
    public func configure(with viewModel: ViewModel) {
        contentViewModel = viewModel.contentViewModel
        tableView.reloadData()
        isLoadingList = viewModel.isLoadingList
    }
}

// MARK: - UITableViewDataSource

extension ContentView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ContentTableViewCell.identifier, for: indexPath as IndexPath
        ) as? ContentTableViewCell else {
            fatalError("Error")
        }
        
        let titles = contentViewModel.map { $0.name }
        let imageURLStrings = contentViewModel.map { $0.imageURLString }
        cell.configure(with: .init(
            title: titles[indexPath.row],
            imageURLString: imageURLStrings[indexPath.row] ?? ""
        ))
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentViewModel.count
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            delegate?.loadMoreInformation()
        }
    }
    
}

extension ContentView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.openCameraFromDevice(idTitle: contentViewModel[indexPath.row].id)
        print(contentViewModel[indexPath.row].id)
    }
}
