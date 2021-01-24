# Sparklines for macOS, iOS and tvOS

A lightweight sparkline component, supporting Swift, SwiftUI, macCatalyst and Objective-C.

<p align="center">
    <img src="https://img.shields.io/github/v/tag/dagronf/DSFSparkline" />
    <img src="https://img.shields.io/badge/macOS-10.11+-red" />
    <img src="https://img.shields.io/badge/iOS-11.0+-blue" />
    <img src="https://img.shields.io/badge/tvOS-11.0+-orange" />
    <img src="https://img.shields.io/badge/SwiftUI-1.0+-green" />
    <img src="https://img.shields.io/badge/macCatalyst-1.0+-purple" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.0-orange.svg" />
    <img src="https://img.shields.io/badge/License-MIT-lightgrey" />
    <img src="https://img.shields.io/badge/pod-compatible-informational" alt="CocoaPods" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
</p>

## WARNING: Breaking Changes for 2.0.0

Note that the 2.0.0 release has changes that will break your existing DSFSparkline code. Please see below for the changes.

## Features

* Simple bar, dot and line graph support.
* `IBDesignable` support so you can see your sparklines in interface builder.
* y-range can automatically grow or shrink to encompass the full y-range of data.
* y-range can be fixed and the sparkline will truncate to the specified range
* Line graph can draw with discrete lines or fitted to a curve'
* Optional drawing of a 'zero line' on the bar and line graphs (thanks [Tito Ciuro](https://github.com/tciuro))
* SwiftUI support

## Available types

### Line
![](https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/types/line.jpg)
![](https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/types/interpolated_line.jpg)
### Bar
![](https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/types/bar.jpg)
### Dot
![](https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/types/dot_graph.jpg)


## Overview

The library is split into a data model and a view model.  A data source (model) is created and assigned to a view model in order to populate the sparkline.

So, a very simple example…

```swift

// Create the view
let sparklineView = DSFSparklineLineGraphView(…)
sparklineView.graphColor = UIColor.blue
sparklineView.showZeroLine = true

// Create the datasource and assign to the view
let sparklineDataSource = DSFSparklineDataSource(windowSize: 30, range: -1.0 ... 1.0)
sparklineView.dataSource = sparklineDataSource

…

// Add a single new data element to the sparkline
sparklineDataSource.push(value: 0.7)                          // view automatically updates with new data

// Add a set of data to the sparkline
sparklineDataSource.push(values: [0.3, -0.2, 1.0])            // view automatically updates with new data

// Completely replace the sparkline data with a new set of data
sparklineDataSource.set(values: [0.2, -0.2, 0.0, 0.9, 0.8])   // view automatically resets to new data

```

## Data Model (data source)

Represents the data to be displayed.

The data source is assigned to the view model to provide data for drawing the sparkline. As data is changed the assigned view is automatically updated to reflect the new data.  If more data is added via a push or set the data is added to the datasource, the associated view will automatically update to reflect the new data. Older data that no longer falls within the window is discarded.

### Range

An optional range can be set on the data source, which means that the view will automatically clip any incoming data to that range.  Without a range specified, the sparkline's vertical range will grow and shrink to accomodate the full range of data.


## Views

Represents the viewable settings and display.  The current view types available are :-

* DSFSparklineLineGraphView
* DSFSparklineBarGraphView
* DSFSparklineDotGraphView

### Common display customizations

| Setting               | Type                | Description                                             |
|-----------------------|---------------------|---------------------------------------------------------|
| `graphColor`          | `NSColor`/`UIColor` | The color to use when drawing the sparkline             |

### Common elements for graphs that can display a zero line (Line/Bar)

| Setting               | Type                | Description                                             |
|-----------------------|---------------------|---------------------------------------------------------|
| `showZeroLine`        | `Bool`              | Draw a dotted line at the zero line point on the y-axis |
| `zeroLineColor`       | `NSColor`/`UIColor` | The color of the 'zero line' on the y-axis.             |
| `zeroLineWidth`       | `CGFloat`           | The width of the 'zero line' on the y-axis              |
| `zeroLineDashStyle`   | `[CGFloat]`         | The dash pattern to use when drawing the zero line      |

### Line graph customizations (`DSFSparklineLineGraphView`)

| Setting         | Type      | Description                            |
|-----------------|-----------|----------------------------------------|
| `lineWidth`     | `CGFloat` | The width of the line                  |
| `interpolation` | `Bool`    | Interpolate a curve between the points |
| `lineShading`   | `Bool`    | Shade the area under the line          |
| `shadowed`      | `Bool`    | Draw a shadow under the line           |

### Bar graph customizations (`DSFSparklineBarGraphView`)

| Setting         | Type      | Description                  |
|-----------------|-----------|------------------------------|
| `lineWidth`     | `CGFloat` | The width of the line        |
| `barSpacing`    | `CGFloat` | The spacing between each bar |

### Dot graph customizations (`DSFSparklineDotGraphView`)

| Setting           | Type                | Description                                        |
|-------------------|---------------------|----------------------------------------------------|
| `upsideDown`      | `Bool`              | If true, draws from the top of the graph downwards |
| `unsetGraphColor` | `NSColor`/`UIColor` | The color to use when drawing the background       |

## Integration

There are demos available in the `Demos` subfolder for each of the supported platforms.  The demos use CocoaPods so you'll need to `pod install` in the Demos folder.

### Import the library into your source files

#### Cocoapods

`pod 'DSFSparkline', :git => 'https://github.com/dagronf/DSFSparkline/'`

#### Swift package manager

Add `https://github.com/dagronf/DSFSparkline` to your project.

## Usage

```swift
/// Swift
import DSFSparkline
```
```objective-c
/// Objective-C
@import DSFSparkline;
```

### Window size and (optional) y-range

#### Set the size of the display window

* If the window size is reduced, stored data is truncated.
* If the window size is increased, the data store is padded with zeros

```swift
/// Swift
dataSource.windowSize = 30
assert(dataSource.windowSize == 30)
```
```objective-c
/// Objective-C
[dataSource setWindowSize:30];
assert([dataSource windowSize] == 30);
```

#### Set the y-range for the sparkline

Changing the y-range does not change the stored data.  The y-range is used during drawing to truncate to the upper and lower bounds, so the range can be changed safely at any time.

```swift
/// Swift
dataSource.range = -1.0 ... 1.0
```

```objective-c
/// Objective-C
[dataSource setRangeWithLowerBound:-1.0 upperBound:1.0];
```

#### Setting the 'zero line' value for the sparkline

The 'zero line' represents the dotted line that is drawn horizontally across the line and bar graphs. By default, this zero line is set at 0.0 within the graph's window values. 

You can change the 'zero line' to an arbitrary value using the `zeroLineValue` on the data source.

```swift
// Initialize to draw a dotted line at 0.8 
let datasource = DSFSparklineDataSource(range: 0 ... 1, zeroLineValue: 0.8)

// Change the data source to draw the zeroline at 0.3
myDataSource.zeroLineValue = 0.3

```

### Modifying or retrieving data

#### Get the current set of data

```swift
/// Swift
dataSource.data
```
```objective-c
/// Objective-C
[dataSource data];
```

#### Set data

Note that this does not change the range value if a range has been set.  If values fall outside the y-range they will be truncated during drawing.  If no range has been set then the sparkline is scaled to fit the full y-range.

```swift
/// Swift
dataSource.set(values: [1, 2, 3, 4, 5])
```
```objective-c
/// Objective-C
[dataSource setWithValues:@[@(1), @(2), @(3), @(4), @(5)]];
```

#### Push a new value onto the sparkline

```swift
/// Swift
dataSource.push(value: 4.5)
```
```objective-c
/// Objective-C
[dataSource pushWithValue:@(4.5)];
```

#### Push an array of values onto the sparkline

`dataSource.push(values: [x, y, z])` is equivalent to 

```
dataSource.push(value: x)
dataSource.push(value: y)
dataSource.push(value: z)
```

```swift
/// Swift
dataSource.push(values: [4.5, 10.3, 11])
```
```objective-c
/// Objective-C
[dataSource pushWithValues:@[@(4.5), @(10.3), @(11)]];
```

#### Reset the sparkline

Reset the data to the lower bound for all data points in the window.  If no lower bound is set, all data values are set to zero.

```swift
/// Swift
dataSource.reset()
```
```objective-c
/// Objective-C
[dataSource reset];
```

## SwiftUI Support

Each graph type provides its own SwiftUI view (appending `.SwiftUI` to the class name).

```swift
struct SparklineView: View {

   let leftDataSource: DSFSparklineDataSource
   let rightDataSource: DSFSparklineDataSource
   
   var body: some View {
      HStack {
         DSFSparklineLineGraphView.SwiftUI(
            dataSource: leftDataSource,
            graphColor: UIColor.red,
            showZeroLine: false,
            interpolated: true)
         DSFSparklineLineGraphView.SwiftUI(
            dataSource: rightDataSource,
            graphColor: UIColor.blue,
            showZeroLine: true,
            interpolated: true)
      }
   }
}
```

## Screenshots

### In app

| macOS dark | macOS light | iOS |
|----|----|----|
| <img src="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_dark.png" width="300"> | <img src="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_light.png" width="300"> | <img src="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_iOS_animated.gif"> |

### Interface Builder

| macOS | tvOS |
|----|----|
|<a href="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_interfacebuilder.png"><img src="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_interfacebuilder.png" width="303"></a>|<a href="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_interfacebuilder-2.png"><img src="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_interfacebuilder-2.png" width="420"></a>|

### SwiftUI

<a href="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/SwiftUI1.png"><img src="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/SwiftUI1.png" width="400"></a>

### Animated

![](https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_lots.gif)

## Changes

### `3.1.0`

* Add the ability to customize the zero-line display ([Tito Ciuro](https://github.com/tciuro))
* Changed `showZero` to `showZeroLine` for consistency with the new zero-line display values

### `3.0.0`

* Add the ability to set the 'zero' line value. Defaults to zero for backwards compatibility.

You can set where the 'zero' line draws via the `zeroLineValue` on the datasource.

### `2.0.0`

* The primary views have been renamed with a `View` postfix. So

   `DSFSparklineLineGraph` -> `DSFSparklineLineGraphView`
   
   `DSFSparklineBarGraph` -> `DSFSparklineBarGraphView`
   
   `DSFSparklineDotGraph` -> `DSFSparklineDotGraphView`

* Renamed `SLColor` and `SLView` to `DSFColor` and `DSFView` for module naming consistency.

* I removed `windowSize` from the core `DSFSparklineView`. `windowSize` is related to data, and should never have been part of the UI definition.  I've provided a replacement purely for `IBDesignable` support called `graphWindowSize` which should only be called from Interface Builder.  If you want to set the windowSize from your xib file, set the `graphWindowSize` inspectable.

	If you see warnings in the log like 
`2020-12-07 18:22:51.619867+1100 iOS Sparkline Demo[75174:1459637] Failed to set (windowSize) user defined inspected property on (DSFSparkline.DSFSparklineBarGraphView): [<DSFSparkline.DSFSparklineBarGraphView 0x7fe2eb10f2b0> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key windowSize.
`
it means that you have a `windowSize` value set in your .xib file.  Remove it and set the `graphWindowSize` value instead.

* For the Bar type, `lineWidth` and `barSpacing` now represent the pixel spacing between bars and the pixel width for the line.  You may find that your line spacing and bar spacing are now incorrect if you have set fractional values for these in the past (for example, if you set lineWidth = 0.5).  The reason for this change is to aid drawing lines on pixel boundaries and avoid antialiasing.

* Fix for zero line being upside-down

## License

```
MIT License

Copyright (c) 2020 Darren Ford

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
