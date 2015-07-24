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

    // Screen Dimensions
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
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
    
//        languagePickerData = @[@"Arabic (Saudi Arabia)", @"Chinese (China)", @"Chinese (Hong Kong)", @"Chinese (Taiwan)", @"Czech (Czech Republic)", @"Danish (Denmark)", @"Dutch (Belgium)", @"Dutch (Netherlands)", @"English (Australia)", @"English (Ireland)", @"English (South Africa)", @"English (UK)", @"English (USA)", @"Finnish (Finland)", @"French (Canada)", @"French (France)", @"German (Germany)", @"Greek (Greece)", @"Hindi (India)", @"Hungarian (Hungary)", @"Indonesian (Indonesia)", @"Italian (Italy)", @"Japanese (Japan)", @"Korean (South Korea)", @"Norwegian (Norway)", @"Polish (Poland)", @"Portuguese (Brazil)", @"Portuguese (Portugal)", @"Romanian (Romania)", @"Russian (Russia)", @"Slovak (Slovakia)", @"Spanish (Mexico)", @"Spanish (Spain)", @"Swedish (Sweden)", @"Thai (Thailand)", @"Turkish (Turkey)"];
//        self.languagePicker.dataSource = self;
//        self.languagePicker.delegate = self;

    
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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    UIImage *image = [UIImage imageNamed:@"background"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

/*---------------------------------
 SELECT THE OCR LANGUAGE
 ------------------------------- */

//- (IBAction)languageSelection:(id)sender {
//    [UIView transitionWithView:self.languagePicker
//                      duration:0.4
//                       options:UIViewAnimationOptionTransitionCrossDissolve
//                    animations:NULL
//                    completion:NULL];
//    
//    self.languagePicker.hidden = NO;
//    
//    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.languagePicker.frame.origin.y-10, screenWidth, 44)];
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(whichLanguage:)]; // UIBarButtonItemStyleBordered
//    doneButton.tintColor=[UIColor darkGrayColor];
//    [toolBar setItems:[NSArray arrayWithObjects:doneButton, nil]];
//    
//    [self.view addSubview:toolBar];
//    
//}

