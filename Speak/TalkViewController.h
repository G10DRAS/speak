//
//  TalkViewController.h
//  Speak
//
//  Created by Shalin Shah on 7/26/14.
//  Copyright (c) 2014 ABBYY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TalkViewController : UIViewController <AVSpeechSynthesizerDelegate> {
    BOOL speechPaused;
}

@end
