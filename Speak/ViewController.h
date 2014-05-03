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

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate> {
    Tesseract* tesseract;
}


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIAlertView *alertView;

@property (strong, nonatomic) SpeakViewController *textViewController;


- (IBAction)takePhoto:(id)sender;
- (IBAction)recognizePhoto:(id)sender;


@end
