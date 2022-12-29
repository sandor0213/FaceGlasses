//
//  SettingColorCollectionViewCell.swift
//  FaceGlasses
//
//  Created by alexander_balogh on 29.12.2022.
//

import UIKit

final class SettingColorCollectionViewCell: SettingCollectionViewCell {
    
    @IBOutlet private weak var colorView: UIView!
    
    func setup(_ model: SettingColor) {
        super.setup(isSelected: model.isSelected)
        
        colorView.backgroundColor = model.color
    }
}
