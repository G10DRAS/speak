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
#import "Google_TTS_BySham.h"

#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>

@interface SpeakViewController : UIViewController <AVAudioPlayerDelegate> {
    FliteController *fliteController;
    Slt *slt;
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

@property (nonatomic,strong)Google_TTS_BySham *google_TTS_BySham;

@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;

@property (nonatomic, retain) AVAudioPlayer *player;

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;

@end
