//
//  CardCollectionViewCell.swift
//  CardsCollectionViewLayoutExample
//
//  Created by Андрей Козлов on 05.05.2021.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 24)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.backgroundColor = .white
		contentView.layer.shadowOpacity = 0.5
		contentView.layer.shadowRadius = 10
		contentView.layer.shadowOffset = CGSize(width: 0, height: 20)
		contentView.layer.cornerRadius = 12
		
		contentView.addSubview(titleLabel)
		
		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
			titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func fill(with text: String) {
		titleLabel.text = text
	}
	
	@objc
	private func onDetailsButtonTap() {
		print("DETAILS")
	}
}
