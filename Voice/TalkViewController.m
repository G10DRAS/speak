//
//  TalkViewController.m
//  Voice
//
//  Created by Shalin Shah on 7/26/14.
//  Copyright (c) 2014 Shalin Shah. All rights reserved.
//

#import "TalkViewController.h"
#define kPadding 20

@import AVFoundation;

@interface TalkViewController () <AVSpeechSynthesizerDelegate>
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

@property (nonatomic, strong) NSTimer *autoScrollTimer;
@property (nonatomic, assign) NSInteger currentPage;

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
    mixpanel = [Mixpanel sharedInstance];

    speakArray = [[NSMutableArray alloc] init];
    imageArray = [[NSMutableArray alloc] init];
    
    imageArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ImagesArray"]];
    [speakArray addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"ImageText"]];
    
    speechPaused = NO;
    imageNumber = 1;
    speechNumber = 1;
    
    // If no language selected, defualt is english
    NSObject *ocr = [[NSUserDefaults standardUserDefaults] objectForKey:@"languageForOCR"];
    NSObject *tts = [[NSUserDefaults standardUserDefaults] objectForKey:@"languageForTTS"];
    
    if(ocr == nil || tts == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@"en-US" forKey:@"languageForTTS"];
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"languageForOCR"];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"didClickShare"];

    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"speedForTTS"] == nil) {
        [[NSUserDefaults standardUserDefaults] setFloat:0.1f forKey:@"speedForTTS"];
    }
    
    ttsSpeed = [[NSUserDefaults standardUserDefaults] floatForKey:@"speedForTTS"];
    
    [self startTalking];

    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    isSkipping = NO;
    
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[imageArray count]];
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGRect workingFrame = CGRectMake (0,0,self.scrollView.frame.size.width,self.scrollView.frame.size.height);
    workingFrame.origin.x = 0;
    
    
    for (int i = 0; i < [imageArray count]; i++) {
        UIImage *image = [UIImage imageWithData:[imageArray objectAtIndex:i]];
        [images addObject:image];
        
        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.frame = workingFrame;
        
        [_scrollView addSubview:imageview];
        workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
        
//        if (image.size.width > image.size.height) {
//            NSLog(@"Image is now landscape");
//        } else {
//            NSLog(@"Image is now portrait");
//        }
        
    }

    
    [_scrollView setPagingEnabled:YES];
    [_scrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];

    
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    if ([self canBecomeFirstResponder]) {
        [self becomeFirstResponder];
    }

    // Some UI stuff
    self.view.backgroundColor = [UIColor clearColor];
    UIImage *myImage = [UIImage imageNamed:@"background"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:myImage]];
    
    
    // Nav Bar UI Stuff
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:26.0f];;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Speaking...", @"");
    [label sizeToFit];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

    self.pageLabel.text = [NSString stringWithFormat:@"Page %i", speechNumber];
    
    NSLog(@"imageArray Count: %d", (int)[imageArray count]);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([imageArray count] > imageNumber) {
        [self fetchTextFromImage:[imageArray objectAtIndex:imageNumber]];
    }
    
}


// ScrollView
- (void) scrollViewInit {
    CGRect workingFrame = self.scrollView.frame;
    workingFrame.origin.x = 0;
    
    _scrollView.delegate = self;
    
    int i=0;
    for ( NSString *image in imageArray)
    {
        UIImage *photos = [UIImage imageWithData:[imageArray objectAtIndex:i]];
        UIImageView *imageview = [[UIImageView alloc] initWithImage:photos];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.clipsToBounds = YES;
        imageview.tag = 1;
        
        UIScrollView *scrollingView = [[UIScrollView alloc] initWithFrame:CGRectMake( IMAGE_WIDTH * i++, 0, IMAGE_WIDTH, IMAGE_HEIGHT)];
        scrollingView.delegate = self;
        scrollingView.maximumZoomScale = 3.0f;
        imageview.frame = scrollingView.bounds;
        [scrollingView addSubview:imageview];
        
        [self.scrollView addSubview:scrollingView];
    }
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
}


/*---------------------------------
 TTS CONTROL METHODS
 ------------------------------- */

- (void) startTalking {
    [mixpanel track:@"Image Being Spoken"];

    speechPaused = NO;
    NSString *imageText = [NSString stringWithFormat:@"%@", [speakArray objectAtIndex:(speechNumber-1)]];
    AVSpeechUtterance* utter = [[AVSpeechUtterance alloc] initWithString:imageText];
    utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"languageForTTS"]];
    [utter setRate:ttsSpeed];
    if (!self.synthesizer) {
        self.synthesizer = [AVSpeechSynthesizer new];
    }
    self.synthesizer.delegate = self;
    [self.synthesizer speakUtterance:utter];
    self.pageLabel.text = [NSString stringWithFormat:@"Page %i", speechNumber];
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
    if (speechPaused == YES) {
        [self.synthesizer continueSpeaking];
        NSLog(@"Played");
        speechPaused = NO;
    }
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
}
- (void) restartSpeech {
    isSkipping = YES;
    AVSpeechSynthesizer *talked = self.synthesizer;
    if([talked isSpeaking]) {
        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@""];
        [talked speakUtterance:utterance];
        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
    speechNumber = 1;
    self.pageLabel.text = [NSString stringWithFormat:@"Page %i", speechNumber];
    [self startTalking];
}

