//
//  GRKBarGraphView.m
//
//  Created by Levi Brown on July 11, 2014.
//  Copyright (c) 2014, 2015 Levi Brown <mailto:levigroker@gmail.com>
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
#import "GRKBarGraphBackingLayer.h"
#import "GRKBarGraphLayer.h"

@interface GRKBarGraphView ()

@property (nonatomic,strong) GRKBarGraphBackingLayer *backingLayer;
@property (nonatomic,strong) GRKBarGraphLayer *graphLayer;

@end

@implementation GRKBarGraphView

#pragma mark - Class Level

+ (Class)layerClass
{
    return GRKBarGraphBackingLayer.class;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

#pragma mark - Lifecycle

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
    
    self.backingLayer = (GRKBarGraphBackingLayer *)[self layer];
    self.backingLayer.contentsScale = [UIScreen mainScreen].scale;

    self.graphLayer = [[GRKBarGraphLayer alloc] init];
    self.graphLayer.contentsScale = [UIScreen mainScreen].scale;
    //Insert our graph layer below any other layers which may have been added (i.e. by a subview)
    [self.layer insertSublayer:self.graphLayer atIndex:0];

    //Setup our defaults
    self.barColorUsesTintColor = YES;
    self.backingLayer.color = self.tintColor.CGColor;
    self.barColor = self.tintColor;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    //Our view must not be opaque if we are to have our backing layer use a clearColor background (else we end up with black where we use clearColor in the layer).
    self.opaque = NO;
}

#pragma mark - Accessors

- (void)setMediaTimingFunction:(CAMediaTimingFunction *)mediaTimingFunction
{
    self.graphLayer.mediaTimingFunction = mediaTimingFunction;
}

- (CAMediaTimingFunction *)mediaTimingFunction
{
    return self.graphLayer.mediaTimingFunction;
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
    self.graphLayer.animationDuration = animationDuration;
}

- (NSTimeInterval)animationDuration
{
    return self.graphLayer.animationDuration;
}

- (UIColor *)barColor
{
    return [UIColor colorWithCGColor:self.graphLayer.color];
}

- (void)setBarColor:(UIColor *)barColor
{
    self.graphLayer.color = [barColor CGColor];
}

- (CGFloat)percent
{
    return self.graphLayer.percent;
}

- (void)setPercent:(CGFloat)percent
{
    //Sanitize input
    percent = MAX(0.0f, MIN(1.0f, percent));
    
    self.graphLayer.percent = percent;
}

- (GRKBarStyle)barStyle
{
    return self.graphLayer.barStyle;
}

- (void)setBarStyle:(GRKBarStyle)barStyle
{
    self.graphLayer.barStyle = barStyle;
}

- (void)setBarColorUsesTintColor:(BOOL)barColorUsesTintColor
{
    _barColorUsesTintColor = barColorUsesTintColor;
    if (barColorUsesTintColor)
    {
        self.barColor = self.tintColor;
    }
}

#pragma mark - Implementation

- (void)stopAnimation
{
    [self.graphLayer removeAnimationForKey:@"percent"];
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
