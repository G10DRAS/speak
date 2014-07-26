//
//  SpeakViewController.h
//  OCRSDKDemo
//
//  Created by Shalin Shah on 4/21/14.
//  Copyright (c) 2014 ABBYY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

@interface SpeakViewController : UIViewController <AVSpeechSynthesizerDelegate> {
    float volumeLevel;
    BOOL speechPaused;
}

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;
//- (IBAction)sliderValueChanged:(UISlider *)sender;
//-(IBAction)sliderValueChanged:(UISlider *)slider;

- (IBAction)pauseSpeech:(id)sender;
- (IBAction)startSpeech:(id)sender;

- (IBAction)speakClosed:(id)sender;

@end
