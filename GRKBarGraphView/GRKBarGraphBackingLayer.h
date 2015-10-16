//
//  GRKBackingLayer.h
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

#import <QuartzCore/QuartzCore.h>

@interface GRKBarGraphBackingLayer : CALayer

/**
 *  The color used to draw the border.
 */
@property (nonatomic) CGColorRef color;
/**
 *  The thickness of the border to draw.
 *  This defaults to 1.0.
 */
@property (nonatomic) CGFloat borderThickness;

@end
