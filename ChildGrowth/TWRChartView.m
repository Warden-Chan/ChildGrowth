//
//  TWRChartView.m
//  ChartJS
//
//  Created by Michelangelo Chasseur on 21/04/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#import "TWRChartView.h"
#import "TWRLineChart.h"
#import "TWRBarChart.h"
#import "TWRChartBuilder.h"
#import "TWRCircularChart.h"

@interface TWRChartView () <UIWebViewDelegate>

@property (copy, nonatomic) NSString *htmlFilePath;
@property (copy, nonatomic) NSString *jsFileString;
@property (copy, nonatomic) TWRAnimationCompletionBlock block;

@end

@implementation TWRChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
        
    }
    return self;
}

- (void)commonInit {
    //设置可以放大属性
    self.scalesPageToFit = YES;
    //    _chartView.multipleTouchEnabled = YES;
    self.userInteractionEnabled = YES;
    // Setting self as the delegate
    self.delegate = self;
    
    // Let the view be transparent
    self.opaque = NO;
    
    // HTML index file

    NSString *htmlFilePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    _htmlFilePath = htmlFilePath;
    self.userInteractionEnabled = NO;
}

- (void)didMoveToSuperview {
    // Init request
    NSError *error;
    
    // Load Javascript and store it in local ivar
    _jsFileString = [NSString stringWithContentsOfFile:_chartJsFilePath encoding:NSUTF8StringEncoding error:&error];
    
    [self loadIndex];
//    [self loadRequest:request];
}

- (void)loadBarChart:(TWRBarChart *)barChart {
    if ([barChart isKindOfClass:[TWRBarChart class]] ) {
        _jsFileString = [TWRChartBuilder buildChartWithElement:barChart];
        [self stringByEvaluatingJavaScriptFromString:_jsFileString];
        [self loadIndex];
    } else {
        NSException *exception = [NSException exceptionWithName:@"TWRChartInvalicChartElement"
                                                         reason:@"The element object provided to the chart view is not a valid bar chart."
                                                       userInfo:nil];
        [exception raise];
    }
}

- (void)loadBarChart:(TWRBarChart *)barChart withCompletionHandler:(TWRAnimationCompletionBlock)block {
    _block = block;
    [self loadBarChart:barChart];
}

- (void)loadLineChart:(TWRLineChart *)lineChart {
    if ([lineChart isKindOfClass:[TWRLineChart class]]) {
        _jsFileString = [TWRChartBuilder buildChartWithElement:lineChart];
//        NSLog(@"-------%@",_jsFileString);
        [self stringByEvaluatingJavaScriptFromString:_jsFileString]; //修改UIWeb界面元素的值
        [self loadIndex];
    } else {
        NSException *exception = [NSException exceptionWithName:@"TWRChartInvalicChartElement"
                                                         reason:@"The element object provided to the chart view is not a valid line chart."
                                                       userInfo:nil];
        [exception raise];
    }
}

- (void)loadLineChart:(TWRLineChart *)lineChart withCompletionHandler:(TWRAnimationCompletionBlock)block {
    _block = block;
    [self loadLineChart:lineChart];
}

- (void)loadCircularChart:(TWRCircularChart *)circularChart {
    if ([circularChart isKindOfClass:[TWRCircularChart class]]) {
        _jsFileString = [TWRChartBuilder buildChartWithElement:circularChart];
        [self stringByEvaluatingJavaScriptFromString:_jsFileString];
        [self loadIndex];
    } else {
        NSException *exception = [NSException exceptionWithName:@"TWRChartInvalicChartElement"
                                                         reason:@"The element object provided to the chart view is not a valid circular chart."
                                                       userInfo:nil];
        [exception raise];
    }
}

- (void)loadCircularChart:(TWRCircularChart *)circularChart withCompletionHandler:(TWRAnimationCompletionBlock)block {
    _block = block;
    [self loadCircularChart:circularChart];
}

#pragma mark - Private API

- (void)loadIndex {
    NSError *error;
    // Load index.html
    NSString *htmlString = [NSString stringWithContentsOfFile:_htmlFilePath encoding:NSUTF8StringEncoding error:&error];
    
    // Set canvas size according to frame dimensions. Leave space for labels at the bottom.
    NSString *canvasString = [NSString stringWithFormat:@"<canvas id=\"canvas\" height=\"%d\" width=\"%d\"></canvas>", (int)CGRectGetHeight(self.frame)-20, (int)CGRectGetWidth(self.frame) - 10];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<canvas></canvas>" withString:canvasString];
    
    // Load it!
    [self loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];
}

#pragma mark - Web View Delegate methods

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self stringByEvaluatingJavaScriptFromString:_jsFileString];
    [webView stringByEvaluatingJavaScriptFromString:@"var element = document.createElement('meta');  element.name = \"viewport\";  element.content = \"width=device-width,initial-scale=1.0,minimum-scale=0.25,maximum-scale=10,user-scalable=1\"; var head = document.getElementsByTagName('head')[0]; head.appendChild(element);var body = document.getElementsByTagName('body')[0]; body.style.webkitTextSizeAdjust ='5%';"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // Listen for Javasrcipt callback when chart ends animation
    if ( [[[request URL] scheme] isEqualToString:@"callback"] ) {
        if (_block) {
            _block(YES);
        }
        return NO;
    }
    return YES;
}

@end
