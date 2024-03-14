//
//  ContentView.swift
//  Shared
//
//  Created by Darren Ford on 27/1/21.
//

import DSFSparkline
import SwiftUI


struct Item: Identifiable {
	let id: Int
	let name: String
}


struct ContentView: View {

	let items: [Item] = [
		Item(id: 0, name: "ReportView"),
		Item(id: 1, name: "WinLossTie"),
		Item(id: 2, name: "Tablet"),
		Item(id: 3, name: "Line"),
		Item(id: 4, name: "Stackline"),
		Item(id: 5, name: "Pie Chart"),
		Item(id: 6, name: "Databar"),
		Item(id: 7, name: "Dot"),
		Item(id: 8, name: "Stripes"),
		Item(id: 9, name: "Active"),
		Item(id: 10, name: "Bar"),
		Item(id: 11, name: "Bitmap Testing"),
		Item(id: 12, name: "SwiftUI Overlays"),
		Item(id: 13, name: "Percent Bar"),
		Item(id: 14, name: "Wiper Gauge"),
		Item(id: 15, name: "Activity Grid"),
		Item(id: 16, name: "Circular Progress"),
		Item(id: 17, name: "Circular Gauge"),

		Item(id: 99, name: "Testing Harness")
	]

	var body: some View {
		NavigationView {
			List(items) { item in
				NavigationLink(destination: DetailView(item: item))  {
					Text("\(item.name)")
				}
			} //.navigationBarTitle("Dynamic List")
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}


struct DetailView: View {
	let item: Item
	var body: some View {
		Self._printChanges()
		return ScrollView([.vertical]) {
			switch item.id {
			case 0: ReportView()
			case 1: WinLossCreate()
			case 2: TabletView(shouldAnimate: true)
			case 3: LineDemoContentView()
			case 4: StackLineDemoContentView()
			case 5: PieGraphDemoView()
			case 6: DataBarGraphContent()
			case 7: DotGraphView()
			case 8: StripesDemoView()
			case 9: MakeActiveView()
			case 10: BarDemoContentView()
			case 11: BitmapGenerationView()
			case 12: SwiftUIView(shouldAnimate: true)
			case 13: PercentBarView()
			case 14: WiperGraphDemoView()
			case 15: ActivityGridView()
			case 16: CircularProgressView()
			case 17: CircularGaugeView()

			case 99: TestingView()

			default: fatalError()
			}
		}
//		.padding()
	}
}
