//
//  DotGraphView.swift
//  Demos
//
//  Created by Darren Ford on 16/2/21.
//

import SwiftUI
import DSFSparkline

fileprivate var data1: DSFSparkline.DataSource = {
	let e = DSFSparkline.DataSource(windowSize: 100, range: 0 ... 100)
	let values: [CGFloat] = (0 ..< 100).map { _ in
		CGFloat.random(in: 0 ... 100)
	}
	e.set(values: values)
	return e
}()

fileprivate var animData1: DSFSparkline.DataSource = {
	let e = DSFSparkline.DataSource(windowSize: 100, range: 0 ... 100)
	return e
}()


struct DotStandard: View {
	var body: some View {
		VStack {
			Text("Basic Dot")
			DSFSparklineDotGraphView.SwiftUI(
				dataSource: data1,
				graphColor: DSFColor.systemGreen
			)
			.frame(height: 40)
			.padding(4)

			Text("Basic Dot Upside Down with unset color")
			DSFSparklineDotGraphView.SwiftUI(
				dataSource: data1,
				graphColor: DSFColor.systemBlue,
				unsetGraphColor: DSFColor.gray.withAlphaComponent(0.1),
				upsideDown: true
			)
			.frame(height: 40)
			.padding(4)
		}
		.frame(width: 400)
	}
}

struct DotStandardAnim: View {
	var body: some View {
		VStack {
			Text("Animated Dot")
			DSFSparklineDotGraphView.SwiftUI(
				dataSource: animData1,
				graphColor: DSFColor.systemRed,
				unsetGraphColor: DSFColor.gray.withAlphaComponent(0.1))
				.frame(width: 300, height: 40)
				.padding(4)
				.onAppear(perform: {
					startAnim()
				})
		}
	}

	func startAnim() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			animData1.push(value: CGFloat.random(in: 0 ... 100))
			self.startAnim()
		}
	}
}




struct DotGraphView: View {
	var body: some View {
		VStack {
			DotStandard()
			DotStandardAnim()
		}
    }
}







struct DotGraphView_Previews: PreviewProvider {
    static var previews: some View {
        DotGraphView()
    }
}