- (IBAction)playButtonPressed:(id)sender {
    [self playSpeech];
}

- (IBAction)pauseButtonPressed:(id)sender {
    [self pauseSpeech];
}

- (IBAction)restartButtonPressed:(id)sender {
    [self restartSpeech];
}

- (IBAction)nextButtonPressed:(id)sender {
    isSkipping = YES;
    [self stopSpeech];
    if (speechNumber < [speakArray count]) {
        speechNumber += 1;
        self.pageLabel.text = [NSString stringWithFormat:@"Page %i", speechNumber];
        [self startTalking];
    } else {
        self.pageLabel.text = [NSString stringWithFormat:@"Page %i", speechNumber];
        [self startTalking];
    }
}

- (IBAction)prevButtonPressed:(id)sender {
    isSkipping = YES;
    [self stopSpeech];
    if (speechNumber > 1) {
        speechNumber -= 1;
        self.pageLabel.text = [NSString stringWithFormat:@"Page %i", speechNumber];
        [self startTalking];
    } else {
        [self restartSpeech];
    }
}

/*---------------------------------
 AVSPEECHSYNTHESIZER DELEGATE METHODS
 ------------------------------- */
- (void) startTalking2 {
    NSString *imageText = [NSString stringWithFormat:@"%@", [speakArray objectAtIndex:(speechNumber-1)]];
    AVSpeechUtterance* utter = [[AVSpeechUtterance alloc] initWithString:imageText];
    utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"languageForTTS"]];
    [utter setRate:ttsSpeed];
    if (!self.synthesizer) {
        self.synthesizer = [AVSpeechSynthesizer new];
    }
    self.synthesizer.delegate = self;
    [self.synthesizer speakUtterance:utter];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    if ([speakArray count] > speechNumber) {
        if (!isSkipping) {
            speechNumber += 1;
        }
        speechPaused = NO;
        NSString *imageText = [NSString stringWithFormat:@"%@", [speakArray objectAtIndex:(speechNumber-1)]];
        AVSpeechUtterance* utter;
        if ([imageText isEqualToString:@"________________"] || [imageText isEqualToString:@""]) {
            utter = [[AVSpeechUtterance alloc] initWithString:@"There were no words detected on this page. I am moving on."];
        } else {
            utter = [[AVSpeechUtterance alloc] initWithString:imageText];
        }
        utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"languageForTTS"]];
        [utter setRate:ttsSpeed];
        if (!self.synthesizer) {
            self.synthesizer = [AVSpeechSynthesizer new];
        }
        self.synthesizer.delegate = self;
        [self.synthesizer speakUtterance:utter];
        self.pageLabel.text = [NSString stringWithFormat:@"Page %i", speechNumber];
        isSkipping = NO;
    } else {
        if (imageArray.count != speakArray.count) {
//        dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//        dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
            AVSpeechUtterance* utter = [[AVSpeechUtterance alloc] initWithString:@""];
            utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"languageForTTS"]];
            [utter setRate:ttsSpeed];
            if (!self.synthesizer) {
                self.synthesizer = [AVSpeechSynthesizer new];
            }
            self.synthesizer.delegate = self;
            [self.synthesizer speakUtterance:utter];
//        });
        }
    }
}


/*---------------------------------
 GET TEXT FROM IMAGES
 ------------------------------- */

