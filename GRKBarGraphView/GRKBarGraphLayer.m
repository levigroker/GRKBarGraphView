//
//  GRKBarGraphLayer.m
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

#import "GRKBarGraphLayer.h"

static NSTimeInterval const kGRKDefaultAnimationDuration = 0.0f;

@implementation GRKBarGraphLayer

@dynamic percent, color, barStyle;

#pragma mark - Class Level

+ (NSSet *)animationKeys
{
    static NSSet *keys = nil;
    if (!keys)
    {
        keys = [NSSet setWithObjects:@"percent", nil];
    }
    
    return keys;
}

+ (NSSet *)displayKeys
{
    static NSSet *keys = nil;
    if (!keys)
    {
        keys = [NSSet setWithObjects:@"color", @"barStyle", @"bounds", nil];
    }
    
    return keys;
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([[self animationKeys] containsObject:key] || [[self displayKeys] containsObject:key])
    {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        [self setup];
        
        //Copy custom property values into our new instance from the given layer.
        //We need to do this or layers created in the animation process will not get our custom property values.
        GRKBarGraphLayer *baseLayer = (GRKBarGraphLayer *)layer;
        self.animationDuration = baseLayer.animationDuration;
        self.mediaTimingFunction = baseLayer.mediaTimingFunction;
        self.percent = baseLayer.percent;
        self.color = baseLayer.color;
        self.barStyle = baseLayer.barStyle;
    }
    return self;
}

- (void)setup
{
    //Set ourself as our delegate so we can prevent implicit animations of properties we don't want to animate.
    self.delegate = self;
    //Defaults
    self.mediaTimingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    self.animationDuration = kGRKDefaultAnimationDuration;
    self.barStyle = GRKBarStyleFromLeft;
    self.backgroundColor = [[UIColor clearColor] CGColor];
}

#pragma mark - CALayer Delegate

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    id<CAAction> retVal = nil;
    
    if (![layer isEqual:self] || ![[self animationKeys] containsObject:event])
    {
        retVal = (id<CAAction>)[NSNull null]; // disable all implicit animations
    }
    
    return  retVal;
}

#pragma mark - Animation

- (id<CAAction>)actionForKey:(NSString *)event
{
    id<CAAction> retVal = [self animationForKey:event];
    if (!retVal)
    {
        retVal = [super actionForKey:event];
    }
    
    return retVal;
}

- (CABasicAnimation *)animationForKey:(NSString *)key
{
    CABasicAnimation *retVal = nil;
    
    if (self.animationDuration > 0.0f && [[self.class animationKeys] containsObject:key])
    {
        retVal = [CABasicAnimation animationWithKeyPath:key];
        retVal.fromValue = [[self presentationLayer] valueForKey:key];
        retVal.timingFunction = self.mediaTimingFunction;
        retVal.duration = self.animationDuration;
    }
    
	return retVal;
}

#pragma mark - Drawing

- (void)drawInContext:(CGContextRef)context
{
    CGFloat x, y, width, height;
    
    switch (self.barStyle)
    {
        case GRKBarStyleFromTop:
        {
            x = 0;
            y = 0;
            width = self.bounds.size.width;
            height = self.bounds.size.height * self.percent;
            break;
        }
        case GRKBarStyleFromBottom:
        {
            height = self.bounds.size.height * self.percent;
            x = 0;
            y = self.bounds.size.height - height;
            width = self.bounds.size.width;
            height = self.bounds.size.height * self.percent;
            break;
        }
        case GRKBarStyleFromRight:
        {
            width = self.bounds.size.width * self.percent;
            x = self.bounds.size.width - width;
            y = 0;
            height = self.bounds.size.height;
            break;
        }
        case GRKBarStyleFromLeft:
        default:
        {
            x = 0;
            y = 0;
            width = self.bounds.size.width * self.percent;
            height = self.bounds.size.height;
            break;
        }
    }

    CGRect rect = CGRectMake(x, y, width, height);
    
    CGContextSetFillColorWithColor(context, self.color);
    CGContextFillRect(context, rect);
}

@end
