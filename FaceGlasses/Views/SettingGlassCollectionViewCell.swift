//
//  SettingGlassCollectionViewCell.swift
//  FaceGlasses
//
//  Created by alexander_balogh on 29.12.2022.
//

import UIKit

final class SettingGlassCollectionViewCell: SettingCollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    func setup(_ model: SettingGlasses) {
        super.setup(isSelected: model.isSelected)
        
        imageView.image = UIImage(named: model.imageTitle)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}
