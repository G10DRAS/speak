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
#import <AVFoundation/AVAudioPlayer.h>

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface SpeakViewController : UIViewController <AVAudioPlayerDelegate> {
    NSMutableArray *lines;
    NSString *reformattedString;
    AVAudioPlayer *_googlePlayer;
    SystemSoundID soundID;
    NSURL *url2;
    NSMutableArray *URLArray;
    BOOL soundIsPlaying;
    NSMutableArray *result;
    int playerInt;
    AVAudioPlayer *player;
}

@property (strong, nonatomic) NSString *text;

@property (nonatomic, strong) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UITextView *speakText;

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;

@end
