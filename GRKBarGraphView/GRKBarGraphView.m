//
//  GRKBarGraphView.m
//
//  Created by Levi Brown on July 11, 2014.
//  Copyright (c) 2014 Levi Brown <mailto:levigroker@gmail.com>
//  This work is licensed under the Creative Commons Attribution 3.0
//  Unported License. To view a copy of this license, visit
//  http://creativecommons.org/licenses/by/3.0/ or send a letter to Creative
//  Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041,
//  USA.
//
//  The above attribution and the included license must accompany any version
//  of the source code. Visible attribution in any binary distributable
//  including this work (or derivatives) is not required, but would be
//  appreciated.
//

#import "GRKBarGraphView.h"
#import "GRKBackingLayer.h"
#import "GRKBarGraphLayer.h"

@interface GRKBarGraphView ()

@property (nonatomic,strong) GRKBackingLayer *backingLayer;
@property (nonatomic,strong) GRKBarGraphLayer *barGraphLayer;
@property (nonatomic,strong) CAShapeLayer *staticLayer;

@end

@implementation GRKBarGraphView

#pragma mark - Class Level

+ (Class)layerClass
{
    return GRKBackingLayer.class;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //Here we have a custom layer backing this view, in which we draw the static parts of our graph, such as the border.
    //We have a custom sublayer, GRKBarGraphLayer, which is used to render the animatable parts of the graph independently.
    //This optimizes the drawing when animating.
    //The backing layer is configured to layout its subviews with the same dimensions as itself, so we need not specify the frame of the sublayer here.
    
    self.backingLayer = (GRKBackingLayer *)[self layer];
    
    self.barGraphLayer = [[GRKBarGraphLayer alloc] init];
    self.barGraphLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.barGraphLayer];

    //Setup our defaults
    self.barColorUsesTintColor = YES;
    self.backingLayer.color = self.tintColor.CGColor;
    self.barColor = self.tintColor;
    self.backgroundColor = [UIColor clearColor];
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark - Accessors

- (void)setMediaTimingFunction:(CAMediaTimingFunction *)mediaTimingFunction
{
    self.barGraphLayer.mediaTimingFunction = mediaTimingFunction;
}

- (CAMediaTimingFunction *)mediaTimingFunction
{
    return self.barGraphLayer.mediaTimingFunction;
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
    self.barGraphLayer.animationDuration = animationDuration;
}

- (NSTimeInterval)animationDuration
{
    return self.barGraphLayer.animationDuration;
}

- (UIColor *)barColor
{
    return [UIColor colorWithCGColor:self.barGraphLayer.color];
}

- (void)setBarColor:(UIColor *)barColor
{
    self.barGraphLayer.color = [barColor CGColor];
}

- (CGFloat)percent
{
    return self.barGraphLayer.percent;
}

- (void)setPercent:(CGFloat)percent
{
    //Sanitize input
    percent = MAX(0.0f, MIN(1.0f, percent));
    
    self.barGraphLayer.percent = percent;
}

- (GRKBarStyle)barStyle
{
    return self.barGraphLayer.barStyle;
}

- (void)setBarStyle:(GRKBarStyle)barStyle
{
    self.barGraphLayer.barStyle = barStyle;
}

- (void)setBarColorUsesTintColor:(BOOL)barColorUsesTintColor
{
    _barColorUsesTintColor = barColorUsesTintColor;
    if (barColorUsesTintColor)
    {
        self.barColor = self.tintColor;
    }
}

#pragma mark - Overrides

- (void)tintColorDidChange
{
    [super tintColorDidChange];
    
    self.backingLayer.color = self.tintColor.CGColor;
    if (self.barColorUsesTintColor)
    {
        self.barColor = self.tintColor;
    }
}

@end
