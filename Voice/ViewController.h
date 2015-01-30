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
#import "ELCImagePickerHeader.h"

#import "DLFPhotosPickerViewController.h"
#import "DLFPhotoCell.h"

#import "Mixpanel.h"
#import "IPDFCameraViewController.h"
#import <AVFoundation/AVFoundation.h>



static NSString* hardCodedToken;
static NSString* theOCRText;

#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

@class TalkViewController;

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ELCImagePickerControllerDelegate, DLFPhotosPickerViewControllerDelegate> {
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
    NSMutableArray *tempImages;
    
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
}

+ (NSString*)globalToken;

//@property (strong, nonatomic) IBOutlet UIPickerView *picker;
//@property (strong, nonatomic) IBOutlet UIPickerView *languagePicker;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIButton *imageLibrary;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
- (IBAction)imageLibraryClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;
- (IBAction)clearButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *imageNumber;
@property (weak, nonatomic) IBOutlet UIImageView *focusIndication;
- (IBAction)focusRecognized:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *manual;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;
- (IBAction)captureClicked:(id)sender;
- (IBAction)manualSelected:(id)sender;
- (IBAction)cropToggle:(id)sender;
- (IBAction)switchFilters:(id)sender;

@property (weak, nonatomic) IBOutlet IPDFCameraViewController *camView;

@property (strong, nonatomic) UIAlertView *alertView;

//- (IBAction)helpPressed:(id)sender;
//- (IBAction)languageSelection:(id)sender;
//- (IBAction)settingsSelected:(id)sender;


@property (nonatomic, strong) TalkViewController *talkView;

//- (IBAction)takePhoto:(id)sender;

@end
