//
//  CardFrameCalculator.swift
//  CardsCollectionViewLayoutExample
//
//  Created by Андрей Козлов on 05.05.2021.
//

import UIKit

struct CardFrameCalculator {
	
	private let itemSize: CGSize
	private let collectionHeight: CGFloat
	private let minimumInteritemSpacing: CGFloat
	private var defaultFrames: [CGRect] = []
	
	init(itemSize: CGSize, collectionHeight: CGFloat, minimumInteritemSpacing: CGFloat) {
		self.itemSize = itemSize
		self.collectionHeight = collectionHeight
		self.minimumInteritemSpacing = minimumInteritemSpacing
	}
	
	static var zero: Self {
		.init(itemSize: .zero, collectionHeight: 0, minimumInteritemSpacing: 0)
	}
		
	mutating func recalculateDefaultFrames(numberOfItems: Int) {
		defaultFrames = (0..<numberOfItems).map {
			defaultCellFrame(atRow: $0)
		}
	}
	
	func defaultCellFrame(atRow row: Int) -> CGRect {
		CGRect(
			x: (itemSize.width + minimumInteritemSpacing) * CGFloat(row),
			y: 0,
			width: itemSize.width,
			height: itemSize.height
		)
	}
		
	func visibleRows(in frame: CGRect) -> [Int] {
		defaultFrames
			.enumerated()
			.filter { $0.element.intersects(frame)}
			.map { $0.offset }
	}
	
	var contentSize: CGSize {
		CGSize(
			width: defaultFrames.last?.maxX ?? 0,
			height: collectionHeight
		)
	}
}
