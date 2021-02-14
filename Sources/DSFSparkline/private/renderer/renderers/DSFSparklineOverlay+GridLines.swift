//
//  DSFSparklineOverlay+ZeroLine.swift
//
//
//  Created by Darren Ford on 3/2/21.
//

import QuartzCore

public extension DSFSparklineOverlay {

	@objc(DSFSparklineOverlayGridLines) class GridLines: DSFSparklineDataSourceOverlay {

		/// The color of the dotted line at the zero point on the y-axis
		@objc public var strokeColor: CGColor {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The width of the dotted line at the zero point on the y-axis
		@objc public var strokeWidth: CGFloat {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The line style for the dotted line. Use [] to specify a solid line.
		@objc public var dashStyle: [CGFloat] = [1, 1] {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The y-values for the lines
		@objc public var floatValues: [CGFloat] = [] {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// A string representation of the line dash lengths for the zero line, eg. "1,3,4,2". If you want a solid line, specify "-"
		///
		/// Primarily used for Interface Builder integration
		@objc public func setDashStyleString(_ dashStyleString: String) {
			if dashStyleString == "-" {
				// Solid line
				self.dashStyle = []
			}
			else {
				let components = dashStyleString.split(separator: ",")
				let floats: [CGFloat] = components
					.map { String($0) } // Convert to string array
					.compactMap { Float($0) } // Convert to float array if possible
					.compactMap { CGFloat($0) } // Convert to CGFloat array
				if components.count == floats.count {
					self.dashStyle = floats
				}
				else {
					Swift.print("ERROR: Zero Line Style string format is incompatible (\(dashStyleString) -> \(components))")
				}
			}
		}

		@objc public init(dataSource: DSFSparklineDataSource? = nil,
								floatValues: [CGFloat] = [],
								strokeColor: CGColor = DSFColor.gray.cgColor,
								strokeWidth: CGFloat = 1.0,
								dashStyle: [CGFloat] = [1.0, 1.0]) {
			self.strokeColor = strokeColor
			self.strokeWidth = strokeWidth
			self.dashStyle = dashStyle

			super.init(dataSource: dataSource)

			self.contentsScale = 2
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		open override func drawGraph(context: CGContext, bounds: CGRect, hostedIn view: DSFView) -> CGRect {
			guard let dataSource = self.dataSource else {
				return bounds
			}

			context.setLineWidth(self.strokeWidth)
			context.setStrokeColor(self.strokeColor)
			context.setLineDash(phase: 0.0, lengths: self.dashStyle)

			self.floatValues.forEach { value in
				let fractional = dataSource.fractionalPosition(for: value)
				let zeroPos = self.bounds.height - (fractional * self.bounds.height)
				context.strokeLineSegments(between: [CGPoint(x: 0.0, y: zeroPos),
																 CGPoint(x: self.bounds.width, y: zeroPos)])
			}
			return bounds
		}
	}
}
