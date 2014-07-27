//
//  TutorialViewController.h
//  Her
//
//  Created by Shalin Shah on 7/18/14.
//  Copyright (c) 2014 Shalin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "EAIntroView.h"

#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

@class ViewController;
@class AccountViewController;

@interface TutorialViewController : UIViewController <EAIntroDelegate> {
}

@property (nonatomic, strong) ViewController *mainView;
@property (nonatomic, strong) AccountViewController *accountView;

@end
