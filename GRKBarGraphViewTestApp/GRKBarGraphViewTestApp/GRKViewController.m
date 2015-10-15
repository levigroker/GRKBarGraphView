//
//  GRKViewController.m
//  GRKBarGraphViewTestApp
//
//  Created by Levi Brown on 7/11/14.
//  Copyright (c) 2014 Levi Brown. All rights reserved.
//

#import "GRKViewController.h"
#import "GRKBarGraphView.h"

@interface GRKViewController ()

@property (nonatomic,strong) GRKBarGraphView *barGraphView;

@property (nonatomic,weak) IBOutlet UISlider *widthSlider;
@property (nonatomic,weak) IBOutlet UISlider *heightSlider;
@property (nonatomic,weak) IBOutlet UISlider *percentSlider;
@property (nonatomic,weak) IBOutlet UISwitch *animateSwitch;
@property (nonatomic,weak) IBOutlet UISwitch *tintColorSwitch;
@property (nonatomic,weak) IBOutlet UILabel *percentLabel;
@property (nonatomic,weak) IBOutlet UILabel *dimensionsLabel;
@property (nonatomic,weak) IBOutlet UIButton *fromLeftButton;
@property (nonatomic,weak) IBOutlet UIButton *fromRightButton;
@property (nonatomic,weak) IBOutlet UIButton *fromTopButton;
@property (nonatomic,weak) IBOutlet UIButton *fromBottomButton;
@property (nonatomic,weak) IBOutlet UIButton *defaultColorButton;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *widthConstraint;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *heightConstraint;

@property (nonatomic,weak) IBOutlet UIView *backgroundView;

@property (nonatomic,strong) UIView *tintColorSelectionView;
@property (nonatomic,strong) UIView *fillColorSelectionView;

- (IBAction)widthSliderValueChanged:(UISlider *)sender;
- (IBAction)heightSliderValueChanged:(UISlider *)sender;
- (IBAction)percentSliderValueChanged:(UISlider *)sender;
- (IBAction)animateSwitchValueChanged:(UISwitch *)sender;
- (IBAction)useTinitColorSwitchValueChanged:(UISwitch *)sender;
- (IBAction)tintColorAction:(UIButton *)sender;
- (IBAction)fillColorAction:(UIButton *)sender;

@end

@implementation GRKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.barGraphView = [[GRKBarGraphView alloc] initWithFrame:CGRectZero];
    [self.backgroundView addSubview:self.barGraphView];
    
    self.widthConstraint = [NSLayoutConstraint constraintWithItem:self.barGraphView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200.0f];
    [self.barGraphView addConstraint:self.widthConstraint];
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.barGraphView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200.0f];
    [self.barGraphView addConstraint:self.heightConstraint];
    
    [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.barGraphView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0f]];
    [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.barGraphView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0f]];

    
    UISlider *heightSlider = self.heightSlider;
    [heightSlider removeFromSuperview];
    [heightSlider removeConstraints:self.view.constraints];
    heightSlider.translatesAutoresizingMaskIntoConstraints = YES;
    heightSlider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self.view addSubview:heightSlider];
    [self colorAction:YES sender:self.defaultColorButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.barGraphView.percent = self.percentSlider.value;
    self.percentSlider.continuous = !self.animateSwitch.on;
    [self updatePercentLabel];
    [self widthSliderValueChanged:self.widthSlider];
    [self heightSliderValueChanged:self.heightSlider];
    [self selectBarStyle:GRKBarStyleFromLeft];
}

#pragma mark - Actions

- (IBAction)widthSliderValueChanged:(UISlider *)sender
{
    CGFloat value = roundf(sender.value);
    self.widthConstraint.constant = value;
    [self updateViewConstraints];
    [self updateDimensionsLabel];
}

- (IBAction)heightSliderValueChanged:(UISlider *)sender
{
    CGFloat value = roundf(sender.value);
    self.heightConstraint.constant = value;
    [self updateViewConstraints];
    [self updateDimensionsLabel];
}

- (IBAction)percentSliderValueChanged:(UISlider *)sender
{
    NSTimeInterval duration = self.animateSwitch.on ? 0.5f : 0.0f;
    
    self.barGraphView.animationDuration = duration;
    self.barGraphView.percent = sender.value;
    [self updatePercentLabel];
}

- (IBAction)animateSwitchValueChanged:(UISwitch *)sender
{
    self.percentSlider.continuous = !sender.on;
}

- (IBAction)useTinitColorSwitchValueChanged:(UISwitch *)sender
{
    if (sender.on)
    {
        [self.fillColorSelectionView removeFromSuperview];
        self.fillColorSelectionView = nil;
    }

    self.barGraphView.barColorUsesTintColor = sender.on;
}

- (IBAction)tintColorAction:(UIButton *)sender
{
    [self colorAction:YES sender:sender];
}

- (IBAction)fillColorAction:(UIButton *)sender
{
    [self colorAction:NO sender:sender];
}

- (void)colorAction:(BOOL)tint sender:(UIButton *)sender
{
    UIView *view = tint ? self.tintColorSelectionView : self.fillColorSelectionView;
    UIColor *color = sender.tag == 1 ? [UIColor clearColor] : sender.backgroundColor;
    
    [view removeFromSuperview];
    view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:view belowSubview:sender];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeHeight multiplier:1.0f constant:2.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeWidth multiplier:1.0f constant:2.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    UIView *subview = [[UIView alloc] init];
    subview.backgroundColor = self.view.backgroundColor;
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:subview];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[subview]-1-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(subview)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[subview]-1-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(subview)]];

    if (tint)
    {
        self.tintColorSelectionView = view;
        self.barGraphView.tintColor = color;
        if (self.barGraphView.barColorUsesTintColor)
        {
            [self.fillColorSelectionView removeFromSuperview];
            self.fillColorSelectionView = nil;
        }
    }
    else
    {
        self.fillColorSelectionView = view;
        self.barGraphView.barColor = color;
        [self.tintColorSwitch setOn:NO animated:YES];
        [self useTinitColorSwitchValueChanged:self.tintColorSwitch];
    }
}

- (IBAction)styleAction:(UIButton *)sender
{
    [self selectBarStyle:sender.tag];
}

#pragma mark - Helpers

- (void)updatePercentLabel
{
    self.percentLabel.text = [NSString stringWithFormat:@"%.1f%%", self.percentSlider.value * 100.0f];
}

- (void)updateDimensionsLabel
{
    self.dimensionsLabel.text = [NSString stringWithFormat:@"%.1f x %.1f", self.widthConstraint.constant, self.heightConstraint.constant];
}

- (void)selectBarStyle:(GRKBarStyle)barStyle
{
    self.barGraphView.barStyle = barStyle;
    UIColor *selectedColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    self.fromLeftButton.backgroundColor = self.fromLeftButton.tag == barStyle ? selectedColor : nil;
    self.fromRightButton.backgroundColor = self.fromRightButton.tag == barStyle ? selectedColor : nil;
    self.fromTopButton.backgroundColor = self.fromTopButton.tag == barStyle ? selectedColor : nil;
    self.fromBottomButton.backgroundColor = self.fromBottomButton.tag == barStyle ? selectedColor : nil;
}

@end
