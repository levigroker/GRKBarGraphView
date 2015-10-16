//
//  GRKBarGraphView.h
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

#import <UIKit/UIKit.h>

/**
 *  Describes the various orientations of the graph.
 */
typedef NS_ENUM(NSUInteger, GRKBarStyle) {
    /**
     *  The graph will grow from the left to the right.
     *  This is the default.
     */
    GRKBarStyleFromLeft = 0,
    /**
     *  The graph will grow from the right to the left.
     */
    GRKBarStyleFromRight,
    /**
     *  The graph will grow from the top to the bottom.
     */
    GRKBarStyleFromTop,
    /**
     *  The graph will grow from the bottom to the top.
     */
    GRKBarStyleFromBottom
};

@interface GRKBarGraphView : UIView

/**
 *  The media timing function to use when animating.
 *  This defaults to the timing function specified by the `kCAMediaTimingFunctionEaseOut` name.
 *  To change, set this property to the result of the `functionWithName:` method on `CAMediaTimingFunction`, like:
 *  `[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]`
 */
@property (nonatomic,assign) CAMediaTimingFunction *mediaTimingFunction;
/**
 *  The time duration animations should use. If set to zero, no animation will take place when property values are set.
 *  The default is zero (no animations).
 */
@property (nonatomic,assign) NSTimeInterval animationDuration;
/**
 *  The percentage to display in the graph. This will be pinned to a minimum of 0.0 and a maximum of 1.0.
 */
@property (nonatomic,assign) CGFloat percent;
/**
 *  The color to use for the bar of the graph, if you wish to use a separate color than the tintColor.
 *  @see barColorUsesTintColor
 *  @see tintColor
 */
@property (nonatomic,strong) UIColor *barColor;
/**
 *  The display style of the graph.
 *  Defaults to `GRKBarStyleFromLeft`
 *  @see GRKBarStyle
 */
@property (nonatomic,assign) GRKBarStyle barStyle;
/**
 *  If `YES` then the `barColor` will be the same as the `tintColor` and changes to the `tintColor` will also change the `barColor`.
 *  If `NO` then changes to `tintColor` will not change the `barColor`.
 *  The default is `YES`
 *  @see barColor
 *  @see tintColor
 */
@property (nonatomic,assign) BOOL barColorUsesTintColor;

/**
 * Immediately stops any in-progress animation for the `percent` property.
 */
- (void)stopAnimation;

@end
