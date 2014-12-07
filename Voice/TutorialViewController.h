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
#import <Mixpanel/Mixpanel.h>

@class ViewController;
@class AccountViewController;

@interface TutorialViewController : UIViewController <EAIntroDelegate> {
    Mixpanel *mixpanel;
}

@property (nonatomic, strong) ViewController *mainView;
@property (nonatomic, strong) AccountViewController *accountView;

@end
