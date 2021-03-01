//
//  SwiftUIView.swift
//  Demos
//
//  Created by Darren Ford on 28/2/21.
//

import SwiftUI

struct SwiftUIView: View {
	let shouldAnimate: Bool
	var body: some View {
		ScrollView([.vertical, .horizontal]) {
			VStack {
				SuperCoolLineSpark()
				OverlayView()
				StripesOverlaidView()
				SwiftUILineGraphContentView(shouldAnimate: shouldAnimate)
			}
		}
	}
}

struct SwiftUIView_Previews: PreviewProvider {
	static var previews: some View {
		SwiftUIView(shouldAnimate: false)
	}
}
