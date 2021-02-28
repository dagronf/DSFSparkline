import Cocoa

import DSFSparkline

var str = "Playground demonstrating the generation of a sparkline bitmap"

// Set this to 'true' to save the generated bitmaps out to the /tmp folder
let shouldSaveImage = false

func SaveImage(image: NSImage, path: URL) {

	guard shouldSaveImage else {
		return
	}

	guard let tiff = image.tiffRepresentation,
			let imageRep = NSBitmapImageRep(data: tiff),
			let pngData = imageRep.representation(using: .png, properties: [:]) else {
		return
	}

	do {
		try pngData.write(to: path)
	}
	catch {
		Swift.print("\(error)")
	}
}

// - MARK: Simple definitions

let source = DSFSparkline.DataSource(values: [4, 1, 8, 7, 5, 9, 3], range: 0 ... 10)
let biggersource = DSFSparkline.DataSource(values: [4, 1, 8, 7, 5, 9, 7, 6, 7, 8, 3, 3, 5, 3, 4, 1, 2, 9, 1, 3, 3], range: 0 ... 10)
let winloss = DSFSparkline.DataSource(values: [1, 1, 0, -1, 1, 1, 1, 0, 1, -1])

// Simple fill color
let primaryFill = DSFSparkline.Fill.Color(CGColor(gray: 0.0, alpha: 0.3))

// MARK: - Simple line graph

do {
	let bitmap = DSFSparklineSurface.Bitmap()   // Create a bitmap surface
	let stack = DSFSparklineOverlay.Line()      // Create a line overlay
	stack.strokeWidth = 1
	stack.primaryFill = primaryFill
	stack.dataSource = source                   // Assign the datasource to the overlay
	bitmap.addOverlay(stack)                    // And add the overlay to the surface.

	// Generate an image with retina scale
	let image = bitmap.image(width: 50, height: 25, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/simple-line.png"))


	// Generate an image with retina scale
	stack.interpolated = true
	let image2 = bitmap.image(width: 50, height: 25, scale: 2)!
	SaveImage(image: image2, path: URL(fileURLWithPath: "/tmp/simple-line-interpolated.png"))

}

// MARK: - Simple bar graph

do {
	let bitmap = DSFSparklineSurface.Bitmap()   // Create a bitmap surface
	let stack = DSFSparklineOverlay.Bar()       // Create a line overlay
	stack.dataSource = source                   // Assign the datasource to the overlay
	stack.primaryFill = primaryFill
	bitmap.addOverlay(stack)                    // And add the overlay to the surface.

	// Generate an image with retina scale
	let image = bitmap.image(width: 50, height: 25, scale: 2)!

	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/simple-bar.png"))
}

// MARK: - Simple stackline graph

do {
	let bitmap = DSFSparklineSurface.Bitmap()    // Create a bitmap surface
	let stack = DSFSparklineOverlay.Stackline()  // Create a line overlay
	stack.dataSource = source                    // Assign the datasource to the overlay
	stack.strokeWidth = 1
	stack.primaryFill = primaryFill
	bitmap.addOverlay(stack)                     // And add the overlay to the surface.

	// Generate an image with retina scale
	let image = bitmap.image(width: 50, height: 25, scale: 2)!

	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/simple-stack.png"))
}

// MARK: - Simple dot graph

do {
	let bitmap = DSFSparklineSurface.Bitmap()    // Create a bitmap surface
	let stack = DSFSparklineOverlay.Dot()
	stack.dataSource = biggersource              // Assign the datasource to the overlay
	bitmap.addOverlay(stack)                     // And add the overlay to the surface.

	// Generate an image with retina scale
	let image = bitmap.image(width: 50, height: 32, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/simple-dot.png"))
}

// MARK: - Simple win-loss graph

do {
	let bitmap = DSFSparklineSurface.Bitmap()
	let graph = DSFSparklineOverlay.WinLossTie()
	graph.dataSource = winloss

	graph.centerLine = .init(color: DSFColor.black, lineWidth: 0.5, lineDashStyle: [0.5, 0.5])
	bitmap.addOverlay(graph)

	// Generate an image with retina scale
	let image = bitmap.image(width: 75, height: 12, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/simple-winloss.png"))
}

do {
	let bitmap = DSFSparklineSurface.Bitmap()    // Create a bitmap surface
	let stack = DSFSparklineOverlay.WinLossTie()
	stack.dataSource = winloss
	stack.tieFill = DSFSparkline.Fill.Color(DSFColor.systemYellow.withAlphaComponent(0.5).cgColor)
	stack.tieStroke = DSFColor.systemYellow.withAlphaComponent(0.5).cgColor
	bitmap.addOverlay(stack)

	// Generate an image with retina scale
	let image = bitmap.image(width: 75, height: 16, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/simple-winlosstie.png"))
}

// MARK: - Simple tablet graph

do {
	let bitmap = DSFSparklineSurface.Bitmap()    // Create a bitmap surface
	let stack = DSFSparklineOverlay.Tablet()
	stack.dataSource = winloss
	stack.lineWidth = 1
	bitmap.addOverlay(stack)

	// Generate an image with retina scale
	let image = bitmap.image(width: 90, height: 16, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/simple-tablet.png"))
}

// MARK: - Simple stripes

do {
	let bitmap = DSFSparklineSurface.Bitmap()    // Create a bitmap surface
	let stack = DSFSparklineOverlay.Stripes()
	stack.dataSource = .init(values: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
	bitmap.addOverlay(stack)

	// Generate an image with retina scale
	let image = bitmap.image(width: 90, height: 16, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/simple-stripes.png"))
}

// MARK: - Simple pie

do {
	let bitmap = DSFSparklineSurface.Bitmap()
	let stack = DSFSparklineOverlay.Pie()
	stack.dataSource = DSFSparkline.StaticDataSource([10, 55, 20])
	stack.lineWidth = 0.5
	stack.strokeColor = CGColor.black

	bitmap.addOverlay(stack)

	// Generate an image with retina scale
	let image = bitmap.image(width: 18, height: 18, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/simple-pie.png"))
}


// MARK: - simple databar

do {
	let bitmap = DSFSparklineSurface.Bitmap()
	let stack = DSFSparklineOverlay.DataBar()
	stack.dataSource = DSFSparkline.StaticDataSource([10, 20, 30])
	stack.lineWidth = 0.5
	stack.strokeColor = CGColor.black

	bitmap.addOverlay(stack)

	// Generate an image with retina scale
	let image = bitmap.image(width: 50, height: 18, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/simple-databar.png"))

	// databar with a maximum value defined

	stack.maximumTotalValue = 100
	stack.unsetColor = DSFColor.black.cgColor

	// Generate an image with retina scale
	let image2 = bitmap.image(width: 50, height: 18, scale: 2)!
	SaveImage(image: image2, path: URL(fileURLWithPath: "/tmp/simple-databar-maxvalue.png"))

}



/// MARK: - A more complex sparkline

do {


	// Line DataSource

	var LineSource1: DSFSparkline.DataSource = {
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

}
