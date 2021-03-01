//
//  SuperCoolLineSpark.swift
//  Demos
//
//  Created by Darren Ford on 1/3/21.
//

import SwiftUI
import DSFSparkline

fileprivate let SwiftUIDemoDataSource: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 20, range: 0 ... 1, zeroLineValue: 0.5)
	  d.push(values: [
		  0.72, 0.84, 0.15, 0.16, 0.30, 0.58, 0.87, 0.44, 0.02, 0.27,
		  0.48, 0.16, 0.15, 0.14, 0.81, 0.53, 0.67, 0.52, 0.07, 0.50
	  ])
	  return d
  }()

struct SuperCoolLineSpark: View {
	// The overlay representing the zero-line for the data source
	var zeroOverlay: DSFSparklineOverlay = {
		let zeroLine = DSFSparklineOverlay.ZeroLine()
		zeroLine.dataSource = SwiftUIDemoDataSource
		zeroLine.dashStyle = []
		return zeroLine
	}()

	// The overlay to draw a highlight between range 0 ..< 0.2
	var rangeOverlay: DSFSparklineOverlay = {
		let highlight = DSFSparklineOverlay.RangeHighlight()
		highlight.dataSource = SwiftUIDemoDataSource
		highlight.highlightRange = 0.0 ..< 0.2
		highlight.fill = DSFSparkline.Fill.Color(DSFColor.gray.withAlphaComponent(0.4).cgColor)
		return highlight
	}()

	// The actual line graph
	var lineOverlay: DSFSparklineOverlay = {
		let lineOverlay = DSFSparklineOverlay.Line()
		lineOverlay.dataSource = SwiftUIDemoDataSource

		lineOverlay.primaryStrokeColor = DSFColor.systemBlue.cgColor
		lineOverlay.primaryFill = DSFSparkline.Fill.Color(DSFColor.systemBlue.withAlphaComponent(0.3).cgColor)

		lineOverlay.secondaryStrokeColor = DSFColor.systemYellow.cgColor
		lineOverlay.secondaryFill = DSFSparkline.Fill.Color(DSFColor.systemYellow.withAlphaComponent(0.3).cgColor)

		lineOverlay.strokeWidth = 1
		lineOverlay.markerSize = 4
		lineOverlay.centeredAtZeroLine = true

		return lineOverlay
	}()

	var body: some View {
		DSFSparklineSurface.SwiftUI([
			rangeOverlay,    // range highlight overlay
			zeroOverlay,     // zero-line overlay
			lineOverlay,     // line graph overlay
		])
		.frame(width: 150, height: 40)
	}
}

struct SuperCoolLineSpark_Previews: PreviewProvider {
    static var previews: some View {
        SuperCoolLineSpark()
    }
}
