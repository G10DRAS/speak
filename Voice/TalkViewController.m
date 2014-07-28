//
//  TalkViewController.m
//  Voice
//
//  Created by Shalin Shah on 7/26/14.
//  Copyright (c) 2014 Shalin Shah. All rights reserved.
//

#import "TalkViewController.h"
@import AVFoundation;

@interface TalkViewController () <AVSpeechSynthesizerDelegate>
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@end

@implementation TalkViewController
@synthesize text = _text;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    if ([self canBecomeFirstResponder]) {
        [self becomeFirstResponder];
    }
    
    speechPaused = NO;
    
    self.view.backgroundColor = [UIColor clearColor];
    UIImage *myImage = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"player", @"player-568h")];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:myImage]];
    
    [self startTalking];
}

- (void) startTalking {
    speechPaused = NO;
    _text = [ViewController globalText];
    AVSpeechUtterance* utter = [[AVSpeechUtterance alloc] initWithString:_text];
    utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    [utter setRate:0.2f];
    if (!self.synthesizer) {
        self.synthesizer = [AVSpeechSynthesizer new];
    }
    self.synthesizer.delegate = self;
    [self.synthesizer speakUtterance:utter];
}

- (void) pauseSpeech {
    if (speechPaused == NO) {
        [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        NSLog(@"Paused");
        speechPaused = YES;
    }
    if (self.synthesizer.speaking == NO) {
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@""];
        [self.synthesizer speakUtterance:utterance];
    }
}
- (void) playSpeech {
    [self.synthesizer continueSpeaking];
    NSLog(@"Played");
    speechPaused = NO;
}
- (void) playPauseToggle {
    if (speechPaused == NO) {
        [self pauseSpeech];
    } else if (speechPaused == YES) {
        [self playSpeech];
    }
}
- (void) restartSpeech {
    [self pauseSpeech];
    [self startTalking];
//    dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
//    dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
//        [self startTalking];
//    });
}

- (void) stopSpeech {
    AVSpeechSynthesizer *talked = self.synthesizer;
    if([talked isSpeaking]) {
        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
//        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@""];
//        [talked speakUtterance:utterance];
//        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
    _text = nil;
}
-(void) moveToMainView {
    UIViewController *myNext = [self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    [self.navigationController pushViewController:myNext animated:YES];
}

- (IBAction)moveToMain:(id)sender {
    AVSpeechSynthesizer *talked = self.synthesizer;
    if([talked isSpeaking]) {
        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@""];
        [talked speakUtterance:utterance];
        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}

- (IBAction)playButtonPressed:(id)sender {
    [self playSpeech];
}

- (IBAction)pauseButtonPressed:(id)sender {
    [self pauseSpeech];
}

//- (IBAction)restart:(id)sender {
//    [self restartSpeech];
//}


/*---------------------------------
 HEADPHONES/EARPHONE ACTIONS
 ------------------------------- */

#pragma Earphone Button Events
- (void)remoteControlReceivedWithEvent:(UIEvent *)theEvent
{
    if (theEvent.type == UIEventTypeRemoteControl)
    {
        switch(theEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self playPauseToggle];
                break;
            default:
                return;
        }
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utteranc
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
