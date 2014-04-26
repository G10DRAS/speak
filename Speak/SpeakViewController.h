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
#import "Google_TTS_BySham.h"

#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>

@interface SpeakViewController : UIViewController <AVAudioPlayerDelegate> {
    FliteController *fliteController;
    Slt *slt;
}

@property (strong, nonatomic) NSString *text;

@property (nonatomic,strong)Google_TTS_BySham *google_TTS_BySham;

@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;

@end
