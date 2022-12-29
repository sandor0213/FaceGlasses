//
//  SettingCollectionViewCell.swift
//  FaceGlasses
//
//  Created by alexander_balogh on 29.12.2022.
//

import UIKit

class SettingCollectionViewCell: UICollectionViewCell {
    func setup(isSelected: Bool) {
        cornerRadius = frame.height / 2
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.borderWidth = isSelected ? 4 : 0
    }
}
