//
//  UIView+Extension.swift
//  FaceGlasses
//
//  Created by alexander_balogh on 29.12.2022.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
