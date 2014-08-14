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

static NSString* hardCodedToken;
static NSString* theOCRText;

#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

@class TalkViewController;

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ELCImagePickerControllerDelegate> {
    NSMutableData *receivedData;
    BOOL isAuthenticating;
    NSString *imagePath;
    NSString *imageFileID;
    UIAlertView *loading;
    NSDictionary *plainTextURL;
    NSArray *_pickerData;
    UITapGestureRecognizer *singleTap;
    NSString *pickerRowName;
}

+ (NSString*)globalText;

@property (nonatomic, copy) NSArray *chosenImages;

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIAlertView *alertView;

- (IBAction)helpPressed:(id)sender;
@property (nonatomic, strong) TalkViewController *talkView;

- (IBAction)takePhoto:(id)sender;
- (IBAction)recognizePhoto:(id)sender;


@end
