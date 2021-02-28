//
//  TabletView.swift
//  Demos
//
//  Created by Darren Ford on 28/2/21.
//

import SwiftUI
import DSFSparkline


fileprivate var TabletDataSource2: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(range: -1 ... 1)
	d.set(values: [1, -1, 1, -1, 1, 0, -1, -1, 1, 0, 1, -1, -1, 0])
	return d
}()



struct TabletView: View {

	let shouldAnimate: Bool
	fileprivate let animator = Animator()

	var TabletDataSource1: DSFSparkline.DataSource = {
		let d = DSFSparkline.DataSource(windowSize: 20, range: -1 ... 1)
		d.push(values: [1, 1, 1, -1, 1, 0, -1, -1, 1, 1, 1, -1, -1, 1, 1, 0, -1, 1, 1, 1])
		return d
	}()

	var tabletOverlay: DSFSparklineOverlay = {
		let t = DSFSparklineOverlay.Tablet()
		t.dataSource = TabletDataSource2
		t.winStrokeColor = DSFColor.primaryTextColor.cgColor
		t.winFill = DSFSparkline.Fill.Color(DSFColor.systemGreen.withAlphaComponent(0.7).cgColor)
		t.lossStrokeColor = DSFColor.primaryTextColor.cgColor
		t.lossFill = DSFSparkline.Fill.Color(DSFColor.systemRed.withAlphaComponent(0.1).cgColor)
		return t
	}()

	var body: some View {
		VStack {
			Text("Tablets using prebuilt types")

			VStack {
				DSFSparklineTabletGraphView.SwiftUI(
					dataSource: TabletDataSource1,
					winColor: .systemTeal,
					lossColor: DSFColor.systemGray.withAlphaComponent(0.2),
					barSpacing: 2
				)
				.frame(height: 20)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)

				DSFSparklineTabletGraphView.SwiftUI(
					dataSource: TabletDataSource1,
					lineWidth: 0.5,
					barSpacing: 2
				)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
				.frame(width: 200, height: 20)
			}

			VStack {
				Text("Tablet using overlays")
				DSFSparklineSurface.SwiftUI([
					self.tabletOverlay
				])
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
				.frame(height: 30)
				.onAppear {
					if shouldAnimate {
						self.animator.updateWithNewValues()
					}
				}
			}
			.padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
		}
	}
}

struct TabletView_Previews: PreviewProvider {
	static var previews: some View {
		TabletView(shouldAnimate: false)
	}
}


fileprivate class Animator {
	func updateWithNewValues() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
			guard let `self` = self else {
				return
			}

			// push a new value into the graph's data source
			let cr2 = CGFloat.random(in: TabletDataSource2.range!) // -1 ... 1)
			_ = TabletDataSource2.push(value: cr2)

			self.updateWithNewValues()
		}
	}
}
