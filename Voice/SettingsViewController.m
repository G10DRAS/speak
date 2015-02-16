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
@synthesize ttsSpeed, autoSwitch;

- (void)viewDidLoad {
    
    // Nav Bar UI Stuff
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:26.0f];;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Settings", @"");
    [label sizeToFit];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"speedForTTS"] == nil) {
                [ttsSpeed setSelectedSegmentIndex:1];
    } else if ([[NSUserDefaults standardUserDefaults] floatForKey:@"speedForTTS"] == 0.2f) {
                [ttsSpeed setSelectedSegmentIndex:0];
    }  else if ([[NSUserDefaults standardUserDefaults] floatForKey:@"speedForTTS"] == 0.1f) {
                [ttsSpeed setSelectedSegmentIndex:1];
    } else if ([[NSUserDefaults standardUserDefaults] floatForKey:@"speedForTTS"] == 0.05f) {
                [ttsSpeed setSelectedSegmentIndex:2];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsAuto"] == FALSE) {
        [autoSwitch setOn:NO animated:YES];
    } else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsAuto"] == TRUE) {
        [autoSwitch setOn:YES animated:YES];
    }

    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

-(void)viewDidAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    UIImage *image = [UIImage imageNamed:@"background"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (IBAction)toggled:(id)sender {
    if (autoSwitch.on) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsAuto"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsAuto"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int intro = 0;
    int rate = 1;
    int share = 2;
    int feedback = 0;
    
    NSLog(@"Row: %i", (int)indexPath.row);
    NSLog(@"Section: %i", (int)indexPath.section);

    if(indexPath.section == 2) {
        if (intro == indexPath.row) {
            UIViewController *myNext = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialView"];
            [self.navigationController pushViewController:myNext animated:YES];
        } else if (rate == indexPath.row) {
            NSURL *url = [[NSURL alloc] initWithString:@"itms://itunes.apple.com/us/app/voice-take-picture-have-it/id903772588?mt=8&uo=4"];
            [[UIApplication sharedApplication] openURL:url];
        } else if (share == indexPath.row) {
            NSString *textToShare = @"Check out Voice - An iOS app that lets you take a picture of anything and reads it to you in a matter of seconds! http://shalinshah.me/voice";
//            UIImage *imageToShare = [UIImage imageNamed:@"yourImage.png"];
            NSArray *itemsToShare = @[textToShare];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
            activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
            [self presentViewController:activityVC animated:YES completion:nil];
        }
        
    } else if (indexPath.section == 3){
        if (feedback == indexPath.row) {
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            NSArray *toRecipients = [NSArray arrayWithObjects:@"shalinvs@gmail.com", @"getvoiceios@gmail.com", nil];
            [controller setToRecipients:toRecipients];
            [controller setTitle:@"Give Feedback"];
            [controller setSubject:@"Feedback About Voice"];
            [controller setMessageBody:@"This is my feedback about Voice:" isHTML:NO];
            
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
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
