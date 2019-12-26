# Sparklines for macOS, iOS and tvOS

A description of this package.

| Setting | Minimum Version |
|---------|-----------------|
| `macOS` | `10.11`         |
| `iOS`   | `11.0`          |
| `tvOS`  | `11.0`          |

## Features

* Simple bar and line support
* y-range can automatically grow to encompass the full y-range of data.
* y-range can be fixed and the sparkline will truncate to the specified range
* `IBDesignable` support

## Overview

The library is split into a data model, and a view model.

### Data Model (data source)

Represents the data to be displayed.

The data source is assigned to the view model to provide data for drawing the sparkline. As data is changed the assigned view is automatically updated to reflect the new data

### View Model

Represents the viewable settings and display.

##### Common display customizations
* Chart color

##### Line graph customizations

| Setting         | Type      | Description                            |
|-----------------|-----------|----------------------------------------|
| `lineWidth`     | `CGFloat` | The width of the line                  |
| `interpolation` | `Bool`    | Interpolate a curve between the points |
| `lineShading`   | `Bool`    | Shade the area under the line          |
| `shadowed`      | `Bool`    | Draw a shadow under the line           |

##### Bar graph customizations

| Setting         | Type      | Description                  |
|-----------------|-----------|------------------------------|
| `lineWidth`     | `CGFloat` | The width of the line        |
| `barSpacing`    | `CGFloat` | The spacing between each bar |

## Integration

### Import the library into your source files

#### Cocoapods

``` 
target 'macOS Sparkline Demo' do
	platform :osx, '10.12'
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for macOS Sparkline Demo
  pod 'DSFSparkline', :path => '../DSFSparkline'
end
```

## Usage

```swift
import DSFSparkline
```
```objective-c
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

#### Set initial (or static) data

Note that this does not change the range value.  If values fall outside the y-range they will be truncated during drawing

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

#### Reset the sparkline

```swift
/// Swift
dataSource.reset()
```
```objective-c
/// Objective-C
[dataSource reset];
```

## License

```
MIT License

Copyright (c) 2019 Darren Ford

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
