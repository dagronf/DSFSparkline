//
//  ViewController.m
//  macOS Sparkline Demo Objc
//
//  Created by Darren Ford on 23/12/19.
//

#import "ViewController.h"

#import <CoreGraphics/CoreGraphics.h>

@import DSFSparkline;

@interface ViewController ()

@property (nonatomic, weak) IBOutlet DSFSparklineLineGraphView *lineGraph;
@property (nonatomic, strong) DSFSparklineDataSource* dataSource;

@property (weak) IBOutlet DSFSparklineBarGraphView* barGraph;
@property (nonatomic, strong) DSFSparklineDataSource* barDataSource;

@property (weak) IBOutlet DSFSparklineBarGraphView* centeredBarGraph;
@property (nonatomic, strong) DSFSparklineDataSource* centeredBarDataSource;

@property (weak) IBOutlet DSFSparklineDotGraphView *receiveGraph;
@property (nonatomic, strong) DSFSparklineDataSource* receiveDataSource;
@property (weak) IBOutlet DSFSparklineDotGraphView *sendGraph;
@property (nonatomic, strong) DSFSparklineDataSource* sendDataSource;

@property (weak) IBOutlet DSFSparklinePercentBarGraphView *percentBarThroughput;

@property (weak) IBOutlet DSFSparklineWiperGaugeGraphView *wiperGauge;


@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	srand48(time(0));

	_dataSource = [[DSFSparklineDataSource alloc] init];
	_barDataSource = [[DSFSparklineDataSource alloc] init];
	_centeredBarDataSource = [[DSFSparklineDataSource alloc] init];
	_receiveDataSource = [[DSFSparklineDataSource alloc] init];
	_sendDataSource = [[DSFSparklineDataSource alloc] init];

	[_wiperGauge setAnimationStyle:[[AnimationStyle alloc] initWithDuration:0.2 function: AnimatorFunctionTypeLinear]];

	// Add a custom marker drawing function
	[_lineGraph setMarkerDrawingBlock:^(CGContextRef context, NSArray<DSFSparklineOverlayLineMarker *> * markers) {

		// Just draw the markers for the 4 most recent values
		id ms = [markers subarrayWithRange:NSMakeRange([markers count] - 4, 4)];
		for (DSFSparklineOverlayLineMarker* m in ms) {
			CGContextSetFillColorWithColor(context, NSColor.whiteColor.CGColor);
			CGContextSetShadowWithColor(context, CGSizeMake(1, 1), 4, NSColor.linkColor.CGColor);
			CGContextFillRect(context, [m rect]);
		}
	}];

	[[self lineGraph] setDataSource:[self dataSource]];
	[[self dataSource] setRangeWithLowerBound:-1.0 upperBound:1.0];
	[[self lineGraph] setZeroLineDashStyleString: @"3,3"];

	[[self barGraph] setDataSource:[self barDataSource]];
	[[self barDataSource] setRangeWithLowerBound:0.0 upperBound:1.0];
	[[self barDataSource] setZeroLineValue:0.2];
	[[self barDataSource] setWindowSize:30];

	CGColorRef blue = CGColorCreateGenericRGB(0, 0, 1, 0.5);
	id high = [[DSFSparklineHighlightRangeDefinition alloc] initWithLowerBound:0.3
																						 upperBound:0.7
																						  fillColor:blue];
	[[self barGraph] setHighlightRangeDefinition:@[high]];

	[[self centeredBarGraph] setDataSource:[self centeredBarDataSource]];
	[[self centeredBarDataSource] setRangeWithLowerBound:-1.0 upperBound:1.0];
	//[[self centeredBarDataSource] setZeroLineValue:-0.2];
	[[self centeredBarDataSource] setWindowSize:22];

	[[self centeredBarDataSource] setWithValues:
	 @[@(0.0), @(0.1), @(0.2), @(0.3), @(0.4), @(0.5), @(0.6), @(0.7), @(0.8), @(0.9), @(1),
		@(0.0), @(-0.1), @(-0.2), @(-0.3), @(-0.4), @(-0.5), @(-0.6), @(-0.7), @(-0.8), @(-0.9), @(-1)]];

	[[self receiveGraph] setDataSource:[self receiveDataSource]];
	[[self receiveDataSource] setRangeWithLowerBound:0.0 upperBound:1.0];
	[[self sendGraph] setDataSource:[self sendDataSource]];
	[[self sendDataSource] setRangeWithLowerBound:0.0 upperBound:1.0];

	DSFSparklinePercentBarStyle* style = [[self percentBarThroughput] displayStyle];
	[style setBarEdgeInsets: NSEdgeInsetsMake(1, 1, 1, 1)];

	[self performUpdate];
}

- (void)performUpdate {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

		CGFloat v1 = drand48();
		[[self wiperGauge] setValue:v1];

		BOOL result = [[self dataSource] pushWithValue: (v1 * 2) - 1];
		[[self percentBarThroughput] setValue:v1];

		result = [[self barDataSource] pushWithValue: v1];

//		v1 = drand48();
//		result = [[self centeredBarDataSource] pushWithValue:(v1 * 2) - 1];


		v1 = drand48();
		result = [[self receiveDataSource] pushWithValue:v1];

		v1 = drand48();
		result = [[self sendDataSource] pushWithValue:v1];

		[self performUpdate];
	});
}

- (void)setRepresentedObject:(id)representedObject {
	 [super setRepresentedObject:representedObject];

	 // Update the view, if already loaded.
}


@end
