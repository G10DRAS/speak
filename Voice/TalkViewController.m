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
    
    speechPaused = NO;
    
    self.view.backgroundColor = [UIColor clearColor];
    UIImage *myImage = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"player", @"player-568h")];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:myImage]];
    
    _text = [ViewController globalText];
    
    [self startTalking];
}

- (void) startTalking {
    speechPaused = NO;
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
        [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
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

- (IBAction)playButtonPressed:(id)sender {
    [self playSpeech];
}

- (IBAction)pauseButtonPressed:(id)sender {
    [self pauseSpeech];
}

- (IBAction)goToMain:(id)sender {
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
