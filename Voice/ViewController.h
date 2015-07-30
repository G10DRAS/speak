//
//  ViewController.h
//  Voice
//
//  Created by Shalin Shah on 7/26/14.
//  Copyright (c) 2014 Shalin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkViewController.h"
#import "SettingsViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>

#import "Mixpanel.h"
#import "Appirater.h"
#import "CVCameraViewController.h"
#import <AVFoundation/AVFoundation.h>


static NSString* hardCodedToken;
static NSString* theOCRText;

#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

@class TalkViewController;

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIAlertViewDelegate, CTAssetsPickerControllerDelegate> {
    NSMutableData *receivedData;
    BOOL isAuthenticating;
    BOOL switchToAuto;
    
    BOOL willSpeak;
    
    BOOL isImagePicker;
    
    BOOL filterType; // YES is B&W and NO is Regular
    
    // FOR SETTINGS BUTTON
    UIButton *rightButton;
    
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
    
    NSTimer *labelUpdaterTimer;
}

+ (NSString*)globalToken;

//@property (strong, nonatomic) IBOutlet UIPickerView *picker;
//@property (strong, nonatomic) IBOutlet UIPickerView *languagePicker;

@property (nonatomic, strong) PHImageRequestOptions *requestOptions;


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
@property (strong, nonatomic) IBOutlet UIButton *filterButton;

@property (weak, nonatomic) IBOutlet UIButton *manual;
@property (weak, nonatomic) IBOutlet UIButton *autoButton;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet UIButton *cropButton;
- (IBAction)captureClicked:(id)sender;


- (IBAction)cropToggle:(id)sender;
- (IBAction)switchFilters:(id)sender;

@property (weak, nonatomic) IBOutlet CVCameraViewController *camView;

@property (strong, nonatomic) UIAlertView *alertView;

@property (nonatomic, strong) TalkViewController *talkView;

@end
