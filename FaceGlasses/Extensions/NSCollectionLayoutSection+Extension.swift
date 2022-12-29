//
//  NSCollectionLayoutSection+Extension.swift
//  FaceGlasses
//
//  Created by alexander_balogh on 29.12.2022.
//

import UIKit

extension NSCollectionLayoutSection {
    static let collectionLayoutSection: NSCollectionLayoutSection = {
        let contentInset: CGFloat = 5
        let groupWidthHeight: CGFloat = 80
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: contentInset, leading: contentInset, bottom: contentInset, trailing: contentInset)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(groupWidthHeight), heightDimension: .estimated(groupWidthHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }()
}
