//
//  UINavigationController+SGProgress.h
//  Voice
//
//  Created by Shalin Shah on 7/29/15.
//  Copyright (c) 2015 Shalin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSGProgressTitleChanged @"kSGProgressTitleChanged"
#define kSGProgressOldTitle @"kSGProgressOldTitle"

@interface UINavigationController (SGProgress)

- (void)showSGProgress;
- (void)showSGProgressWithDuration:(float)duration;
- (void)showSGProgressWithDuration:(float)duration andTintColor:(UIColor *)tintColor;
- (void)showSGProgressWithDuration:(float)duration andTintColor:(UIColor *)tintColor andTitle:(NSString *)title;
- (void)showSGProgressWithMaskAndDuration:(float)duration;
- (void)showSGProgressWithMaskAndDuration:(float)duration andTitle:(NSString *)title;

- (void)finishSGProgress;
- (void)cancelSGProgress;

- (void)setSGProgressPercentage:(float)percentage;
- (void)setSGProgressPercentage:(float)percentage andTitle:(NSString *)title;
- (void)setSGProgressPercentage:(float)percentage andTintColor:(UIColor *)tintColor;
- (void)setSGProgressMaskWithPercentage:(float)percentage;
- (void)setSGProgressMaskWithPercentage:(float)percentage andTitle:(NSString *)title;

@end