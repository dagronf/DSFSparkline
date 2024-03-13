//
//  TestingView.swift
//  Demos
//
//  Created by Darren Ford on 14/4/21.
//

import SwiftUI
import DSFSparkline

struct TrackStyle {
	var color: Color = .black
	var width: Double = 40

	var hasShadow: Bool = false
	var shadowInner: Bool = false
	var shadowColor: Color = Color(white: 0, opacity: 0.8)
	var shadowOffset: CGSize = CGSize(width: 2, height: 2)
	var shadowBlur: Double = 2

	var hasStroke: Bool = false
	var strokeColor: Color = .black
	var strokeWidth: Double = 0.5

	var shadow: DSFSparkline.Shadow? {
		if hasShadow {
			return DSFSparkline.Shadow(
				blurRadius: shadowBlur,
				offset: shadowOffset,
				color: shadowColor.cgColor ?? CGColor.black,
				isInner: shadowInner
			)
		}
		return nil
	}

	var track: DSFSparklineOverlay.CircularGauge.TrackStyle {
		DSFSparklineOverlay.CircularGauge.TrackStyle(
			width: width,
			fillColor: DSFSparkline.Fill.Color(color.cgColor ?? .black),
			strokeWidth: strokeWidth,
			strokeColor: hasStroke ? strokeColor.cgColor : nil,
			shadow: shadow
		)
	}
}

struct CircularGaugeView: View {

	@State var value: Double = 0.25

	@State var trackStyle = TrackStyle(color: Color(red: 1, green: 0, blue: 0, opacity: 0.1), width: 40)
	@State var valueStyle = TrackStyle(color: Color(red: 1, green: 0, blue: 0, opacity: 1), width: 20)

	var body: some View {
		VStack {
			DSFSparklineCircularGaugeView.SwiftUI(
				value: value,
				trackStyle: trackStyle.track,
				valueStyle: valueStyle.track
			)
			.frame(width: 200, height: 200)

			Slider(value: $value, in: 0 ... 1) {
				Text("Value")
			}

			#if os(macOS)
			HStack(spacing: 16) {
				GroupBox("Track Settings") {
					TrackSettingsView(style: $trackStyle)
						.padding(8)
				}
				GroupBox("Value Settings") {
					TrackSettingsView(style: $valueStyle)
						.padding(8)
				}
			}
			#else
			HStack(spacing: 8) {
				TrackSettingsView(style: $trackStyle)
				TrackSettingsView(style: $valueStyle)
			}
			.frame(maxHeight: .infinity)
			#endif
		}
		.padding()
	}
}

struct TrackSettingsView: View {

	@Binding var style: TrackStyle

	var body: some View {
		Form {
			ColorPicker("Color", selection: $style.color)
			Slider(value: $style.width, in: 0.1 ... 50) {
				Text("Width")
			}
			Divider()
			Toggle("Shadow", isOn: $style.hasShadow)
			Toggle("Inner Shadow", isOn: $style.shadowInner)
				.disabled(!style.hasShadow)
			ColorPicker("Shadow Color", selection: $style.shadowColor)
				.disabled(!style.hasShadow)

			Slider(value: $style.shadowOffset.width, in: -10 ... 10) {
				Text("X Offset")
			}
			.disabled(!style.hasShadow)
			Slider(value: $style.shadowOffset.height, in: -10 ... 10) {
				Text("Y Offset")
			}
			.disabled(!style.hasShadow)
			Slider(value: $style.shadowBlur, in: 0.1 ... 10) {
				Text("Blur")
			}
			.disabled(!style.hasShadow)

			Divider()

			Toggle("Stroke", isOn: $style.hasStroke)
			ColorPicker("Stroke Color", selection: $style.strokeColor)
				.disabled(!style.hasStroke)
			Slider(value: $style.strokeWidth, in: 0.1 ... 5) {
				Text("Stroke Width")
			}
			.disabled(!style.hasStroke)
		}
	}
}

#Preview("All") {
	CircularGaugeView()
		.padding()
}

#Preview("Settings") {
	TrackSettingsView(style: .constant(TrackStyle()))
		.padding()
}
