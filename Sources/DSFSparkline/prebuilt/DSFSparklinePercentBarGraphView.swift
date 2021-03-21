//
//  DSFSparklinePercentBarGraphView.swift
//  
//
//  Created by Darren Ford on 18/3/21.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// A sparkline that draws a simple pie chart
@IBDesignable
public class DSFSparklinePercentBarGraphView: DSFSparklineSurfaceView {

	private let overlay = DSFSparklineOverlay.SimplePercentBar()

	@objc public var displayStyle: DSFSparklineOverlay.SimplePercentBar.Style = DSFSparklineOverlay.SimplePercentBar.Style() {
		didSet {
			self.overlay.displayStyle = displayStyle
			self.updateDisplay()
		}
	}

	//	/// The backgroundColor color for the percent bar chart
	//	#if os(macOS)
	//	@IBInspectable public var backgroundColor: NSColor = .clear {
	//		didSet {
	//			self.displayStyle.backgroundColor = self.backgroundColor.cgColor
	//		}
	//	}
	//	#else
	//	@IBInspectable public var backgroundColor: UIColor = .clear {
	//		didSet {
	//			self.displayStyle.backgroundColor = self.backgroundColor.cgColor
	//		}
	//	}
	//	#endif

	/// The backgroundColor color for the percent bar chart
	#if os(macOS)
	@IBInspectable public var backgroundTextColor: NSColor = .white {
		didSet {
			self.displayStyle.backgroundTextColor = self.backgroundTextColor.cgColor
			self.displayUpdate()
		}
	}
	#else
	@IBInspectable public var backgroundTextColor: UIColor = .white {
		didSet {
			self.displayStyle.backgroundTextColor = self.backgroundTextColor.cgColor
			self.displayUpdate()
		}
	}
	#endif

	// MARK: - Bar Color

	/// The bar color for the percent bar chart
	#if os(macOS)
	@IBInspectable public var barColor: NSColor = .black {
		didSet {
			self.displayStyle.barColor = self.barColor.cgColor
			self.displayUpdate()
		}
	}
	#else
	@IBInspectable public var barColor: UIColor = .black {
		didSet {
			self.displayStyle.barColor = self.barColor.cgColor
			self.displayUpdate()
		}
	}
	#endif

	// MARK: - Background Color

	/// The backgroundColor color for the percent bar chart
	#if os(macOS)
	@IBInspectable public var barTextColor: NSColor = .white {
		didSet {
			self.displayStyle.barTextColor = self.barTextColor.cgColor
			self.displayUpdate()
		}
	}
	#else
	@IBInspectable public var barTextColor: UIColor = .white {
		didSet {
			self.displayStyle.barTextColor = self.barTextColor.cgColor
			self.displayUpdate()
		}
	}
	#endif

	// MARK: - Font

	@IBInspectable public var fontName: String? = nil {
		didSet {
			if let f = fontName,
				let font = DSFFont(name: f, size: self.fontSize) {
				self.displayStyle.font = font
			}
			else {
				self.displayStyle.font = DSFFont.systemFont(ofSize: self.fontSize)
			}
			self.displayUpdate()
		}
	}

	@IBInspectable public var fontSize: CGFloat = 12 {
		didSet {
			let font = self.displayStyle.font

			#if os(macOS)
			if let newFont = DSFFont(descriptor: font.fontDescriptor, size: fontSize) {
				self.displayStyle.font = newFont
			}
			#else
			self.displayStyle.font = DSFFont(descriptor: font.fontDescriptor, size: fontSize)
			#endif

			self.overlay.displayStyle = self.displayStyle
			self.displayUpdate()
		}
	}

	// MARK: - Animation

	@IBInspectable public var shouldAnimate: Bool = false {
		didSet {
			self.displayStyle.animated = self.shouldAnimate
			self.displayUpdate()
		}
	}

	@IBInspectable public var animationDuration: CGFloat = 0.25 {
		didSet {
			self.displayStyle.animationDuration = Double(self.animationDuration)
			self.displayUpdate()
		}
	}

	// MARK: - Value

	@IBInspectable public var value: CGFloat = 0.2 {
		didSet {
			self.overlay.fractional = self.value
			self.displayUpdate()
		}
	}

	// MARK: - Control

	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.configure()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.configure()
	}

	private func displayUpdate() {
		self.overlay.displayStyle = self.displayStyle
	}

	func configure() {
		self.addOverlay(self.overlay)
		self.overlay.setNeedsDisplay()

		self.displayStyle.backgroundColor = self.backgroundColor?.cgColor ?? CGColor.DefaultClear
		self.displayStyle.backgroundTextColor = self.backgroundTextColor.cgColor
		self.displayStyle.barColor = self.barColor.cgColor
		self.displayStyle.barTextColor = self.barTextColor.cgColor

		if let f = fontName,
			let font = DSFFont(name: f, size: self.fontSize) {
			self.displayStyle.font = font
		}
		else {
			self.displayStyle.font = DSFFont.systemFont(ofSize: self.fontSize)
		}

		#if TARGET_INTERFACE_BUILDER
		self.displayStyle.animated = false
		#else
		self.displayStyle.animated = self.shouldAnimate
		#endif

		self.overlay.displayStyle = self.displayStyle
		self.overlay.fractional = self.value

		self.overlay.setNeedsDisplay()

		self.updateDisplay()
	}
}

extension DSFSparklinePercentBarGraphView {
	public override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()

		#if TARGET_INTERFACE_BUILDER
		self.configure()
		self.overlay.setNeedsDisplay()
		self.updateDisplay()
		#endif
	}
}
