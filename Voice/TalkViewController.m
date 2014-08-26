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
    
    speakArray = [[NSMutableArray alloc] init];
    imageArray = [[NSMutableArray alloc] init];
    
    imageArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ImagesArray"]];
    [speakArray addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"ImageText"]];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.scrollView.contentSize = CGSizeMake(320, 465);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    CGRect workingFrame = self.scrollView.frame;
    workingFrame.origin.x = 0;
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[imageArray count]];
    for (int i = 0; i < [imageArray count]; i++) {
        UIImage* image = [UIImage imageWithData:[imageArray objectAtIndex:i]];
        [images addObject:image];
        
        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.frame = workingFrame;
        
        [self.scrollView addSubview: imageview];
        workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
    }
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    if ([self canBecomeFirstResponder]) {
        [self becomeFirstResponder];
    }

    
    speechPaused = NO;
    imageNumber = 1;
    
    self.view.backgroundColor = [UIColor clearColor];
    UIImage *myImage = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"player", @"player-568h")];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:myImage]];
    
    
    compressingImage = YES;
    
//    NSLog(@"speakArray: %@", speakArray);

    
    [self startTalking];
    
    NSLog(@"imageArray Count: %d", [imageArray count]);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([imageArray count] > imageNumber) {
        [self fetchTextFromImage:[imageArray objectAtIndex:imageNumber]];
    }

}

- (void) startTalking {
    speechPaused = NO;
    NSString *imageText = [NSString stringWithFormat:@"%@", [speakArray objectAtIndex:0]];
    AVSpeechUtterance* utter = [[AVSpeechUtterance alloc] initWithString:imageText];
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

/*---------------------------------
 AVSPEECHSYNTHESIZER DELEGATE METHODS
 ------------------------------- */
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    imageNumber += 1;
    if ([speakArray count] + 1 > imageNumber) {
        [self fetchTextFromImage:[imageArray objectAtIndex:imageNumber]];
        
        speechPaused = NO;
        NSString *imageText = [NSString stringWithFormat:@"%@", [speakArray objectAtIndex:imageNumber-1]];
        AVSpeechUtterance* utter = [[AVSpeechUtterance alloc] initWithString:imageText];
        utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
        [utter setRate:0.2f];
        if (!self.synthesizer) {
            self.synthesizer = [AVSpeechSynthesizer new];
        }
        self.synthesizer.delegate = self;
        [self.synthesizer speakUtterance:utter];
    }
}


/*---------------------------------
 GET TEXT FROM IMAGES
 ------------------------------- */

- (void) fetchTextFromImage: (NSData *)theImage {
    compressingImage = YES;
    
    UIImage *imageFromData = [UIImage imageWithData:theImage];
    UIImage *myScaledImage = [self imageWithImage:imageFromData scaledToSize:CGSizeMake(imageFromData.size.width * .3, imageFromData.size.height * .3)];
    NSData *dataFromImage = UIImagePNGRepresentation(myScaledImage);

    
    // Create path for image.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
    
    // Save image to disk.
    NSData *data = dataFromImage;
    [data writeToFile:imagePath atomically:YES];
    NSLog(@"%@", imagePath);
    
    [self postToGoogleDrive];
    
//    // POST request to TinyPNG
//    NSString *tinyPNGToken = @"lIC0N4QDMFfE2QfPj8Qz2Hh_ZsUaLDbQ";
//    NSData *fileData = [[NSData alloc] initWithContentsOfFile:imagePath];
//    NSString *link = [NSString stringWithFormat:@"https://api.tinypng.com/shrink"];
//    NSMutableURLRequest *makeRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:link]];
//    
//    // Headers
//    [makeRequest setValue:[NSString stringWithFormat:@"Basic %@", tinyPNGToken] forHTTPHeaderField:@"Authorization"];
//    
//    NSMutableData *theBody = [NSMutableData data];
//    [theBody appendData:[NSData dataWithData:fileData]];
//    
//    [makeRequest setHTTPMethod:@"POST"];
//    [makeRequest setHTTPBody:theBody];
//    NSURLConnection *connection;
//    connection = [[NSURLConnection alloc] initWithRequest:makeRequest delegate:self];
//    receivedData = [[NSMutableData alloc] init];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (compressingImage == NO) {
        NSLog(@"Uploaded to Google Drive");
        [self getFile];
    } else {
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:receivedData // step 1
                              options:kNilOptions
                              error:&error];
        
        NSDictionary *output = [json objectForKey:@"output"];
        compressedImageURL = [output objectForKey:@"url"];
        
        NSLog(@"The JSON Data: %@", json);
        
        [self getCompressedImage];
    }
}
- (void) getCompressedImage{
    compressedImageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:compressedImageURL]];
    [self postToGoogleDrive];
}
-(void) postToGoogleDrive {
//    // Create path for image.
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
//    
//    // Save image to disk.
//    NSData *data = compressedImageData;
//    [data writeToFile:imagePath atomically:YES];
    
    compressingImage = NO;
    
    // Get the size of the image
    unsigned long long size = [[NSFileManager defaultManager] attributesOfItemAtPath:imagePath error:nil].fileSize;
    NSLog(@"Size %llu", size);
    
    // POST request to Google Drive
    theToken = [ViewController globalToken];
    NSData *file1Data = [[NSData alloc] initWithContentsOfFile:imagePath];
    NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/upload/drive/v2/files?uploadType=media&convert=true&ocr=true&ocrLanguage=en"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    // Headers
    [request setValue:[NSString stringWithFormat:@"%llu", size] forHTTPHeaderField:@"Content-length"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", theToken] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[NSData dataWithData:file1Data]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    NSURLConnection *theConnection;
    theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    receivedData = [[NSMutableData alloc] init];
}
- (void) getFile{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:@"https://www.googleapis.com/drive/v2/files"]];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", theToken] forHTTPHeaderField:@"Authorization"];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting https://www.googleapis.com/drive/v2/files, HTTP status code %f", (float)[responseCode statusCode]);
    }
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:oResponseData // step 1
                          options:kNilOptions
                          error:&error];
    
    NSDictionary *contentsOfJSON = [[json objectForKey:@"items"] objectAtIndex:0]; // step 2
    NSDictionary *fileID = [contentsOfJSON objectForKey:@"id"];
    imageFileID = [contentsOfJSON objectForKey:@"id"];
    
    NSDictionary *allURLS = [contentsOfJSON objectForKey:@"exportLinks"];
    plainTextURL = [allURLS objectForKey:@"text/plain"];
    NSLog(@"file ID: %@", fileID);
    NSLog(@"download URL: %@", plainTextURL);
    
    [self extractText];
}

- (void) extractText{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", plainTextURL]]];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", theToken] forHTTPHeaderField:@"Authorization"];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    NSString *actualText = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    theOCRText = actualText;
    
    [speakArray addObject:actualText];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %f", plainTextURL, (float)[responseCode statusCode]);
    }
    
    NSLog(@"%@",[[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding]);
    
    NSMutableURLRequest *deleteRequest = [[NSMutableURLRequest alloc] init];
    [deleteRequest setHTTPMethod:@"DELETE"];
    [deleteRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/drive/v2/files/%@", imageFileID]]];
    [deleteRequest setValue:[NSString stringWithFormat:@"Bearer %@", theToken] forHTTPHeaderField:@"Authorization"];
    
    NSData *theResponseData;
    theResponseData = [NSURLConnection sendSynchronousRequest:deleteRequest returningResponse:&responseCode error:&error];
    
    compressingImage = YES;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*---------------------------------
 EXTRA STUFF
 ------------------------------- */

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
