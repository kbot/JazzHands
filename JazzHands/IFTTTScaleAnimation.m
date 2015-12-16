//
//  IFTTTScaleAnimation.m
//  JazzHands
//
//  Created by Steven Mok on 1/10/14.
//  Copyright (c) 2014 IFTTT Inc. All rights reserved.
//

#import "IFTTTScaleAnimation.h"
#import "UIView+IFTTTJazzHands.h"

@interface IFTTTScaleAnimation ()
@property (assign) CGFloat currentScale;
@property (assign) CGRect originalFrame;
@end

@implementation IFTTTScaleAnimation

+ (instancetype)animationWithView:(UIView *)view
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        return [[self alloc] initWithView:view];
    }
    else {
        return [[IFTTTBasicScaleAnimation alloc] initWithView:view];
    }
}

- (void)addKeyframeForTime:(CGFloat)time scale:(CGFloat)scale
{
    if (![self validScale:scale]) return;
    [self addKeyframeForTime:time value:@(scale)];
}

- (void)addKeyframeForTime:(CGFloat)time scale:(CGFloat)scale withEasingFunction:(IFTTTEasingFunction)easingFunction
{
    if (![self validScale:scale]) return;
    [self addKeyframeForTime:time value:@(scale) withEasingFunction:easingFunction];
}

- (BOOL)validScale:(CGFloat)scale
{
    NSAssert((scale > 0), @"Scale must be greater than zero.");
    if (!(scale > 0)) return NO;
    return YES;
}

- (void)animate:(CGFloat)time
{
    if (!self.hasKeyframes) return;
    if (self.view.alpha == 0) return;
    
    CGFloat scale = (CGFloat)[(NSNumber *)[self valueAtTime:time] floatValue];
    if (self.currentScale == scale) return;
    self.currentScale = scale;
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
    self.view.iftttScaleTransform = [NSValue valueWithCGAffineTransform:scaleTransform];
    CGAffineTransform newTransform = scaleTransform;
    if (self.view.iftttRotationTransform) {
        newTransform = CGAffineTransformConcat(newTransform, [self.view.iftttRotationTransform CGAffineTransformValue]);
    }
    if (self.view.iftttTranslationTransform) {
        newTransform = CGAffineTransformConcat(newTransform, [self.view.iftttTranslationTransform CGAffineTransformValue]);
    }
    self.view.transform = newTransform;
}

@end

@implementation IFTTTBasicScaleAnimation

- (void)animate:(CGFloat)time
{
    if (!self.hasKeyframes) return;
    if (self.view.alpha == 0) return;
    
    CGFloat scale = (CGFloat)[(NSNumber *)[self valueAtTime:time] floatValue];
    if (self.currentScale == scale) return;
    self.currentScale = scale;
    if (CGRectIsEmpty(self.originalFrame)) {
        self.originalFrame = self.view.frame;
    }
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
    self.view.frame = CGRectApplyAffineTransform(self.originalFrame, scaleTransform);
}


@end