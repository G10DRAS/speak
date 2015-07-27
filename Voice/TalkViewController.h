//
//  TalkViewController.h
//  Voice
//
//  Created by Shalin Shah on 7/26/14.
//  Copyright (c) 2014 Shalin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <Mixpanel/Mixpanel.h>
#import "CVCameraViewController.h"

#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)
#define IMAGE_WIDTH 320
#define IMAGE_HEIGHT 360

static NSInteger const MaxSuggestions = 8;
static NSTimeInterval const AutoScrollDuration = 3.0f;


@interface TalkViewController : UIViewController <UIScrollViewDelegate, UIDocumentInteractionControllerDelegate> {
    BOOL speechPaused;
    BOOL alreadyStartedTalking;
    BOOL compressingImage;
    BOOL isSkipping;
    NSMutableArray *imageArray;
    NSMutableArray *speakArray;
    NSString *imagePath;
    NSMutableData *receivedData;
    NSString *imageFileID;
    NSString *compressedImageURL;
    NSDictionary *plainTextURL;
    NSString *theToken;
    int imageNumber;
    int speechNumber;
    NSData *compressedImageData;
    Mixpanel *mixpanel;
    float ttsSpeed;
    
    CGSize _pageSize;
    
    UIImage *imageToShare;
    NSString *stringToShare;
    
    BOOL didShareText;
    BOOL didShareImage;
    BOOL didSharePDF;
}
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;

@property (strong, nonatomic) UIDocumentInteractionController* docController;


@property (strong, nonatomic) NSString *text;

- (IBAction)playButtonPressed:(id)sender;
- (IBAction)pauseButtonPressed:(id)sender;
- (IBAction)restartButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)prevButtonPressed:(id)sender;
- (IBAction)shareButton:(id)sender;

@end
