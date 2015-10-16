//
//  GRKBackingLayer.m
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

#import "GRKBarGraphBackingLayer.h"
#import "GRKBarGraphLayer.h"

static CGFloat const kDefaultBorderThickness = 1.0f;

@implementation GRKBarGraphBackingLayer

@dynamic color, borderThickness;

#pragma mark - Class Level

+ (NSSet *)displayKeys
{
    static NSSet *keys = nil;
    if (!keys)
    {
        keys = [NSSet setWithObjects:@"color", @"borderThickness", @"bounds", nil];
    }
    
    return keys;
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([[self displayKeys] containsObject:key])
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
        
        //Copy custom property values into our new instance from the given layer
        GRKBarGraphBackingLayer *baseLayer = (GRKBarGraphBackingLayer *)layer;
        self.color = baseLayer.color;
        self.borderThickness = baseLayer.borderThickness;
    }
    return self;
}

- (void)setup
{
    self.borderThickness = kDefaultBorderThickness;
    self.backgroundColor = [[UIColor clearColor] CGColor];
}

#pragma mark - Layout

- (void)layoutSublayers
{
    [super layoutSublayers];
    
    //We want our graph layer to have our bounds, inset by our border thickness
    CGRect subLayerRect = CGRectInset(self.bounds, self.borderThickness, self.borderThickness);
    for (CALayer *sublayer in self.sublayers)
    {
        if ([sublayer isKindOfClass:GRKBarGraphLayer.class])
        {
            sublayer.frame = subLayerRect;
            break;
        }
    }
}

#pragma mark - Drawing

- (void)drawInContext:(CGContextRef)context
{
    CGFloat halfLineWidth = self.borderThickness / 2.0f;
    //Inset the rect so the rect we draw will be inside our bounds
    CGRect rect = CGRectInset(self.bounds, halfLineWidth, halfLineWidth);

    CGContextSetLineWidth(context, self.borderThickness);
    CGContextSetStrokeColorWithColor(context, self.color);
    CGContextStrokeRect(context, rect);
}

@end
