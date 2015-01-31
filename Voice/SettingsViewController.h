//
//  SettingsViewController.h
//  Voice
//
//  Created by Shalin Shah on 11/24/14.
//  Copyright (c) 2014 Shalin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController {
    
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *ttsSpeed;
- (IBAction)indexChanged:(UISegmentedControl *)sender;

@end