- (void) fetchTextFromImage: (NSData *)theImage {
    
    UIImage *imageFromData = [UIImage imageWithData:theImage];
    UIImage *myScaledImage = [self imageWithImage:imageFromData scaledToSize:CGSizeMake(imageFromData.size.width * .3, imageFromData.size.height * .3)];
    NSData *dataFromImage = UIImagePNGRepresentation(myScaledImage);

    // Create path for image.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
    
    // Save image to disk.
    NSData *data = dataFromImage;
    [data writeToFile:imagePath atomically:YES];
    
    NSLog(@"The image path: %@", imagePath);
    
    [self postToGoogleDrive];
    [mixpanel timeEvent:@"Image Upload"];
    
}
-(void) postToGoogleDrive {
    
    // Get the size of the image
    unsigned long long size = [[NSFileManager defaultManager] attributesOfItemAtPath:imagePath error:nil].fileSize;
    NSLog(@"Size %llu", size);
    
    // POST request to Google Drive
    theToken = [ViewController globalToken];
    NSData *file1Data = [[NSData alloc] initWithContentsOfFile:imagePath];
    NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/upload/drive/v2/files?uploadType=media&convert=true&ocr=true&ocrLanguage=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"languageForOCR"]];
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
    
    if ([self isViewLoaded] == false) {
        [theConnection cancel];
        theConnection = nil;
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Uploaded to Google Drive");
    [mixpanel track:@"Image Uploaded to Google Drive"];
    // If view is not loaded, we don't want the image extraction to occur
    if ([self isViewLoaded] == true) {
        [self getFile];
    }
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
    imageFileID = [contentsOfJSON objectForKey:@"id"];
    
    NSDictionary *allURLS = [contentsOfJSON objectForKey:@"exportLinks"];
    plainTextURL = [allURLS objectForKey:@"text/plain"];
    NSLog(@"file ID: %@", imageFileID);
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
    
    [speakArray addObject:actualText];
    [mixpanel track:@"Image Converted to Text"];
    [mixpanel track:@"Image Upload"];
    
    imageNumber ++;
    if ([imageArray count] > imageNumber) {
        [self fetchTextFromImage:[imageArray objectAtIndex:imageNumber]];
    }
    //    compressingImage = YES;
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
 NAVIGATION
 ------------------------------- */

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //clear the images
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        // Stop the TTS
        AVSpeechSynthesizer *talked = self.synthesizer;
        if([talked isSpeaking]) {
            [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
            AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@""];
            [talked speakUtterance:utterance];
            [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        }
    }
    
    for (int i = 0; i < [imageArray count]; i++) {
        UIImage *imageFromData = [UIImage imageWithData:[imageArray objectAtIndex:i]];
        UIImage *myScaledImage = [self imageWithImage:imageFromData scaledToSize:CGSizeMake(imageFromData.size.width * .3, imageFromData.size.height * .3)];
        NSData *dataFromImage = UIImagePNGRepresentation(myScaledImage);
        
        // Create path for image.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
        
        // Save image to disk.
        NSData *data = dataFromImage;
        [data writeToFile:imagePath atomically:YES];
        
        // Delete the image
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath = [docDir stringByAppendingPathComponent:imagePath];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:pngFilePath error:&error];
    }
    
    [imageArray removeAllObjects];
    [speakArray removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ImagesArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ImageText"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TemporaryImages"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self clearTmpDirectory];
}

/*---------------------------------
 SHARE / SAVE DOCUMENT
 ------------------------------- */

- (IBAction)shareButton:(id)sender {
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"What do you want to export as?" message:@"What do you want to export this Voice text as? You can export as the image only, the text only, or a PDF with the recognized text and image." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        // optional - add more buttons:
        [alert addButtonWithTitle:@"PDF"];
        [alert addButtonWithTitle:@"Text"];
        [alert addButtonWithTitle:@"Image"];
        [alert show];
        [alert setTag:12];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 12) {
        if (buttonIndex == 0) {     // and they clicked OK.
        } else if (buttonIndex == 1) {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"ExportAs"]; // pdf
            [self share];
        } else if (buttonIndex == 2) {
            [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"ExportAs"]; // txt
            [self share];
        } else if (buttonIndex == 3) {
            [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"ExportAs"]; // png
            [self share];
        }
    }
}
-(void) share {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"didClickShare"] == NO) {
    // save pdf
        [self makePDF];
    // save text
        stringToShare = @"";
        for (int i = 0; i < [imageArray count]; i++) {
            stringToShare = [stringToShare stringByAppendingString:[NSString stringWithFormat:@"\n\n %@", [speakArray objectAtIndex:i]]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:stringToShare forKey:@"StringToShare"];
    // save image
        imageToShare = [UIImage imageWithData:[imageArray objectAtIndex:0]];
        // Create path.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"VoiceImage.png"];
        // Save image.
        [UIImagePNGRepresentation(imageToShare) writeToFile:filePath atomically:YES];
        [[NSUserDefaults standardUserDefaults] setObject:filePath forKey:@"ImageToShare"];
    // update bool so this doesn't get called again
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"didClickShare"];
    // synchronize
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ExportAs"] == 1) { // pdf
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:@"VoiceText.pdf"];
        
        self.docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:pdfPath]];
        [self.docController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
    } else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ExportAs"] == 2) { // text
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"StringToShare"]);
        NSArray *objectsToShare = @[[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"StringToShare"]]];
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
        [self presentViewController:activityViewController animated:YES completion:nil];
    } else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ExportAs"] == 3) { // image
        self.docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults] stringForKey:@"ImageToShare"]]];
        [self.docController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
    }
}

