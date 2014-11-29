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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)indexChanged:(UISegmentedControl *)sender {
    
    switch (self.ttsSpeed.selectedSegmentIndex)
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
        default:
            [[NSUserDefaults standardUserDefaults] setFloat:0.1f forKey:@"speedForTTS"];
            break;
    }
    
}
@end
