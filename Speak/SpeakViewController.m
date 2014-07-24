//
//  SpeakViewController.m
//  OCRSDKDemo
//
//  Created by Shalin Shah on 4/21/14.
//  Copyright (c) 2014 ABBYY. All rights reserved.
//

/*
 Fixes Needed:
 
 1.) Make the speech not repeat (done - crashes)
 2.) It says the first sentence twice (done)
 3.) Better UI (almost done)
 4.) Lesser duration of pauses
 
 */

#import "SpeakViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SpeakViewController ()
@property (nonatomic, strong) AVSpeechSynthesizer* talker;

@end

@implementation SpeakViewController

@synthesize player;
//@synthesize speakText = _speakText;
@synthesize volumeSlider = _volumeSlider;
@synthesize text = _text;
@synthesize utter = _utter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        lines = [[NSMutableArray alloc] init];
        URLArray = [NSMutableArray array];
        soundIsPlaying = NO;
//        self.volumeSlider.value = 0.5;
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    volumeLevel = self.volumeSlider.value;
}

-(void)viewDidLoad
{
    self.view.backgroundColor = [UIColor clearColor];
    UIImage *myImage = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"player", @"player-568h")];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:myImage]];
    
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"pointer.png"] forState:UIControlStateNormal];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
    playerInt = 0;
    
    speechPaused = NO;
//    [player volume] = self.volumeSlider.value;
    
//    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"pointer.png"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView
{
	if (_text != nil) {
        
    /*
        CONVERTING FROM TEXT TO SPEECH: 2 STEPS
     */
        // STEP ONE: Get Rid of Special Characters
        
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"*_@#^~`œ∑´®†¥¨ˆøπåß∂ƒ©˙∆˚¬Ω≈ç√∫˜µ¡™£¢∞§¶•ªº><"];
        _text = [[_text componentsSeparatedByCharactersInSet:doNotWant] componentsJoinedByString: @" "];
        NSLog(@"New Text: %@",_text);
//        _text = [_text stringByReplacingOccurrencesOfString:@"(" withString:@" "];
//        _text = [_text stringByReplacingOccurrencesOfString:@")" withString:@" "];
        
        // STEP TWO: Play the Sound
        [self playSound];
	}
}

-(void) playSound {
    _utter = [[AVSpeechUtterance alloc] initWithString:_text];
    _utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    [_utter setRate:0.2f];
    if (!self.talker) {
        self.talker = [AVSpeechSynthesizer new];
    }
    [self.talker speakUtterance:_utter];
}

- (IBAction)pauseSpeech:(id)sender {
    [self pauseSpeech];
}

- (IBAction)startSpeech:(id)sender {
    [self playSpeech];
}

- (void) pauseSpeech {
    if (speechPaused == NO) {
        [self.talker pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        speechPaused = YES;
    }
    if (self.talker.speaking == NO) {
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@""];
        [self.talker speakUtterance:utterance];
    }
}
- (void) playSpeech {
    [self.talker continueSpeaking];
    speechPaused = NO;
}


- (IBAction)speakClosed:(id)sender {
//    [player stop];
    
    if (self.mainView == nil) {
        self.mainView = [[ViewController alloc] initWithNibName:nil bundle:nil];
    }
    [self.navigationController pushViewController:self.mainView animated:NO];
}

- (void)setText:(NSString *)text
{
    if (_text != text) {
		_text = text;
        
        [self configureView];
    }
}


#pragma AVSpeechSynthesizer Delegate Methods

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    //NSLog(@”speechSynthesizer didStartSpeechUtterance”);
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utteranc
{
    // NSLog(@”speechSynthesizer didFinishSpeechUtterance”);
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance
{
    // NSLog(@”speechSynthesizer didPauseSpeechUtterance”);
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance
{
    // NSLog(@”speechSynthesizer didContinueSpeechUtterance”);
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance
{
    // NSLog(@”speechSynthesizer didCancelSpeechUtterance”);
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance
{
    
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

- (IBAction)sliderValueChanged:(UISlider *)sender {
    _utter.volume =  (int)sender.value;
}
@end