//- (void) whichLanguage:(id)sender {
////    [toolBar removeFromSuperview];
//    self.languagePicker.hidden = YES;
//    [self.languagePicker resignFirstResponder];
//    
//    NSString *languageForOCR;
//    NSString *languageForTTS;
//    
//    if ([pickerRowName isEqualToString:@"Arabic (Saudi Arabia)"]) {
//        languageForOCR = @"ar";
//        languageForTTS = @"ar-SA";
//    } else if ([pickerRowName isEqualToString:@"Chinese (China)"]) {
//        languageForOCR = @"zh";
//        languageForTTS = @"zh-CN";
//    } else if ([pickerRowName isEqualToString:@"Chinese (Hong Kong)"]) {
//        languageForOCR = @"zh";
//        languageForTTS = @"zh-HK";
//    } else if ([pickerRowName isEqualToString:@"Chinese (Taiwan)"]) {
//        languageForOCR = @"zh";
//        languageForTTS = @"zh-TW";
//    } else if ([pickerRowName isEqualToString:@"Czech (Czech Republic)"]) {
//        languageForOCR = @"cs";
//        languageForTTS = @"cs-CZ";
//    } else if ([pickerRowName isEqualToString:@"Danish (Denmark)"]) {
//        languageForOCR = @"da";
//        languageForTTS = @"da-DK";
//    } else if ([pickerRowName isEqualToString:@"Dutch (Belgium)"]) {
//        languageForOCR = @"nl";
//        languageForTTS = @"nl-BE";
//    } else if ([pickerRowName isEqualToString:@"Dutch (Netherlands)"]) {
//        languageForOCR = @"nl";
//        languageForTTS = @"nl-NL";
//    } else if ([pickerRowName isEqualToString:@"English (Australia)"]) {
//        languageForOCR = @"en";
//        languageForTTS = @"en-AU";
//    } else if ([pickerRowName isEqualToString:@"English (Ireland)"]) {
//        languageForOCR = @"en";
//        languageForTTS = @"en-IE";
//    } else if ([pickerRowName isEqualToString:@"English (South Africa)"]) {
//        languageForOCR = @"en";
//        languageForTTS = @"en-ZA";
//    } else if ([pickerRowName isEqualToString:@"English (UK)"]) {
//        languageForOCR = @"en";
//        languageForTTS = @"en-GB";
//    } else if ([pickerRowName isEqualToString:@"English (USA)"]) {
//        languageForOCR = @"en";
//        languageForTTS = @"en-US";
//    } else if ([pickerRowName isEqualToString:@"Finnish (Finland)"]) {
//        languageForOCR = @"fi";
//        languageForTTS = @"fi-FI";
//    } else if ([pickerRowName isEqualToString:@"French (Canada)"]) {
//        languageForOCR = @"fr";
//        languageForTTS = @"fr-CA";
//    } else if ([pickerRowName isEqualToString:@"French (France)"]) {
//        languageForOCR = @"fr";
//        languageForTTS = @"fr-FR";
//    } else if ([pickerRowName isEqualToString:@"German (Germany)"]) {
//        languageForOCR = @"de";
//        languageForTTS = @"de-DE";
//    } else if ([pickerRowName isEqualToString:@"Greek (Greece)"]) {
//        languageForOCR = @"el";
//        languageForTTS = @"el-GR";
//    } else if ([pickerRowName isEqualToString:@"Hindi (India)"]) {
//        languageForOCR = @"hi";
//        languageForTTS = @"hi-IN";
//    } else if ([pickerRowName isEqualToString:@"Hungarian (Hungary)"]) {
//        languageForOCR = @"hu";
//        languageForTTS = @"hu-HU";
//    } else if ([pickerRowName isEqualToString:@"Indonesian (Indonesia)"]) {
//        languageForOCR = @"id";
//        languageForTTS = @"id-ID";
//    } else if ([pickerRowName isEqualToString:@"Italian (Italy)"]) {
//        languageForOCR = @"it";
//        languageForTTS = @"it-IT";
//    } else if ([pickerRowName isEqualToString:@"Japanese (Japan)"]) {
//        languageForOCR = @"ja";
//        languageForTTS = @"ja-JP";
//    } else if ([pickerRowName isEqualToString:@"Korean (South Korea)"]) {
//        languageForOCR = @"ko";
//        languageForTTS = @"ko-KR";
//    } else if ([pickerRowName isEqualToString:@"Norwegian (Norway)"]) {
//        languageForOCR = @"no";
//        languageForTTS = @"no-NO";
//    } else if ([pickerRowName isEqualToString:@"Polish (Poland)"]) {
//        languageForOCR = @"pl";
//        languageForTTS = @"pl-PL";
//    } else if ([pickerRowName isEqualToString:@"Portuguese (Brazil)"]) {
//        languageForOCR = @"pt";
//        languageForTTS = @"pt-BR";
//    } else if ([pickerRowName isEqualToString:@"Portuguese (Portugal)"]) {
//        languageForOCR = @"pt";
//        languageForTTS = @"pt-PT";
//    } else if ([pickerRowName isEqualToString:@"Romanian (Romania)"]) {
//        languageForOCR = @"ro";
//        languageForTTS = @"ro-RO";
//    } else if ([pickerRowName isEqualToString:@"Russian (Russia)"]) {
//        languageForOCR = @"ru";
//        languageForTTS = @"ru-RU";
//    } else if ([pickerRowName isEqualToString:@"Slovak (Slovakia)"]) {
//        languageForOCR = @"sk";
//        languageForTTS = @"sk-SK";
//    } else if ([pickerRowName isEqualToString:@"Spanish (Mexico)"]) {
//        languageForOCR = @"es";
//        languageForTTS = @"es-MX";
//    } else if ([pickerRowName isEqualToString:@"Spanish (Spain)"]) {
//        languageForOCR = @"es";
//        languageForTTS = @"es-ES";
//    } else if ([pickerRowName isEqualToString:@"Swedish (Sweden)"]) {
//        languageForOCR = @"sv";
//        languageForTTS = @"sv-SE";
//    } else if ([pickerRowName isEqualToString:@"Thai (Thailand)"]) {
//        languageForOCR = @"th";
//        languageForTTS = @"th-TH";
//    } else if ([pickerRowName isEqualToString:@"Turkish (Turkey)"]) {
//        languageForOCR = @"tr";
//        languageForTTS = @"tr-TR";
//    } else {
//        languageForOCR = @"en";
//        languageForTTS = @"en-US";
//    }
//    NSLog(@"%@", languageForOCR);
//    NSLog(@"%@", languageForTTS);
//    [[NSUserDefaults standardUserDefaults] setObject:languageForTTS forKey:@"languageForTTS"];
//    [[NSUserDefaults standardUserDefaults] setObject:languageForOCR forKey:@"languageForOCR"];
//}

//
//
// The Language Picker Delegate Methods
//
//

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return languagePickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return languagePickerData[row];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSAttributedString *attString;
    
        attString = [[NSAttributedString alloc] initWithString:[languagePickerData objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    
    return attString;
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    pickerRowName = [NSString stringWithFormat:@"%@", [languagePickerData objectAtIndex:row]];
    NSLog(@"What was picked: %@", pickerRowName);
}

-(void)viewDidAppear:(BOOL)animated {
    
}

- (IBAction)toggled:(id)sender {
    if (autoSwitch.on) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsAuto"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsAuto"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    switch (indexPath.row){
//        case 0:
//            if(indexPath.section == 2)
//                return 500.0; // first row is 123pt high
//        default:
//            return 40.0; // all other rows are 40pt high
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int intro = 0;
    int rate = 1;
    int share = 2;
    int feedback = 0;
    
    
    NSLog(@"Row: %i", (int)indexPath.row);
    NSLog(@"Section: %i", (int)indexPath.section);

    if(indexPath.section == 2) {
        if (indexPath.row == 0) {
            
        }
    }
    
    if(indexPath.section == 3) {
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

//- (IBAction)showLanguagePicker:(id)sender {
//    
//    [UIView transitionWithView:self.languagePicker
//                      duration:0.4
//                       options:UIViewAnimationOptionTransitionCrossDissolve
//                    animations:NULL
//                    completion:NULL];
//    
//    self.languagePicker.hidden = NO;
//    self.languagePickerButton.hidden = YES;
////    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.languagePicker.frame.origin.y-10, screenWidth, 44)];
////    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(whichLanguage:)]; // UIBarButtonItemStyleBordered
////    doneButton.tintColor=[UIColor darkGrayColor];
////    [toolBar setItems:[NSArray arrayWithObjects:doneButton, nil]];
////    
////    [self.view addSubview:toolBar];
//}

@end
