//
//  SpeakViewController.m
//  OCRSDKDemo
//
//  Created by Shalin Shah on 4/21/14.
//  Copyright (c) 2014 ABBYY. All rights reserved.
//

#import "SpeakViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SpeakViewController ()

@end

@implementation SpeakViewController

@synthesize fliteController = _fliteController;
@synthesize slt = _slt;
@synthesize audioPlayer = _audioPlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.google_TTS_BySham = [[Google_TTS_BySham alloc] init];
        
        lines = [[NSMutableArray alloc] init];
        URLArray = [NSMutableArray array];
        soundIsPlaying = NO;
        playerInt = -1;
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
    
    
//    while ([_text length] > 100) {
//        [lines addObject:[_text substringToIndex:100]];
//        _text = [_text substringFromIndex:100];
//    }
//    [lines addObject: _text];
//    
//    reformattedString = [lines componentsJoinedByString:@"\n"];
    
//    NSCountedSet *countedSet = [NSCountedSet new];
    
//    [_text enumerateSubstringsInRange:NSMakeRange(0, [_text length])
//                               options:NSStringEnumerationByWords | NSStringEnumerationLocalized
//                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
//                                
//                                // This block is called once for each word in the string.
//                                [countedSet addObject:substring];
//                                
//                                // If you want to ignore case, so that "this" and "This"
//                                // are counted the same, use this line instead to convert
//                                // each word to lowercase first:
//                                // [countedSet addObject:[substring lowercaseString]];
//                            }];
//    
//    NSLog(@"%@", countedSet);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView
{
    
    
    
//    NSArray *chunks = [_text componentsSeparatedByString: @" "];

    
	if (self.text != nil) {
        
        _text = [_text stringByReplacingOccurrencesOfString:@"*" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@"(" withString:@" "];
        _text = [_text stringByReplacingOccurrencesOfString:@")" withString:@" "];
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
        
        NSString *pattern = @"(?ws).{1,100}\\b";
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: pattern options: 0 error: &error];
        
        NSArray *matches = [regex matchesInString:_text options:0 range:NSMakeRange(0, [_text length])];
        
        result = [NSMutableArray array];
        for (NSTextCheckingResult *match in matches) {
            [result addObject: [_text substringWithRange: match.range]];
//            NSLog(@"%@", result);
        }
        
//        NSLog(@"%@", stringToSpeak);
        
//        [self.google_TTS_BySham speak:stringToSpeak];
        
        
        
//        [self numberOfWordsInString:_text];
        
        
        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"file.mp3"];
//        
//        NSString *urlString = [NSString stringWithFormat:@"http://www.translate.google.com/translate_tts?tl=en&q=%@",stringToSpeak];
//        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
//        [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" forHTTPHeaderField:@"User-Agent"];
//        NSURLResponse* response = nil;
//        NSError* error = nil;
//        NSData* data = [NSURLConnection sendSynchronousRequest:request
//                                             returningResponse:&response
//                                                         error:&error];
//        
//        NSLog(@"%@",data);
//        [data writeToFile:path atomically:YES];
//        
//        AVAudioPlayer  *player;
//        NSError        *err;
//        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
//        {
//            player = [[AVAudioPlayer alloc] initWithContentsOfURL:
//                      [NSURL fileURLWithPath:path] error:&err];
//            player.volume = 1.0f;
//            [player prepareToPlay];
//            [player setNumberOfLoops:0];
//            [player play];    
//        }
        
        
//        for (int i = 0; i < [result count]; i++) {
            NSString *stringToSpeak = [NSString stringWithFormat:@"%@", result];
        
//            NSString *queryTTS = [stringToSpeak stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            
//            NSString *linkTTS = [NSString stringWithFormat:@"http://translate.google.com/translate_tts?tl=en&q=%@",result[i]];
        
        
//        NSString *text = @"You are one chromosome away from being a potato.";
        for (int i = 0; i < [result count]; i++) {
            NSString *urlString = [NSString stringWithFormat:@"http://www.translate.google.com/translate_tts?ie=UTF-8&tl=en&total=%d&idx=%i&textlen=%i&q=%@", result.count, i, [result[i] length], result[i]];
            
        
            [URLArray addObject:[NSString stringWithFormat:@"http://www.translate.google.com/translate_tts?ie=UTF-8&tl=en&total=%d&idx=%i&textlen=%i&q=%@", result.count, i, [result[i] length], result[i]]];
            
            NSLog(@"%@", URLArray);
        }
        [self playSound];

        
//            NSData *dataTTS = [NSData dataWithContentsOfURL:[NSURL URLWithString:linkTTS]];
//            
//            _googlePlayer = [[AVAudioPlayer alloc] initWithData:dataTTS error:nil];
//            [_googlePlayer play];
//        }
        
        
//        AVSpeechUtterance *utterance = [AVSpeechUtterance
//                                        speechUtteranceWithString:stringToSpeak];
//        AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
//        [synth speakUtterance:utterance];
//        
//        self.google_TTS_BySham.volume = 1.0f;
        
//        [self.fliteController say:stringToSpeak withVoice:self.slt];
	}
}

-(void) playSound {
    if (soundIsPlaying == NO) {
//        for (int i = 0; i < [URLArray count]; i++) {
            playerInt += 1;
        
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:@"file.mp3"];

        
            NSString *stringer = [NSString stringWithFormat:@"%@", URLArray[playerInt]];
            
            NSURL *url = [NSURL URLWithString:[stringer stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url] ;
            [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" forHTTPHeaderField:@"User-Agent"];
            NSURLResponse* response = nil;
            NSData* data = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:nil];
            [data writeToFile:path atomically:YES];
            
//            url2 = [NSURL fileURLWithPath:path];
//            
//            AudioServicesCreateSystemSoundID((__bridge CFURLRef)url2, &soundID);
//            AudioServicesPlaySystemSound (soundID);
//            
//            AudioServicesAddSystemSoundCompletion ( soundID, NULL, NULL, endSound, NULL );
        
        
            NSError *err;
            if ([[NSFileManager defaultManager] fileExistsAtPath:path])
            {
                _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:
                          [NSURL fileURLWithPath:path] error:&err];
                _audioPlayer.volume = 0.4f;
                [_audioPlayer prepareToPlay];
                [_audioPlayer setNumberOfLoops:0];
                [_audioPlayer play];
            }
//            [self checkIfSoundIsPlaying];
            soundIsPlaying = YES;
        
        
//        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)_audioPlayer successfully:(BOOL)flag
{
    [self playSound];
}

-(void) checkIfSoundIsPlaying {
    if ([_audioPlayer isPlaying]) {
        
    } else {
        [self playSound];
    }
}

//void endSound (
//               SystemSoundID  ssID,
//               void           *clientData
//               )
//{
//
//}



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
