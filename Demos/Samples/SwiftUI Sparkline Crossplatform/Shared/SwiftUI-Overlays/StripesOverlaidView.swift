//
//  StripesOverlaidView.swift
//  Demos
//
//  Created by Darren Ford on 28/2/21.
//

import SwiftUI
import DSFSparkline

struct StripesOverlaidView: View {

	static let palette = DSFSparkline.GradientBucket(posts: [
		DSFSparkline.GradientBucket.Post(color: DSFColor.systemGreen.cgColor, location: 0),
		DSFSparkline.GradientBucket.Post(color: DSFColor.systemGreen.cgColor, location: 0.1),
		DSFSparkline.GradientBucket.Post(color: DSFColor.systemYellow.cgColor, location: 0.5),
		DSFSparkline.GradientBucket.Post(color: DSFColor.systemRed.cgColor, location: 0.9),
		DSFSparkline.GradientBucket.Post(color: DSFColor.systemRed.cgColor, location: 1.0)
	])

	var stripesOverlay: DSFSparklineOverlay = {
		let s = DSFSparklineOverlay.Stripes()
		s.dataSource = WorldDataSource
		s.integral = false
		s.gradient = StripesOverlaidView.palette
		return s
	}()

	var lineOverlay: DSFSparklineOverlay = {
		let l = DSFSparklineOverlay.Line()
		l.dataSource = WorldDataSource
		l.strokeWidth = 1
		l.interpolated = true
		l.primaryStrokeColor = DSFColor.black.cgColor
		l.primaryFill = DSFSparkline.Fill.Color(DSFColor.black.withAlphaComponent(0.3).cgColor)
		return l
	}()

	var body: some View {
		VStack {
			Text("Overlay two sparklines using the same data")
				.font(.headline)

			DSFSparklineSurface.SwiftUI([
				stripesOverlay,
				lineOverlay
			])
			.frame(height: 40)
		}
	}
}

struct StripesOverlaidView_Previews: PreviewProvider {
    static var previews: some View {
        StripesOverlaidView()
    }
}
