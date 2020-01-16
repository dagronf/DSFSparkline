# Sparklines for macOS, iOS and tvOS

A lightweight sparkline component, supporting Swift and Objective-C.

<p align="center">
    <img src="https://img.shields.io/github/v/tag/dagronf/DSFSparkline" />
    <img src="https://img.shields.io/badge/macOS-10.11+-red" />
    <img src="https://img.shields.io/badge/iOS-11.0+-blue" />
    <img src="https://img.shields.io/badge/tvOS-11.0+-orange" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.0-orange.svg" />
    <img src="https://img.shields.io/badge/License-MIT-lightgrey" />
    <img src="https://img.shields.io/badge/pod-compatible-informational" alt="CocoaPods" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
</p>

## Features

* Simple bar and line support
* `IBDesignable` support so you can see your sparklines in interface builder.
* y-range can automatically grow or shrink to encompass the full y-range of data.
* y-range can be fixed and the sparkline will truncate to the specified range
* Line graph can draw with discrete lines or fitted to a curve

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
let sparklineView = DSFSparklineLineGraph(…)
sparklineView.graphColor = UIColor.blue
sparklineView.showZero = true

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


## View Model

Represents the viewable settings and display.

### Common display customizations

| Setting       | Type                | Description                                        |
|---------------|---------------------|----------------------------------------------------|
| `graphColor`  | `NSColor`/`UIColor` | The color to use when drawing the sparkline        |
| `showZero`    | `Bool`              | Draw a dotted line at the zero point on the y-axis |
| `windowSize ` | `UInt`              | The size of the sparkline window.                  |

### Line graph customizations

| Setting         | Type      | Description                            |
|-----------------|-----------|----------------------------------------|
| `lineWidth`     | `CGFloat` | The width of the line                  |
| `interpolation` | `Bool`    | Interpolate a curve between the points |
| `lineShading`   | `Bool`    | Shade the area under the line          |
| `shadowed`      | `Bool`    | Draw a shadow under the line           |

### Bar graph customizations

| Setting         | Type      | Description                  |
|-----------------|-----------|------------------------------|
| `lineWidth`     | `CGFloat` | The width of the line        |
| `barSpacing`    | `CGFloat` | The spacing between each bar |

### Dot graph customizations

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

## Screenshots

### In app

| macOS dark | macOS light | iOS |
|----|----|----|
| <img src="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_dark.png" width="300"> | <img src="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_light.png" width="300"> | <img src="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_iOS_animated.gif"> |

### Interface Builder

| macOS | tvOS |
|----|----|
|<a href="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_interfacebuilder.png"><img src="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_interfacebuilder.png" width="303"></a>|<a href="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_interfacebuilder-2.png"><img src="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_interfacebuilder-2.png" width="420"></a>|

### Animated

<a href="https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_lots.mp4">900+ sparklines at once</a>

![](https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFSparkline/DSFSparkline_lots.gif)


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
