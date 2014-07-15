//
//  SpeakViewController.h
//  OCRSDKDemo
//
//  Created by Shalin Shah on 4/21/14.
//  Copyright (c) 2014 ABBYY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"

@class ViewController;

@interface SpeakViewController : UIViewController {
    NSMutableArray *lines;
    NSString *reformattedString;
    SystemSoundID soundID;
    NSURL *url2;
    NSMutableArray *URLArray;
    BOOL soundIsPlaying;
    NSMutableArray *result;
    int playerInt;
    float volumeLevel;
}

@property (strong, nonatomic) NSString *text;
@property (nonatomic, strong) ViewController *mainView;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;
//-(IBAction)sliderValueChanged:(UISlider *)slider;

- (IBAction)stopSpeech:(id)sender;
- (IBAction)startSpeech:(id)sender;

- (IBAction)speakClosed:(id)sender;

@end
