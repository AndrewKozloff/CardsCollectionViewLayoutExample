//
//  ViewController.swift
//  CardsCollectionViewLayoutExample
//
//  Created by Андрей Козлов on 05.05.2021.
//

import UIKit

class ViewController: UIViewController {
	
	private var cards: [String] = [
		"First",
		"Second",
		"Third"
	]
	
	private let layout = CardsCollectionLayout()

	private lazy var collectionView: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
		let cardSize: CGFloat = 282
		layout.setupWidthAndInsets(cardWidth: cardSize)
		collection.backgroundColor = UIColor.lightGray
		collection.delegate = self
		collection.dataSource = self
		collection.decelerationRate = .fast
		collection.showsHorizontalScrollIndicator = false
		collection.register(cell: CardCollectionViewCell.self)
		return collection
	}()
	
	override func loadView() {
		view = collectionView
	}

}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) else { return }
		guard collectionView.bounds.contains(cell.frame) else {
			layout.animateBackwardScroll(to: indexPath.row)
			return
		}
	}
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cards.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: CardCollectionViewCell = collectionView.dequeueCell(for: indexPath)
		cell.fill(with: cards[indexPath.row])
		return cell
	}
}
