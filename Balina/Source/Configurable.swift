//
//  Configurable.swift
//  Balina
//
//  Created by Roman on 9/24/23.
//

import Foundation

public protocol Configurable {
    associatedtype ViewModel
    /// Конфигурирует view с экземпляром associatedtype type ViewModel
    /// Экземпляр ViewModel содержащий данные необходимые для отображения view
    func configure(with viewModel: ViewModel)
}
