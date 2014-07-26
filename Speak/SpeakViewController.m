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

@interface SpeakViewController ()
@property (nonatomic, strong) AVSpeechSynthesizer *talker;

@end

@implementation SpeakViewController

@synthesize player;
//@synthesize speakText = _speakText;
@synthesize volumeSlider = _volumeSlider;
@synthesize text = _text;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        lines = [[NSMutableArray alloc] init];
        URLArray = [NSMutableArray array];
        soundIsPlaying = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad
{
    self.talker = [[AVSpeechSynthesizer alloc] init];

    speechPaused = NO;
    
    volumeLevel = self.volumeSlider.value;
    _volumeSlider.minimumValue = 0.0;
    _volumeSlider.maximumValue = 1.0;
    _volumeSlider.continuous = YES;

    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    if ([self canBecomeFirstResponder]) {
        [self becomeFirstResponder];
    }
    
    self.view.backgroundColor = [UIColor clearColor];
    UIImage *myImage = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"player", @"player-568h")];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:myImage]];
    
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"pointer.png"] forState:UIControlStateNormal];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
    playerInt = 0;
    
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
        
        NSCharacterSet *charsToStripOut = [NSCharacterSet characterSetWithCharactersInString:@"*_@#^~`œ∑´®†¥¨ˆøπåß∂ƒ©˙∆˚¬Ω≈ç√∫˜µ¡™£¢∞§¶•ªº><"];
        _text = [[_text componentsSeparatedByCharactersInSet:charsToStripOut] componentsJoinedByString: @" "];
//        _text = [_text stringByReplacingOccurrencesOfString:@"(" withString:@" "];
//        _text = [_text stringByReplacingOccurrencesOfString:@")" withString:@" "];
        
        // STEP TWO: Play the Sound
        [self playSound];
	}
}

-(void) playSound {
    speechPaused = NO;
    AVSpeechUtterance* utter = [[AVSpeechUtterance alloc] initWithString:_text];
    utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    utter.volume = 1.0f;
    [utter setRate:0.2f];
    if (!self.talker) {
        self.talker = [AVSpeechSynthesizer new];
    }
    self.talker.delegate = self;
    [self.talker speakUtterance:utter];
//    _volumeSlider.value = utter.volume;
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
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-au"];
        [self.talker speakUtterance:utterance];
    }
    NSLog(@"Pause");
}
- (void) playSpeech {
    [self.talker continueSpeaking];
    speechPaused = NO;
    NSLog(@"Play");
}
- (void) playPauseToggle {
    if (speechPaused == NO) {
        [self pauseSpeech];
    } else if (speechPaused == YES) {
        [self playSpeech];
    }
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
//    AVSpeechUtterance *utter = [[AVSpeechUtterance alloc] initWithString:@""];
//    utter.volume = sender.value;
}
@end
