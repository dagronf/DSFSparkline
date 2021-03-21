//
//  PercentBar.swift
//  Demos
//
//  Created by Darren Ford on 18/3/21.
//

import SwiftUI
import DSFSparkline

struct PercentBar: View {
	// The actual line graph
	var percentBarOverlay: DSFSparklineOverlay.SimplePercentBar = {
		let lineOverlay = DSFSparklineOverlay.SimplePercentBar()
		return lineOverlay
	}()

	var percentBarOverlay2: DSFSparklineOverlay.SimplePercentBar = {
		let lineOverlay = DSFSparklineOverlay.SimplePercentBar()
		return lineOverlay
	}()

	var percentBarOverlay3: DSFSparklineOverlay.SimplePercentBar = {
		let lineOverlay = DSFSparklineOverlay.SimplePercentBar()
		return lineOverlay
	}()

	var style: DSFSparkline.PercentBar.Style = {
		let s = DSFSparkline.PercentBar.Style()
		s.backgroundColor = DSFColor.systemBlue.cgColor
		s.backgroundTextColor = CGColor(gray: 1.0, alpha: 1.0)
		s.barColor = DSFColor.systemYellow.cgColor
		s.barTextColor = .black
		s.animated = true
		s.animationDuration = 0.25
		return s
	}()

	@State var v1: CGFloat = 0.66

	var body: some View {
		VStack {
			DSFSparklinePercentBarGraphView.SwiftUI(
				style: style, value: 0.75
			)
			.frame(height: 20)
			DSFSparklinePercentBarGraphView.SwiftUI(
				style: style, value: 0.22
			)
			.frame(height: 20)
			DSFSparklinePercentBarGraphView.SwiftUI(
				style: style, value: Double(v1))
			.frame(height: 20)
			Button("do") {
				self.v1 = 0.22
			}
		}
		.frame(width: 150)
	}
}

struct PercentBar_Previews: PreviewProvider {
    static var previews: some View {
        PercentBar()
    }
}
