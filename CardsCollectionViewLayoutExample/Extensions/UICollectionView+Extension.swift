//
//  UICollectionView+Extension.swift
//  CardsCollectionViewLayoutExample
//
//  Created by Андрей Козлов on 05.05.2021.
//

import UIKit

extension UICollectionView {
	func register(cell: UICollectionViewCell.Type) {
		register(cell, forCellWithReuseIdentifier: cell.reuseID)
	}
	
	func dequeueCell<CellType: UICollectionViewCell>(for indexPath: IndexPath) -> CellType {
		return dequeueReusableCell(withReuseIdentifier: CellType.reuseID, for: indexPath) as! CellType
	}
}

extension UICollectionViewCell {
	static var reuseID: String {
		String(describing: Self.self)
	}
}
