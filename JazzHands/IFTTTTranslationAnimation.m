//
//  IFTTTTranslationAnimation.m
//  JazzHands
//
//  Created by Laura Skelton on 6/17/15.
//  Copyright (c) 2015 IFTTT Inc. All rights reserved.
//

#import "IFTTTTranslationAnimation.h"
#import "UIView+IFTTTJazzHands.h"

@interface IFTTTTranslationAnimation ()
@property (assign) CGPoint previousTranslationPoint;
@property (assign) CGPoint startingCenterPoint;
@end

@implementation IFTTTTranslationAnimation

+ (instancetype)animationWithView:(UIView *)view
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        return [[self alloc] initWithView:view];
    }
    else {
        return [[IFTTTBasicTranslationAnimation alloc] initWithView:view];
    }
}

- (void)addKeyframeForTime:(CGFloat)time translation:(CGPoint)translation
{
    [self addKeyframeForTime:time value:[NSValue valueWithCGPoint:translation]];
}

- (void)addKeyframeForTime:(CGFloat)time translation:(CGPoint)translation withEasingFunction:(IFTTTEasingFunction)easingFunction
{
    [self addKeyframeForTime:time value:[NSValue valueWithCGPoint:translation] withEasingFunction:easingFunction];
}

- (void)animate:(CGFloat)time
{
    if (!self.hasKeyframes) return;
    if (self.view.alpha == 0) return;
    
    CGPoint translation = (CGPoint)[(NSValue *)[self valueAtTime:time] CGPointValue];
    if (translation.x == 0 && translation.y == 0 || CGPointEqualToPoint(self.previousTranslationPoint, translation)) return;
    self.previousTranslationPoint = translation;

    CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(translation.x, translation.y);
    self.view.iftttTranslationTransform = [NSValue valueWithCGAffineTransform:translationTransform];
    CGAffineTransform newTransform = translationTransform;
    if (self.view.iftttRotationTransform) {
        newTransform = CGAffineTransformConcat(newTransform, [self.view.iftttRotationTransform CGAffineTransformValue]);
    }
    if (self.view.iftttScaleTransform) {
        newTransform = CGAffineTransformConcat(newTransform, [self.view.iftttScaleTransform CGAffineTransformValue]);
    }
    self.view.transform = newTransform;
}

@end

@implementation IFTTTBasicTranslationAnimation

- (void)animate:(CGFloat)time
{
    if (!self.hasKeyframes) return;
    if (self.view.alpha == 0) return;
    
    CGPoint translation = (CGPoint)[(NSValue *)[self valueAtTime:time] CGPointValue];
    if (translation.x == 0 && translation.y == 0 || CGPointEqualToPoint(self.previousTranslationPoint, translation)) return;
    self.previousTranslationPoint = translation;
    
    if (CGPointEqualToPoint(self.startingCenterPoint, CGPointZero)) {
        self.startingCenterPoint = self.view.center;
    }
    self.view.center = CGPointMake(self.startingCenterPoint.x + translation.x, self.startingCenterPoint.y + translation.y);
}

@end
