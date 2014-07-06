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

- (void)viewDidLoad
{
    UIImage *myImage = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"player", @"player-568h")];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:myImage]];

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
	if (self.text != nil) {
        
    /*
        CONVERTING FROM TEXT TO SPEECH: 4 STEPS
     */
        
        // STEP ONE: Make Sure None of These Characters Are Read
        _text = [_text stringByReplacingOccurrencesOfString:@"*" withString:@" "];
//        _text = [_text stringByReplacingOccurrencesOfString:@"(" withString:@" "];
//        _text = [_text stringByReplacingOccurrencesOfString:@")" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"@" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"#" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"^" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"~" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"`" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"œ" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"∑" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"´" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"®" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"†" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"¥" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"¨" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"ˆ" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"ø" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"π" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"å" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"ß" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"∂" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"ƒ" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"©" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"˙" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"∆" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"˚" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"¬" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"Ω" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"≈" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"ç" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"√" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"∫" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"˜" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"µ" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"¡" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"™" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"£" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"¢" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"∞" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"§" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"¶" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"•" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"ª" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"º" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@">" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"<" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"   " withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"    " withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"     " withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"      " withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"       " withString:@" "];

        // STEP TWO: Make Strings Shorter than 90 Charactaers
//        NSString *pattern = @"(?ws).{1,90}\\b";
//        NSError *error = nil;
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: pattern options: 0 error: &error];
//        NSArray *matches = [regex matchesInString:_text options:0 range:NSMakeRange(0, [_text length])];
//        result = [NSMutableArray array];
//        for (NSTextCheckingResult *match in matches) {
//            [result addObject: [_text substringWithRange: match.range]];
//        }
        
        // STEP THREE: Generate the Different Links
//        for (int i = 0; i < [result count]; i++) {
//            [URLArray addObject:[NSString stringWithFormat:@"http://www.translate.google.com/translate_tts?ie=UTF-8&tl=en&total=%d&idx=%i&textlen=%i&q=%@", result.count, i, [result[i] length], result[i]]];
//            NSLog(@"%i",i);
//        }
        
        // STEP FOUR: Play the Sound
        
        // Only for iOS 7
//        if IS_OS_7_OR_LATER {
//        AVSpeechUtterance *utterance = [AVSpeechUtterance
//                                        speechUtteranceWithString:_text];
//        AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
//        [synth speakUtterance:utterance];
//        } else {
//        }
        
        AVSpeechUtterance *utter = [[AVSpeechUtterance alloc] initWithString:_text];
        utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
        [utter setRate:0.2f];
        if (!self.talker) {
            self.talker = [AVSpeechSynthesizer new];
        }
        [self.talker speakUtterance:utter];
        
//        [self playSound];
	}
}

-(void) playSound {
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"file.mp3"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"YES");
    }
    
    NSString *stringer = [NSString stringWithFormat:@"%@", URLArray[playerInt]];
    NSLog(@"%i",playerInt);
    
    NSURL *url = [NSURL URLWithString:[stringer stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" forHTTPHeaderField:@"User-Agent"];
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                      error:&error];
    [data writeToFile:path atomically:YES];

    player = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath:path] error:nil];
    player.delegate = self;
//    player.volume = volumeLevel;
    [player prepareToPlay];
    [player play];

    NSLog(@"%@", stringer);
}

- (IBAction)stopSpeech:(id)sender {
    [player pause];
}

- (IBAction)startSpeech:(id)sender {
    [player play];
}

- (IBAction)speakClosed:(id)sender {
    [player stop];
    
    if (self.mainView == nil) {
        self.mainView = [[ViewController alloc] initWithNibName:nil bundle:nil];
    }
    [self.navigationController pushViewController:self.mainView animated:NO];
}

//- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) players successfully: (BOOL) flag {
//    if (flag == YES) {
//        playerInt += 1;
//        [self playSound];
//        NSLog(@"%i",playerInt);
//        
//        if ((playerInt + 1) > result.count) {
//            [player stop];
//        }
//    }
//}

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

@end
