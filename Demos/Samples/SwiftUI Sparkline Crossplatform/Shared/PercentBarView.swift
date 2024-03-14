//
//  PercentBar.swift
//  Demos
//
//  Created by Darren Ford on 18/3/21.
//

import SwiftUI
import DSFSparkline

struct PercentBarView: View {

	// The actual line graph
	var percentBarOverlay: DSFSparklineOverlay.PercentBar = {
		let lineOverlay = DSFSparklineOverlay.PercentBar(value: 0)
		return lineOverlay
	}()

	var percentBarOverlay2: DSFSparklineOverlay.PercentBar = {
		let lineOverlay = DSFSparklineOverlay.PercentBar(value: 0)
		return lineOverlay
	}()

	var percentBarOverlay3: DSFSparklineOverlay.PercentBar = {
		let lineOverlay = DSFSparklineOverlay.PercentBar(value: 0)
		return lineOverlay
	}()

	func style() -> DSFSparkline.PercentBar.Style {
		let s = DSFSparkline.PercentBar.Style()
		s.barColor = DSFColor.systemYellow.cgColor
		s.barTextColor = .black
		s.underBarColor = DSFColor.systemBlue.cgColor
		s.underBarTextColor = CGColor(gray: 1.0, alpha: 1.0)
		s.font = DSFFont(name: "Menlo", size: 13)!
		return s
	}

	func style2() -> DSFSparkline.PercentBar.Style {
		let s = DSFSparkline.PercentBar.Style()
		s.barColor = DSFColor.systemIndigo.cgColor
		s.underBarColor = CGColor(gray: 0.0, alpha: 0.1)
		s.showLabel = false
		return s
	}

	func style3() -> DSFSparkline.PercentBar.Style {
		let s = DSFSparkline.PercentBar.Style()
		s.barEdgeInsets = DSFEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
		s.barColor = CGColor(gray: 0.0, alpha: 0.2)
		s.barTextColor = .black
		s.underBarColor = CGColor(gray: 0.0, alpha: 0.1)
		s.underBarTextColor = .black
		s.font = DSFFont(name: "Menlo", size: 13)!
		return s
	}

	func style4(value: CGFloat) -> DSFSparkline.PercentBar.Style {
		let s = DSFSparkline.PercentBar.Style()
		s.barEdgeInsets = DSFEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)

		if value > 0.8 {
			s.barColor = DSFColor.systemRed.cgColor
			s.barTextColor = CGColor(gray: 1.0, alpha: 1.0)
		}
		else if value > 0.5 {
			s.barColor = DSFColor.systemYellow.cgColor
			s.barTextColor = CGColor(gray: 0.0, alpha: 1.0)
		}
		else {
			s.barColor = DSFColor.systemGreen.cgColor
			s.barTextColor = CGColor(gray: 0.0, alpha: 1.0)
		}

