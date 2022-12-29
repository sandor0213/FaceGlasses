//
//  Reusable+Extension.swift
//  FaceGlasses
//
//  Created by alexander_balogh on 29.12.2022.
//

import UIKit

public protocol Reusable {
    static var identifier: String { get }
}

extension Reusable {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UIView: Reusable {}
