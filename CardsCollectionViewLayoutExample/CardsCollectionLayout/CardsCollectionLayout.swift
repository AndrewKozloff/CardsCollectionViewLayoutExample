//
//  CardsCollectionLayout.swift
//  CardsCollectionViewLayoutExample
//
//  Created by Андрей Козлов on 05.05.2021.
//

import UIKit

class CardsCollectionLayout: UICollectionViewLayout {
	
	private(set) var minimumInteritemSpacing: CGFloat = 24
	
	private(set) var cache: CardFrameCalculator = .zero
	
	private(set) var currentItemIndex: Int = 0
	
	private let section = 0
	
	private let scaleFactor: CGFloat = 0.12
	
	var itemSize: CGSize = .zero {
		didSet {
			invalidateLayout()
		}
	}
	
	var contentInset: UIEdgeInsets = .zero {
		didSet {
			collectionView!.contentInset = contentInset
		}
	}
	
	func setupWidthAndInsets(cardWidth: CGFloat) {
		itemSize = CGSize(width: cardWidth, height: cardWidth * 1.45)
		contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24 + cardWidth)
	}
	
	override var collectionViewContentSize: CGSize {
		cache.contentSize
	}
	
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
	
	override func prepare() {
		super.prepare()
		let numberOfItems = collectionView!.numberOfItems(inSection: section)
		
		cache = CardFrameCalculator(
			itemSize: itemSize,
			collectionHeight: collectionView!.bounds.height,
			minimumInteritemSpacing: minimumInteritemSpacing
		)
		cache.recalculateDefaultFrames(numberOfItems: numberOfItems)
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		let indexes = cache.visibleRows(in: rect)
		
		let cells = indexes.map { (row) -> UICollectionViewLayoutAttributes? in
			let path = IndexPath(row: row, section: section)
			let attributes = layoutAttributesForItem(at: path)
			return attributes
		}
		.compactMap { $0 }
		.filter { $0.representedElementCategory == .cell }
		
		currentItemIndex = getItemCellIndex(offset: collectionView!.contentOffset)
		
		updateCells(cells)
		
		return cells
	}
	
	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
		attributes.frame = cache.defaultCellFrame(atRow: indexPath.row)
		return attributes
	}
	
	// MARK: - Scroll alignment
	
	override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
									  withScrollingVelocity velocity: CGPoint) -> CGPoint {
		let cardIndex = getItemCellIndex(offset: proposedContentOffset)
		
		let projectedOffset = contentOffset(for: cardIndex)
		
		let isSameCell = cardIndex == currentItemIndex
		if isSameCell {
			animateBackwardScroll(to: cardIndex)
			return collectionView!.contentOffset
		}
		
		return projectedOffset
	}
	
	/// Without that, high velocity moves cells backward very fast.
	/// We slow down the animation
	func animateBackwardScroll(to cardIndex: Int) {
		let path = IndexPath(row: cardIndex, section: 0)
		
		collectionView?.scrollToItem(
			at: path,
			at: .left,
			animated: true
		)
		
		// Fix double-step animation.
		DispatchQueue.main.async {
			self.collectionView?.scrollToItem(
				at: path,
				at: .left,
				animated: true
			)
		}
	}
	
	// MARK: - Convert scroll offset to item index and item index to scroll offset
	
	func contentOffset(for cardIndex: Int) -> CGPoint {
		let cellWidth = (itemSize.width + minimumInteritemSpacing)
		let x = contentInset.left + cellWidth * CGFloat(cardIndex)
		return CGPoint(x: x, y: 0)
	}
	
	func itemIndex(offset: CGPoint) -> CGFloat {
		let cellWidth = (itemSize.width + minimumInteritemSpacing)
		let offsetX = collectionView!.contentOffset.x
		var cardIndex = offsetX / (cellWidth)
		cardIndex.round(.toNearestOrAwayFromZero)
		return cardIndex
	}
	
	func getItemCellIndex(offset: CGPoint) -> Int {
		let numberOfItems = CGFloat(collectionView!.numberOfItems(inSection: section))
		let maxIndex = Int(numberOfItems - 1)
		let index = Int(itemIndex(offset: offset))
		return max(min(index, maxIndex), 0)
	}
	
	// MARK: - Layout
	
	private func updateCells(_ cells: [UICollectionViewLayoutAttributes]) {
		for cell in cells {
			let normScale = scale(for: cell.indexPath.row)
			let scale = 1 - scaleFactor * abs(normScale)
			
			cell.alpha = scale
			cell.frame = leftAlignedFrame(for: cell, scale: scale)
			cell.transform = CGAffineTransform(scaleX: scale, y: scale)
		}
	}
	
	// MARK: - Scale
	
	private func scale(for row: Int) -> CGFloat {
		let frame = cache.defaultCellFrame(atRow: row)
		let scale = self.scale(for: frame)
		return min(1, max(-1, scale))
	}
	
	private func scale(for frame: CGRect) -> CGFloat {
		let offsetFromMinX = offsetFromScreenMinX(frame)
		let relativeOffset = offsetFromMinX / frame.width
		return relativeOffset
	}
	
	private func offsetFromScreenMinX(_ frame: CGRect) -> CGFloat {
		return frame.minX - collectionView!.contentOffset.x - contentInset.left
	}
	
	// MARK: - Alignment
	
	private func leftAlignedFrame(for element: UICollectionViewLayoutAttributes, scale: CGFloat) -> CGRect {
		let vOffset = verticalOffset(for: element, scale: scale)
		return element.frame.offsetBy(dx: 0, dy: vOffset)
	}
	
	private func verticalOffset(for element: UICollectionViewLayoutAttributes, scale: CGFloat) -> CGFloat {
		let collectionHeight = collectionView!.bounds.height
		let scaledElementHeight = element.frame.height * scale
		let vOffset = (collectionHeight - scaledElementHeight) / 2
		return vOffset
	}
}
