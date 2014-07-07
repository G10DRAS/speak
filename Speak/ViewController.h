//
//  ViewController.h
//  OCRSDKDemo
//
//  Created by Shalin Shah on 5/2/14.
//  Copyright (c) 2014 ABBYY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tesseract.h"
#import "SpeakViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)
@class SpeakViewController;

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate> {
    Tesseract* tesseract;
    UIAlertView *alert;
}


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIAlertView *alertView;

@property (nonatomic, strong) SpeakViewController *textViewController;

- (IBAction)takePhoto:(id)sender;
- (IBAction)recognizePhoto:(id)sender;


@end
