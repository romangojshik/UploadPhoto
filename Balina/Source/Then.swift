//
//  Then.swift
//  Balina
//
//  Created by Roman on 9/23/23.
//

import Foundation

/// Протокол для конфигурации объекта после его создания
public protocol Then {}

/// Расширение для NSObject, которое позволяет конфигурировать NSObject сразу после его создания
/// Под NSObject попадают все элементы UIKit, а также большенство из Foundation, поддающееся конфигурации
extension Then where Self: NSObject {
    @inlinable public func then(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

/// Подпись NSObject'а под протокол Then
extension NSObject: Then {}
