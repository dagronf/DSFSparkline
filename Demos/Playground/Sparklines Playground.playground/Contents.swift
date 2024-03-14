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
let baseColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.033,  0.277, 0.650, 1.000])!
let primaryStroke = baseColor // (gray: 0.0, alpha: 0.3))
let primaryFill = DSFSparkline.Fill.Color(baseColor.copy(alpha: 0.3)!)

do {
	// A method to replace a value within a DataSource
	let replaceSource = DSFSparkline.DataSource(values: [0,1,2,3,4,5,6,7])
	Swift.print(replaceSource)

	var currentData = replaceSource.data
	currentData.replaceSubrange(3...3, with: [33])
	replaceSource.set(values: currentData)
	Swift.print(replaceSource)
}

// MARK: - Simple line graph

do {
	let bitmap = DSFSparklineSurface.Bitmap()   // Create a bitmap surface
	let line = DSFSparklineOverlay.Line()       // Create a line overlay
	line.strokeWidth = 1
	line.primaryStrokeColor = primaryStroke
	line.primaryFill = primaryFill
	line.dataSource = source                    // Assign the datasource to the overlay
	bitmap.addOverlay(line)                     // And add the overlay to the surface.

	// Generate an image with retina scale
	let image = bitmap.image(width: 50, height: 25, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/line-simple-small.png"))

	// Generate an image with retina scale
	line.interpolated = true
	let image2 = bitmap.image(width: 50, height: 25, scale: 2)!
	SaveImage(image: image2, path: URL(fileURLWithPath: "/tmp/line-simple-small-interpolated.png"))

	let attr = bitmap.attributedString(size: CGSize(width: 40, height: 18), scale: 2)!
	var message = NSMutableAttributedString(string: "Inlined ")
	message.append(attr)
	message.append(NSAttributedString(string: " line graph"))

	do {
		let bitmap = DSFSparklineSurface.Bitmap()   // Create a bitmap surface
		let line = DSFSparklineOverlay.Line()       // Create a line overlay
		line.strokeWidth = 1
		line.primaryStrokeColor = primaryStroke
		line.primaryFill = primaryFill
		line.markerSize = 3
		line.dataSource = source                    // Assign the datasource to the overlay
		bitmap.addOverlay(line)                     // And add the overlay to the surface.

		// Generate an image with retina scale
		let image = bitmap.image(width: 50, height: 25, scale: 2)!
	}

}

// MARK: - Simple bar graph

do {
	let bitmap = DSFSparklineSurface.Bitmap()   // Create a bitmap surface
	let bar = DSFSparklineOverlay.Bar()         // Create a bar overlay
	bar.dataSource = source                     // Assign the datasource to the overlay
	bar.primaryStrokeColor = baseColor
	bar.primaryFill = primaryFill
	bitmap.addOverlay(bar)                      // And add the overlay to the surface.

	// Generate an image with retina scale
	let image = bitmap.image(width: 50, height: 25, scale: 2)!

	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/bar-simple-small.png"))
}

// MARK: - Simple stackline graph

do {
	let bitmap = DSFSparklineSurface.Bitmap()        // Create a bitmap surface
	let stackline = DSFSparklineOverlay.Stackline()  // Create a stackline overlay
	stackline.dataSource = source                    // Assign the datasource to the overlay
	stackline.strokeWidth = 1
	stackline.primaryStrokeColor = baseColor
	stackline.primaryFill = primaryFill
	bitmap.addOverlay(stackline)                     // And add the overlay to the surface.

	// Generate an image with retina scale
	let image = bitmap.image(width: 50, height: 25, scale: 2)!

	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/stackline-simple-small.png"))
}

// MARK: - Simple dot graph

do {
	let bitmap = DSFSparklineSurface.Bitmap()    // Create a bitmap surface
	let dot = DSFSparklineOverlay.Dot()          // Create a dot graph overlay
	dot.dataSource = biggersource                // Assign the datasource to the overlay
	dot.onColor = primaryStroke
	bitmap.addOverlay(dot)                       // And add the overlay to the surface.

	// Generate an image with retina scale
	let image = bitmap.image(width: 50, height: 32, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/dot-simple-small.png"))
}

// MARK: - Simple win-loss graph

do {
	let bitmap = DSFSparklineSurface.Bitmap()       // Create a bitmap surface
	let winLoss = DSFSparklineOverlay.WinLossTie()  // Create a win-loss graph overlay
	winLoss.dataSource = winloss                    // Assign the datasource to the overlay
	winLoss.centerLine = .init(color: DSFColor.gray, lineWidth: 0.5, lineDashStyle: [0.5, 0.5])
	winLoss.winStroke = primaryStroke
	winLoss.winFill = primaryFill
	winLoss.lossStroke = primaryStroke
	winLoss.lossFill = primaryFill
	bitmap.addOverlay(winLoss)                      // And add the overlay to the surface.

	// Generate an image with retina scale
	let image = bitmap.image(width: 75, height: 12, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/win-loss-small.png"))
}

do {
	let bitmap = DSFSparklineSurface.Bitmap()          // Create a bitmap surface
	let winlosstie = DSFSparklineOverlay.WinLossTie()  // Create a win-loss graph overlay
	winlosstie.dataSource = winloss                    // Assign the datasource to the overlay
	winlosstie.winStroke = primaryStroke
	winlosstie.winFill = primaryFill
	winlosstie.lossStroke = primaryStroke
	winlosstie.lossFill = primaryFill
	winlosstie.tieStroke = primaryStroke
	winlosstie.tieFill = primaryFill
	bitmap.addOverlay(winlosstie)                      // And add the overlay to the surface.

	// Generate an image with retina scale
	let image = bitmap.image(width: 75, height: 16, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/win-loss-tie-small.png"))
}

// MARK: - Simple tablet graph

do {
	let bitmap = DSFSparklineSurface.Bitmap()    // Create a bitmap surface
	let tablet = DSFSparklineOverlay.Tablet()    // Create a tablet graph overlay
	tablet.dataSource = winloss                  // Assign the datasource to the overlay
	tablet.lineWidth = 1
	tablet.winStrokeColor = primaryStroke
	tablet.winFill = DSFSparkline.Fill.Color(baseColor.copy(alpha: 0.7)!)
	tablet.lossStrokeColor = primaryStroke
	bitmap.addOverlay(tablet)                    // And add the overlay to the surface.

	// Generate an image with retina scale
	let image = bitmap.image(width: 90, height: 16, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/tablet-small.png"))
}

// MARK: - Simple stripes

do {
	let bitmap = DSFSparklineSurface.Bitmap()    // Create a bitmap surface
	let stripe = DSFSparklineOverlay.Stripes()   // Create a stripe graph overlay
	stripe.integral = true
	stripe.barSpacing = 1
	stripe.dataSource = .init(values: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
	bitmap.addOverlay(stripe)                    // And add the overlay to the surface.

	// Generate an image with retina scale
	let image = bitmap.image(width: 90, height: 16, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/stripes-small.png"))
}

// MARK: - Simple pie

do {
	let bitmap = DSFSparklineSurface.Bitmap()
	let pieGraph = DSFSparklineOverlay.Pie()
	pieGraph.dataSource = DSFSparkline.StaticDataSource([10, 55, 20])
	pieGraph.lineWidth = 0.5
	pieGraph.strokeColor = CGColor.black

	bitmap.addOverlay(pieGraph)

	// Generate an image with retina scale
	let image = bitmap.image(width: 18, height: 18, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/pie-simple.png"))
}


// MARK: - simple databar

do {
	let bitmap = DSFSparklineSurface.Bitmap()
	let databar = DSFSparklineOverlay.DataBar()
	databar.dataSource = DSFSparkline.StaticDataSource([10, 20, 30])
	databar.lineWidth = 0.5
	databar.strokeColor = CGColor.black

	bitmap.addOverlay(databar)

	// Generate an image with retina scale
	let image = bitmap.image(width: 50, height: 18, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/databar-simple.png"))

	// databar with a maximum value defined

	databar.maximumTotalValue = 100
	databar.unsetColor = DSFColor.black.cgColor

	// Generate an image with retina scale
	let image2 = bitmap.image(width: 50, height: 18, scale: 2)!
	SaveImage(image: image2, path: URL(fileURLWithPath: "/tmp/databar-simple-maxvalue.png"))
}


// MARK: - simple percent bar

do {
	let style = DSFSparkline.PercentBar.Style()
	style.underBarColor = CGColor(gray: 0.8, alpha: 1.0)
	style.font = DSFFont(name: "Menlo", size: 10)!
	style.barEdgeInsets = DSFEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)

	let bitmap = DSFSparklineSurface.Bitmap()
	let percentbar = DSFSparklineOverlay.PercentBar(style: style, value: 0.3)

	bitmap.addOverlay(percentbar)

	// Generate an image with retina scale
	let image = bitmap.image(width: 50, height: 18, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/percentbar.png"))

	percentbar.value = 0.7
	style.showLabel = false
	percentbar.displayStyle = style
	// Generate an image with retina scale
	let image2 = bitmap.image(width: 50, height: 18, scale: 2)!
	SaveImage(image: image2, path: URL(fileURLWithPath: "/tmp/percentbar2.png"))
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

// MARK: - Simple wiper graph

do {
	let bitmap = DSFSparklineSurface.Bitmap()      // Create a bitmap surface
	let wiper = DSFSparklineOverlay.WiperGauge()   // Create a wiper graph overlay
	wiper.value = 0.75
	wiper.valueColor = DSFSparkline.ValueBasedFill(flatColor: baseColor)
	bitmap.addOverlay(wiper)                       // And add the overlay to the surface.

	// Generate an image with retina scale
	let image = bitmap.image(width: 40, height: 20, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/wiper-small.png"))
}

// MARK: - Activity Graph

do {
	let bitmap = DSFSparklineSurface.Bitmap()          // Create a bitmap surface
	let activity = DSFSparklineOverlay.ActivityGrid()
	let data: [CGFloat] = (0 ... 100).map { _ in CGFloat.random(in: 0...100) }
	activity.dataSource = .init(data)

	bitmap.addOverlay(activity)                       // And add the overlay to the surface.

	// Generate an image with retina scale
	let image = bitmap.image(width: 300, height: 100, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/activity-basic-1.png"))

	activity.verticalCellCount = 10
	activity.cellDimension = 6
	activity.cellSpacing = 1
	activity.cellFillScheme = DSFSparkline.ActivityGrid.CellStyle.DefaultLight
	let image2 = bitmap.image(width: 300, height: 100, scale: 2)!
	SaveImage(image: image2, path: URL(fileURLWithPath: "/tmp/activity-basic-2.png"))
}

// MARK: Circular Gauge

do {
	let bitmap = DSFSparklineSurface.Bitmap()         // Create a bitmap surface
	let wiper = DSFSparklineOverlay.CircularGauge()   // Create a wiper graph overlay
	wiper.value = 0.65
	//wiper.valueColor = DSFSparkline.ValueBasedFill(flatColor: baseColor)
	bitmap.addOverlay(wiper)                       // And add the overlay to the surface.

	// Generate an image with retina scale
	let image = bitmap.image(width: 40, height: 40, scale: 2)!
	SaveImage(image: image, path: URL(fileURLWithPath: "/tmp/circular-gauge-small.png"))
}
