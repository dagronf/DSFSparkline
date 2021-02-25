//
//  DSFSparklineOverlay+WinLossTie.swift
//  
//
//  Created by Darren Ford on 24/2/21.
//

import QuartzCore

public extension DSFSparklineOverlay {
	@objc(DSFSparklineOverlayWinLossTie) class WinLossTie: DSFSparklineDataSourceOverlay {

		static let green = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 1, 0, 1])!
		static let red = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1, 0, 0, 1])!

		/// The width of the stroke for the tablet
		@objc public var lineWidth: UInt = 1 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The spacing (in pixels) between each bar
		@objc public var barSpacing: UInt = 1 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color to draw the 'win' boxes
		@objc public var winColor: CGColor = WinLossTie.green {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color to draw the 'loss' boxes
		@objc public var lossColor: CGColor = WinLossTie.red {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color to draw the 'tie' boxes
		@objc public var tieColor: CGColor? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		public override func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {
			self.drawWinLossGraph(context: context, bounds: bounds, scale: scale)
		}
	}
}

private extension DSFSparklineOverlay.WinLossTie {
	 func drawWinLossGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {
		guard let dataSource = self.dataSource else {
			return bounds
		}

		let integralRect = bounds.integral

		let windowSize: Int = Int(dataSource.windowSize)

		// This represents the _full_ width of a bar within the graph, including the spacing.
		let componentWidth: Int = Int(integralRect.width) / windowSize

		// The width of the BAR component
		let barWidth: Int = componentWidth - Int(self.barSpacing)

		// The left offset in order to center X
		let xOffset: Int = (Int(integralRect.width) - (componentWidth * windowSize)) / 2

		// Map the +ve values to true, the -ve (and 0) to false
		let winLoss: [Int] = dataSource.data.map {
			if $0 > 0 { return 1 }
			if $0 < 0 { return -1 }
			return 0
		}

		let graphLineWidth: CGFloat = 1 / scale * CGFloat(self.lineWidth)

		let midPoint = Int(bounds.midY.rounded())
		let barHeight = Int(integralRect.midY) - Int(self.lineWidth)

		context.usingGState { outer in

			outer.setShouldAntialias(false)
			outer.setRenderingIntent(.relativeColorimetric)
			outer.interpolationQuality = .none

			if dataSource.counter < dataSource.windowSize {
				let pos = Int(dataSource.counter) * componentWidth
				let clipRect = integralRect.divided(atDistance: CGFloat(pos + xOffset), from: .maxXEdge).slice
				outer.clip(to: clipRect.integral)
			}

			let winPath = CGMutablePath()
			let lossPath = CGMutablePath()
			let tiePath = CGMutablePath()

			for point in winLoss.enumerated() {
				let x = xOffset + point.offset * componentWidth
				if point.element == 1 {
					let rect = CGRect(x: x, y: 1, width: barWidth, height: barHeight)
					winPath.addRect(rect.integral)
				}
				else if point.element == -1 {
					let rect = CGRect(x: x, y: midPoint + 1, width: barWidth, height: barHeight)
					lossPath.addRect(rect.integral)
				}
				else {
					let rect = CGRect(x: x, y: Int(integralRect.height) / 2 - (barHeight / 4), width: barWidth, height: barHeight / 2)
					tiePath.addRect(rect.integral)
				}
			}

			if !winPath.isEmpty {
				outer.usingGState { winState in
					winState.addPath(winPath)
					winState.setFillColor(self.winColor.copy(alpha: 0.3)!)
					winState.setStrokeColor(self.winColor)
					winState.setLineWidth(graphLineWidth)
					winState.drawPath(using: .fillStroke)
				}
			}

			if !lossPath.isEmpty {
				outer.usingGState { lossState in
					lossState.addPath(lossPath)
					lossState.setFillColor(self.lossColor.copy(alpha: 0.3)!)
					lossState.setStrokeColor(self.lossColor)
					lossState.setLineWidth(graphLineWidth)
					lossState.drawPath(using: .fillStroke)
				}
			}

			if let tieColor = self.tieColor, !tiePath.isEmpty {
				outer.usingGState { tieState in
					tieState.addPath(tiePath)
					tieState.setLineWidth(graphLineWidth)

					let tieAlpha = min(1, tieColor.alpha + 0.1)
					tieState.setFillColor(tieColor)
					tieState.setStrokeColor(tieColor.copy(alpha: tieAlpha)!)
					tieState.drawPath(using: .fillStroke)
				}
			}
		}
		return bounds
	}
}