#pragma mark - UIDocumentInteractionControllerDelegate
- (UIDocumentInteractionController *) setupControllerWithURL:(NSURL *)fileURL
                                               usingDelegate:(id <UIDocumentInteractionControllerDelegate>)         interactionDelegate {
    
    UIDocumentInteractionController *interactionController =
    [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.frame;
}

/*---------------------------------
 CREATE A PDF
 ------------------------------- */

-(void) makePDF {
    [self setupPDFDocumentNamed:@"VoiceText" Width:850 Height:4100];
    
    [self beginPDFPage];
    
    NSString *textToShare = @"";
    for (int i = 0; i < [imageArray count]; i++) {
        textToShare = [textToShare stringByAppendingString:[NSString stringWithFormat:@"\n\n %@", [speakArray objectAtIndex:i]]];
    }
    
    CGRect textRect = [self addText:textToShare
                          withFrame:CGRectMake(kPadding, kPadding, 400, 200) fontSize:48.0f];
    CGRect blueLineRect = [self addLineWithFrame:CGRectMake(kPadding, textRect.origin.y + textRect.size.height + kPadding, _pageSize.width - kPadding*2, 4)
                                       withColor:[UIColor blueColor]];
    UIImage *anImage = [UIImage imageWithData:[imageArray objectAtIndex:0]];
    CGRect imageRect = [self addImage:anImage
                              atPoint:CGPointMake((_pageSize.width/2)-(anImage.size.width/2), blueLineRect.origin.y + blueLineRect.size.height + kPadding)];
    [self addLineWithFrame:CGRectMake(kPadding, imageRect.origin.y + imageRect.size.height + kPadding, _pageSize.width - kPadding*2, 4)
                 withColor:[UIColor redColor]];
    
    [self finishPDF];
}

- (void)finishPDF {
    UIGraphicsEndPDFContext();
}

- (void)setupPDFDocumentNamed:(NSString*)name Width:(float)width Height:(float)height {
    _pageSize = CGSizeMake(width, height);
    
    NSString *newPDFName = [NSString stringWithFormat:@"%@.pdf", name];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:newPDFName];
    

    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
}
- (void)beginPDFPage {
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, _pageSize.width, _pageSize.height), nil);
}
- (CGRect)addText:(NSString*)text withFrame:(CGRect)frame fontSize:(float)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    CGSize stringSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(_pageSize.width - 2*20-2*20, _pageSize.height - 2*20 - 2*20) lineBreakMode:UILineBreakModeWordWrap];
    
    float textWidth = frame.size.width;
    
    if (textWidth < stringSize.width)
        textWidth = stringSize.width;
    if (textWidth > _pageSize.width)
        textWidth = _pageSize.width - frame.origin.x;
    
    CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    [text drawInRect:renderingRect
            withFont:font
       lineBreakMode:UILineBreakModeWordWrap
           alignment:UITextAlignmentLeft];
    
    frame = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    return frame;
}
-   (CGRect)addLineWithFrame:(CGRect)frame withColor:(UIColor*)color {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(currentContext, color.CGColor);
    // this is the thickness of the line
    CGContextSetLineWidth(currentContext, frame.size.height);
    
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    return frame;
    
}
- (CGRect)addImage:(UIImage*)image atPoint:(CGPoint)point {
    CGRect imageFrame = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [image drawInRect:imageFrame];
    
    return imageFrame;
}






/*---------------------------------
 EXTRA STUFF
 ------------------------------- */
-(UIImage*)imageByRotatingImage:(UIImage*)initImage fromImageOrientation:(UIImageOrientation)orientation
{
    CGImageRef imgRef = initImage.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = orientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            return initImage;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    // Create the bitmap context
    CGContextRef    context = NULL;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (bounds.size.width * 4);
    bitmapByteCount     = (bitmapBytesPerRow * bounds.size.height);
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        return nil;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    CGColorSpaceRef colorspace = CGImageGetColorSpace(imgRef);
    context = CGBitmapContextCreate (bitmapData,bounds.size.width,bounds.size.height,8,bitmapBytesPerRow,
                                     colorspace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    if (context == NULL)
        // error creating context
        return nil;
    
    CGContextScaleCTM(context, -1.0, -1.0);
    CGContextTranslateCTM(context, -bounds.size.width, -bounds.size.height);
    
    CGContextConcatCTM(context, transform);
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(context, CGRectMake(0,0,width, height), imgRef);
    
    CGImageRef imgRef2 = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    free(bitmapData);
    UIImage * image = [UIImage imageWithCGImage:imgRef2 scale:initImage.scale orientation:UIImageOrientationUp];
    CGImageRelease(imgRef2);
    return image;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)clearTmpDirectory
{
    NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    for (NSString *file in tmpDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
    }
}


@end
