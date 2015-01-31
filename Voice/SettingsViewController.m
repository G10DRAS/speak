//
//  SettingsViewController.m
//  Voice
//
//  Created by Shalin Shah on 11/24/14.
//  Copyright (c) 2014 Shalin Shah. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize ttsSpeed;

- (void)viewDidLoad {
    
    // Nav Bar UI Stuff
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:26.0f];;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Voice - Settings", @"");
    [label sizeToFit];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    UIImage *image = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
        
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"speedForTTS"] == nil) {
                [ttsSpeed setSelectedSegmentIndex:1];
    } else if ([[NSUserDefaults standardUserDefaults] floatForKey:@"speedForTTS"] == 0.2f) {
                [ttsSpeed setSelectedSegmentIndex:0];
    }  else if ([[NSUserDefaults standardUserDefaults] floatForKey:@"speedForTTS"] == 0.1f) {
                [ttsSpeed setSelectedSegmentIndex:1];
    } else if ([[NSUserDefaults standardUserDefaults] floatForKey:@"speedForTTS"] == 0.05f) {
                [ttsSpeed setSelectedSegmentIndex:2];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)indexChanged:(UISegmentedControl *)sender {
    switch (ttsSpeed.selectedSegmentIndex)
    {
        case 0:
            [[NSUserDefaults standardUserDefaults] setFloat:0.2f forKey:@"speedForTTS"];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setFloat:0.1f forKey:@"speedForTTS"];
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setFloat:0.05f forKey:@"speedForTTS"];
            break;
    }
}
@end
