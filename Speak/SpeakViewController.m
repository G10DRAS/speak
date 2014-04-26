//
//  SpeakViewController.m
//  OCRSDKDemo
//
//  Created by Shalin Shah on 4/21/14.
//  Copyright (c) 2014 ABBYY. All rights reserved.
//

#import "SpeakViewController.h"

@interface SpeakViewController ()

@end

@implementation SpeakViewController

@synthesize fliteController = _fliteController;
@synthesize slt = _slt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.google_TTS_BySham = [[Google_TTS_BySham alloc] init];
    }
    return self;
}

- (FliteController *)fliteController {
	if (fliteController == nil) {
		fliteController = [[FliteController alloc] init];
	}
	return fliteController;
}

- (Slt *)slt {
	if (slt == nil) {
		slt = [[Slt alloc] init];
	}
	return slt;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView
{
	if (self.text != nil) {
        NSString *stringToSpeak = [NSString stringWithFormat:@"%@", _text];
//        [self.google_TTS_BySham speak:stringToSpeak];
        
//        AVSpeechUtterance *utterance = [AVSpeechUtterance
//                                        speechUtteranceWithString:stringToSpeak];
//        AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
//        [synth speakUtterance:utterance];
//        
//        self.google_TTS_BySham.volume = 1.0f;
        
//        [self.fliteController say:stringToSpeak withVoice:self.slt];
	}
}

- (void)setText:(NSString *)text
{
    if (_text != text) {
		_text = text;
        
        [self configureView];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
