//
//  TalkViewController.h
//  Voice
//
//  Created by Shalin Shah on 7/26/14.
//  Copyright (c) 2014 Shalin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

@interface TalkViewController : UIViewController {
    BOOL speechPaused;
    BOOL alreadyStartedTalking;
    NSMutableArray *imageArray;
    NSMutableArray *speakArray;
    NSString *imagePath;
    NSMutableData *receivedData;
    NSString *imageFileID;
    NSDictionary *plainTextURL;
    NSString *theToken;
    int imageNumber;

}

@property (strong, nonatomic) NSString *text;
- (IBAction)moveToMain:(id)sender;

- (IBAction)playButtonPressed:(id)sender;
- (IBAction)pauseButtonPressed:(id)sender;
//- (IBAction)restart:(id)sender;

@end
