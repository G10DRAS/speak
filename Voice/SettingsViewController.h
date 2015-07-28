//
//  SettingsViewController.h
//  Voice
//
//  Created by Shalin Shah on 11/24/14.
//  Copyright (c) 2014 Shalin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Mixpanel.h"

@interface SettingsViewController : UITableViewController <MFMailComposeViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
    Mixpanel *mixpanel;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *ttsSpeed;
- (IBAction)indexChanged:(UISegmentedControl *)sender;

@property (weak, nonatomic) IBOutlet UISwitch *autoSwitch;
- (IBAction)toggled:(UISwitch *)sender;


@end
