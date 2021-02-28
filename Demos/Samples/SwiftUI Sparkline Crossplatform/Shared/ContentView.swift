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
		Item(id: 2, name: "Line"),
		Item(id: 3, name: "Stackline"),
		Item(id: 4, name: "Pie Chart"),
		Item(id: 5, name: "Databar"),
		Item(id: 6, name: "Dot"),
		Item(id: 7, name: "Stripes"),
		Item(id: 8, name: "Active"),
		Item(id: 9, name: "Bar"),
		Item(id: 10, name: "Bitmap Testing"),
		Item(id: 11, name: "SwiftUI Overlays")
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
		Group {
			switch item.id {
			case 0: ReportView()
			case 1: WinLossCreate()
			case 2: LineDemoContentView()
			case 3: StackLineDemoContentView()
			case 4: PieGraphDemoView()
			case 5: DataBarGraphContent()
			case 6: DotGraphView()
			case 7: StripesDemoView()
			case 8: MakeActiveView()
			case 9: BarDemoContentView()
			case 10: BitmapGenerationView()
			case 11: SwiftUIView(shouldAnimate: true)
			default: fatalError()
			}
		}
		.padding()
	}
}