		s.underBarColor = CGColor(gray: 0.8, alpha: 1.0)
		s.underBarTextColor = .black
		s.font = DSFFont(name: "Menlo Bold", size: 16)!
		return s
	}

	let fixedFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .percent
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 2
		return formatter
	}()
	func fixedFormatted(_ value: CGFloat) -> String {
		return self.fixedFormatter.string(for: value) ?? ""
	}

	func style10() -> DSFSparkline.PercentBar.Style {
		let s = DSFSparkline.PercentBar.Style()
		s.barEdgeInsets = DSFEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
		s.barColor = CGColor(gray: 0.0, alpha: 1.0)
		s.barTextColor = CGColor(gray: 1.0, alpha: 1.0)
		s.underBarColor = CGColor(gray: 0.8, alpha: 1.0)
		s.underBarTextColor = .black
		s.font = DSFFont(name: "Menlo", size: 11)!
		return s
	}

	func style11() -> DSFSparkline.PercentBar.Style {
		let s = DSFSparkline.PercentBar.Style()
		s.showLabel = false
		s.barEdgeInsets = DSFEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
		s.barColor = CGColor(gray: 0.0, alpha: 1.0)
		s.barTextColor = CGColor(gray: 1.0, alpha: 1.0)
		s.underBarColor = CGColor(gray: 0.8, alpha: 1.0)
		s.underBarTextColor = .black
		s.font = DSFFont(name: "Menlo", size: 11)!
		return s
	}


	@State var v1: CGFloat = 0.0
	@State var v2: CGFloat = 1.0
	@State var v3: CGFloat = 0.85
	@State var v4: CGFloat = 0.05
	@State var v5: CGFloat = 0.66
	@State var v6: CGFloat = 0.5

	@State var v10: CGFloat = 0.0
	@State var v11: CGFloat = 0.2
	@State var v12: CGFloat = 0.4
	@State var v13: CGFloat = 0.6
	@State var v14: CGFloat = 0.8
	@State var v15: CGFloat = 1.0

	var body: some View {
		VStack {
			VStack {
				Text("Fixed")
					.font(.subheadline)

				DSFSparklinePercentBarGraphView.SwiftUI(style: style(), value: Double(v1))
					.frame(height: 20)
				DSFSparklinePercentBarGraphView.SwiftUI(style: style(), value: Double(0.5))
					.frame(height: 20)
				DSFSparklinePercentBarGraphView.SwiftUI(style: style(), value: Double(v2))
					.frame(height: 20)

				Divider()

				VStack {
					let animationStyle = DSFSparkline.AnimationStyle(duration: 0.25)
					HStack {
						DSFSparklinePercentBarGraphView.SwiftUI(style: style10(), value: Double(v10), animationStyle: animationStyle)
							.frame(width: 50, height: 18, alignment: .center)
						DSFSparklinePercentBarGraphView.SwiftUI(style: style10(), value: Double(v11), animationStyle: animationStyle)
							.frame(width: 50, height: 18, alignment: .center)
						DSFSparklinePercentBarGraphView.SwiftUI(style: style10(), value: Double(v12), animationStyle: animationStyle)
							.frame(width: 50, height: 18, alignment: .center)
						DSFSparklinePercentBarGraphView.SwiftUI(style: style10(), value: Double(v13), animationStyle: animationStyle)
							.frame(width: 50, height: 18, alignment: .center)
						DSFSparklinePercentBarGraphView.SwiftUI(style: style10(), value: Double(v14), animationStyle: animationStyle)
							.frame(width: 50, height: 18, alignment: .center)
						DSFSparklinePercentBarGraphView.SwiftUI(style: style10(), value: Double(v15), animationStyle: animationStyle)
							.frame(width: 50, height: 18, alignment: .center)
					}

					HStack {
						DSFSparklinePercentBarGraphView.SwiftUI(style: style11(), value: Double(v10), animationStyle: animationStyle)
							.frame(width: 50, height: 18, alignment: .center)
						DSFSparklinePercentBarGraphView.SwiftUI(style: style11(), value: Double(v11), animationStyle: animationStyle)
							.frame(width: 50, height: 18, alignment: .center)
						DSFSparklinePercentBarGraphView.SwiftUI(style: style11(), value: Double(v12), animationStyle: animationStyle)
							.frame(width: 50, height: 18, alignment: .center)
						DSFSparklinePercentBarGraphView.SwiftUI(style: style11(), value: Double(v13), animationStyle: animationStyle)
							.frame(width: 50, height: 18, alignment: .center)
						DSFSparklinePercentBarGraphView.SwiftUI(style: style11(), value: Double(v14), animationStyle: animationStyle)
							.frame(width: 50, height: 18, alignment: .center)
						DSFSparklinePercentBarGraphView.SwiftUI(style: style11(), value: Double(v15), animationStyle: animationStyle)
							.frame(width: 50, height: 18, alignment: .center)
					}
					Button("Random") {
						self.v10 = CGFloat(drand48())
						self.v11 = CGFloat(drand48())
						self.v12 = CGFloat(drand48())
						self.v13 = CGFloat(drand48())
						self.v14 = CGFloat(drand48())
						self.v15 = CGFloat(drand48())
					}
					.frame(height: 18, alignment: .center)
				}

				Divider()

				HStack {
					DSFSparklinePercentBarGraphView.SwiftUI(style: style2(), value: Double(v1))
						.frame(height: 20)
					Text(fixedFormatted(self.v1))
						.frame(width: 75, alignment: .trailing)
				}
				HStack {
					DSFSparklinePercentBarGraphView.SwiftUI(style: style2(), value: Double(0.5))
						.frame(height: 20)
					Text(fixedFormatted(0.5))
						.frame(width: 75, alignment: .trailing)
				}
				HStack {
					DSFSparklinePercentBarGraphView.SwiftUI(style: style2(), value: Double(v2))
						.frame(height: 20)
					Text(fixedFormatted(self.v2))
						.frame(width: 75, alignment: .trailing)
				}

			}
			.frame(width: 320)

			Divider()

			VStack {
				Text("Interactive")
					.font(.subheadline)

					DSFSparklinePercentBarGraphView.SwiftUI(style: style3(), value: Double(v6))
						.frame(height: 26)
				HStack(spacing: 8) {
					Slider(value: $v6, in: 0 ... 1)
					Text(fixedFormatted(self.v6))
						.frame(width: 75, alignment: .trailing)
				}
			}
			.padding(8)
			Divider()
			VStack {
				Text("Animation")
					.font(.subheadline)

				DSFSparklinePercentBarGraphView.SwiftUI(style: style4(value: v3), value: Double(v3), animationStyle: .init(duration: 0.5))
					.frame(height: 30)
				DSFSparklinePercentBarGraphView.SwiftUI(style: style4(value: v4), value: Double(v4), animationStyle: .init(duration: 0.5))
					.frame(height: 30)
				DSFSparklinePercentBarGraphView.SwiftUI(style: style4(value: v5), value: Double(v5), animationStyle: .init(duration: 0.5))
					.frame(height: 30)
				Button("Random") {
					self.v3 = CGFloat(drand48())
					self.v4 = CGFloat(drand48())
					self.v5 = CGFloat(drand48())
				}
			}
			.frame(width: 250)
		}
	}
}

struct PercentBar_Previews: PreviewProvider {
	static var previews: some View {
		PercentBarView()
	}
}
