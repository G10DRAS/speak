//
//  SettingsViewController.h
//  Voice
//
//  Created by Shalin Shah on 11/24/14.
//  Copyright (c) 2014 Shalin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SettingsViewController : UITableViewController <MFMailComposeViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *languagePickerData;
    UIToolbar *toolBar;
    
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    NSString *pickerRowName;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *ttsSpeed;
- (IBAction)indexChanged:(UISegmentedControl *)sender;
//- (IBAction)showLanguagePicker:(id)sender;
//@property (strong, nonatomic) IBOutlet UIButton *languagePickerButton;

@property (weak, nonatomic) IBOutlet UISwitch *autoSwitch;
- (IBAction)toggled:(UISwitch *)sender;

//@property (strong, nonatomic) IBOutlet UIPickerView *languagePicker;


@end
