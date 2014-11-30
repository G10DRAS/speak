//
//  ViewController.h
//  Voice
//
//  Created by Shalin Shah on 7/26/14.
//  Copyright (c) 2014 Shalin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkViewController.h"
#import "TutorialViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ELCImagePickerHeader.h"
#import "Mixpanel.h"
#import <AVFoundation/AVFoundation.h>


static NSString* hardCodedToken;
static NSString* theOCRText;

#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

@class TalkViewController;

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ELCImagePickerControllerDelegate> {
    NSMutableData *receivedData;
    BOOL isAuthenticating;
    NSString *imagePath;
    NSString *imagePathSize;
    NSString *imageFileID;
    UIAlertView *loading;
    NSDictionary *plainTextURL;
    NSArray *_pickerData;
    NSArray *_languagePickerData;
    NSString *pickerRowName;
    Mixpanel *mixpanel;
    NSString *time;
    UIToolbar *toolBar;
    
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
}

+ (NSString*)globalToken;

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UIPickerView *languagePicker;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIAlertView *alertView;

- (IBAction)helpPressed:(id)sender;
- (IBAction)languageSelection:(id)sender;
//- (IBAction)settingsSelected:(id)sender;


@property (nonatomic, strong) TalkViewController *talkView;

- (IBAction)takePhoto:(id)sender;

@end
