import Cocoa

import DSFSparkline

var str = "Playground demonstrating the generation of a sparkline bitmap"

// Line DataSource

fileprivate var LineSource1: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 20, /*range: 0 ... 1,*/ zeroLineValue: 0.3)
	d.push(values: [
		0.72, 0.84, 0.15, 0.16, 0.30, 0.58, 0.87, 0.44, 0.02, 0.27,
		0.48, 0.16, 0.15, 0.14, 0.81, 0.53, 0.67, 0.52, 0.07, 0.50
	])
	return d
}()

var bitmap = DSFSparklineSurface.Bitmap()

// highlight overlay 1

do {
	let h1 = DSFSparklineOverlay.RangeHighlight()
	h1.dataSource = LineSource1
	h1.fill = DSFSparkline.Fill.Color(NSColor.gray.withAlphaComponent(0.2).cgColor)
	h1.highlightRange = 0.3 ..< 0.7
	bitmap.addOverlay(h1)
}

// highlight overlay 2

do {
	let h2 = DSFSparklineOverlay.RangeHighlight()
	h2.dataSource = LineSource1
	h2.fill = DSFSparkline.Fill.Color(NSColor.systemRed.withAlphaComponent(0.1).cgColor)
	h2.highlightRange = 0.0 ..< 0.3
	bitmap.addOverlay(h2)
}

// zero-line

do {
	let zeroLine = DSFSparklineOverlay.ZeroLine()
	zeroLine.dataSource = LineSource1
	bitmap.addOverlay(zeroLine)
}

// Stack overlay

do {
	let stack = DSFSparklineOverlay.Stackline()
	stack.dataSource = LineSource1
	stack.shadow = NSShadow(blurRadius: 1.0, offset: CGSize(width: 0.5, height: -0.5), color: DSFColor.black.withAlphaComponent(0.3))
	stack.centeredAtZeroLine = true
	stack.strokeWidth = 1
	stack.primaryStrokeColor = NSColor.systemPurple.cgColor
	stack.primaryFill = DSFSparkline.Fill.Color(NSColor.systemPurple.withAlphaComponent(0.7).cgColor)
	stack.secondaryStrokeColor = NSColor.systemPink.cgColor
	stack.secondaryFill = DSFSparkline.Fill.Color(NSColor.systemPink.withAlphaComponent(0.7).cgColor)
	bitmap.addOverlay(stack)
}

// Generate a bitmap

let r = CGSize(width: 200, height: 40)
let image = bitmap.image(size: r, scale: 2)
