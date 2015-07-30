//
//  SBProgressView.h
//  Voice
//
//  Created by Shalin Shah on 7/29/15.
//  Copyright (c) 2015 Shalin Shah. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SGProgressView : UIView

/**
 *  The current progress shown by the receiver.
 *  The progress value ranges from 0 to 1. The default value is 0.
 */
@property (nonatomic, assign) float progress;

@end