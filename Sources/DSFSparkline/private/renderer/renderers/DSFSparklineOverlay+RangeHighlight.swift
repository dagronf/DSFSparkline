//
//  DSFSparklineOverlay+RangeHighlight.swift
//
//
//  Created by Darren Ford on 3/2/21.
//

import QuartzCore

public extension DSFSparklineOverlay {

	@objc(DSFSparklineOverlayRangeHighlight) class RangeHighlight: DSFSparklineDataSourceOverlay {

		/// The color to fill the specified range
		@objc public var fillColor: CGColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.5, 0.5, 0.5, 0.5])! {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The highlight range for the graph
		public var highlightRange: Range<CGFloat>? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// objective-c compatible highlight range setting
		@objc public func setHighlightRange(lowerBound: CGFloat, upperBound: CGFloat) {
			self.highlightRange = lowerBound ..< upperBound
		}

		@objc public var highlightRangeString: String? = nil {
			didSet {
				if let rangeStr = highlightRangeString {
					let components = rangeStr.split(separator: ",")
					let floats: [CGFloat] = components
						.map { String($0) } 				// Convert to string array
						.compactMap { Float($0) } 		// Convert to float array if possible
						.compactMap { CGFloat($0) } 	// Convert to CGFloat array
					if floats.count == 2, floats[0] < floats[1] {
						self.highlightRange = floats[0] ..< floats[1]
					}
					else {
						self.highlightRange = nil
						Swift.print("ERROR: Highlight range string format is incompatible (\(self.highlightRangeString ?? "nil") -> \(components))")
					}
				}
				else {
					self.highlightRange = nil
				}

				self.setNeedsDisplay()
			}
		}

		public init(dataSource: DSFSparklineDataSource? = nil,
						range: Range<CGFloat>? = nil,
						fillColor: CGColor = DSFColor.gray.cgColor) {
			self.highlightRange = range
			self.fillColor = fillColor

			super.init(dataSource: dataSource)
		}

		@objc public init(lowerBound: CGFloat, upperBound: CGFloat,
								fillColor: CGColor = DSFColor.gray.cgColor) {
			self.highlightRange = lowerBound ..< upperBound
			self.fillColor = fillColor
			super.init()
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		public override func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {

			guard let dataSource = self.dataSource,
					let range = self.highlightRange else {
				return bounds
			}

			let integ = bounds.integral

			let lb = 1.0 - dataSource.normalize(value: range.lowerBound)
			let ub = 1.0 - dataSource.normalize(value: range.upperBound)

			context.setFillColor(self.fillColor)
			let r = CGRect(x: 0, y: ub * integ.height, width: integ.width, height: (lb - ub) * integ.height)
			context.addRect(r)
			context.fillPath()

			return bounds
		}
	}
}
