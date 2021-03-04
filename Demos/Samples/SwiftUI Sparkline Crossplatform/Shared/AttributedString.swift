//
//  AttributedString.swift
//  Demos
//
//  Appropriated from https://swiftui-lab.com/attributed-strings-with-swiftui/
//  An NSTextView wrapped for SwiftUI containing an attributed string.

import SwiftUI

#if os(macOS)

import AppKit

struct AttributedText: View  {
	@State var size: CGSize = .zero
	let attributedString: NSAttributedString

	init(_ attributedString: NSAttributedString) {
		self.attributedString = attributedString
	}

	var body: some View {
		AttributedTextRepresentable(attributedString: attributedString, size: $size)
			.frame(width: size.width, height: size.height)
	}

	struct AttributedTextRepresentable: NSViewRepresentable {

		let attributedString: NSAttributedString
		@Binding var size: CGSize

		func makeNSView(context: Context) -> NSTextView {
			let textView = NSTextView()

			guard let textContainer = textView.textContainer else {
				fatalError()
			}

			textContainer.widthTracksTextView = false
			textContainer.containerSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
			textView.drawsBackground = false

			return textView
		}

		func updateNSView(_ nsView: NSTextView, context: Context) {

			nsView.textStorage?.setAttributedString(attributedString)

			DispatchQueue.main.async {
				if let textContainer = nsView.textContainer,
					let layoutManager = textContainer.layoutManager {
					layoutManager.ensureLayout(for: textContainer)
					size = layoutManager.usedRect(for: textContainer).size
				}
				else {
					size = .zero
				}

				// This doesn't work accurately.
				//size = nsView.textStorage!.size()
			}
		}
	}
}

#else

import UIKit

struct AttributedText: View {
	@State private var size: CGSize = .zero
	let attributedString: NSAttributedString

	init(_ attributedString: NSAttributedString) {
		self.attributedString = attributedString
	}

	var body: some View {
		AttributedTextRepresentable(attributedString: attributedString, size: $size)
			.frame(width: size.width, height: size.height)
	}

	struct AttributedTextRepresentable: UIViewRepresentable {

		let attributedString: NSAttributedString
		@Binding var size: CGSize

		func makeUIView(context: Context) -> UILabel {
			let label = UILabel()

			label.lineBreakMode = .byClipping
			label.numberOfLines = 0

			return label
		}

		func updateUIView(_ uiView: UILabel, context: Context) {
			uiView.attributedText = attributedString

			DispatchQueue.main.async {
				size = uiView.sizeThatFits(uiView.superview?.bounds.size ?? .zero)
			}
		}
	}
}

#endif
