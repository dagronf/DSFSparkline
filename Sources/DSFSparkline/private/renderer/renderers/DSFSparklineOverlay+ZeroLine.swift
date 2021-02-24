//
//  DSFSparklineOverlay+ZeroLine.swift
//
//
//  Created by Darren Ford on 3/2/21.
//

import QuartzCore

public extension DSFSparklineOverlay {

	@objc(DSFSparklineOverlayZeroLine) class ZeroLine: DSFSparklineDataSourceOverlay {

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

		/// A string representation of the line dash lengths for the zero line, eg. "1,3,4,2". If you want a solid line, specify "-"
		///
		/// Primarily used for Interface Builder integration
		@objc public func setDashStyleString(_ dashStyleString: String) -> Bool {
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
					return false
				}
			}
			return true
		}

		@objc public init(dataSource: DSFSparklineDataSource? = nil,
								zeroLineValue: CGFloat = 0.0,
								strokeColor: CGColor = DSFColor.gray.cgColor,
								strokeWidth: CGFloat = 1.0,
								dashStyle: [CGFloat] = [1.0, 1.0]) {
			self.strokeColor = strokeColor
			self.strokeWidth = strokeWidth
			self.dashStyle = dashStyle

			super.init(dataSource: dataSource, zeroLineValue: zeroLineValue)
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		open override func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {
			guard let dataSource = self.dataSource else {
				return bounds
			}

			let frac = dataSource.fractionalPosition(for: dataSource.zeroLineValue)
			let zeroPos = bounds.height - (frac * bounds.height)

			context.setLineWidth(self.strokeWidth)
			context.setStrokeColor(self.strokeColor)
			context.setLineDash(phase: 0.0, lengths: self.dashStyle)
			context.strokeLineSegments(between: [CGPoint(x: 0.0, y: zeroPos), CGPoint(x: self.bounds.width, y: zeroPos)])

			return bounds
		}
	}
}
