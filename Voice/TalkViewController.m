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
    
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
//    self.scrollView.contentSize = CGSizeMake(320, 465);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[imageArray count]];
    
//    for (int i = 0; i < [imageArray count]; i++) {
//        UIImage* image = [UIImage imageWithData:[imageArray objectAtIndex:i]];
//        [images addObject:image];
//        
//        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
//        [imageview setContentMode:UIViewContentModeScaleAspectFit];
//        imageview.frame = workingFrame;
//        
//        [self.scrollView addSubview: imageview];
//        workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
//    }
    
    for (UIView *v in [_scrollView subviews]) {
        [v removeFromSuperview];
    }
    
    CGRect workingFrame = CGRectMake (0,0,self.scrollView.frame.size.width,self.scrollView.frame.size.height);
    workingFrame.origin.x = 0;

    
    for (int i = 0; i < [imageArray count]; i++) {
        UIImage *image = [UIImage imageWithData:[imageArray objectAtIndex:i]];
        
        // If the image is in Landscape
        UIImage *hi;
        if (image.size.width > image.size.height) {
//            rotate(image, UIImageOrientationLeft);
//            UIImage *rotatedImage = [image imageRotatedByDegrees:90.0];
            hi = [self imageByRotatingImage:image fromImageOrientation:UIImageOrientationRight];
            NSLog(@"Image is landscape");
        } else {
            hi = [UIImage imageWithData:[imageArray objectAtIndex:i]];
            NSLog(@"Image is portrait");
        }

        [images addObject:hi];
        
        UIImageView *imageview = [[UIImageView alloc] initWithImage:hi];
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.frame = workingFrame;
        
        [_scrollView addSubview:imageview];
        workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
        
        if (hi.size.width > hi.size.height) {
            NSLog(@"Image is now landscape");
        } else {
            NSLog(@"Image is now portrait");
        }

    }
    
    [_scrollView setPagingEnabled:YES];
    [_scrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];

//
    
//    int i=0;
//    for ( NSString *image in imageArray)
//    {
//        UIImage *photos = [UIImage imageWithData:[imageArray objectAtIndex:i]];
//        UIImageView *imageview = [[UIImageView alloc] initWithImage:photos];
//        imageview.contentMode = UIViewContentModeScaleAspectFit;
//        imageview.clipsToBounds = YES;
//        imageview.tag = 1;
//        
//        UIScrollView *scrollingView = [[UIScrollView alloc] initWithFrame:CGRectMake( IMAGE_WIDTH * i++, 0, IMAGE_WIDTH, IMAGE_HEIGHT)];
//        scrollingView.delegate = self;
//        scrollingView.maximumZoomScale = 3.0f;
//        imageview.frame = scrollingView.bounds;
//        [scrollingView addSubview:imageview];
//        
//        [self.scrollView addSubview:scrollingView];
//    }
    
    
//    [self scrollViewInit];
    
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    if ([self canBecomeFirstResponder]) {
        [self becomeFirstResponder];
    }

    
    speechPaused = NO;
    imageNumber = 1;
    speechNumber = 1;
    
    // Some UI stuff
    self.view.backgroundColor = [UIColor clearColor];
    UIImage *myImage = [UIImage imageNamed:@"player"];
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
    
    UIImage *image = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

    
    
//    compressingImage = YES;
    
//    NSLog(@"speakArray: %@", speakArray);

    
    [self startTalking];
    
    NSLog(@"imageArray Count: %d", (int)[imageArray count]);
}


























#pragma mark - NSTimer methods
//- (void) autoScrollTimerTick:(NSTimer *) timer {
//    if (!_scrollView.dragging) {
//        // check if we're on the last suggestion
//        if (_currentPage == imageArray.count - 1) {
//            [_scrollView setContentOffset:CGPointZero animated:YES];
//        }
//        else {
//            [_scrollView setContentOffset:CGPointMake((_currentPage + 1) * _scrollView.bounds.size.width, 0.0f) animated:YES];
//        }
//    }
//}
#pragma mark - UIScrollViewDelegate methods
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat pageWidth = scrollView.bounds.size.width;
//    float fractionalPage = scrollView.contentOffset.x / pageWidth;
//    NSInteger nearestNumber = lround(fractionalPage);
//    
//    if (_currentPage != nearestNumber) {
//        _currentPage = nearestNumber;
//        if (scrollView.dragging) {
//            [_autoScrollTimer invalidate];
//            _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:AutoScrollDuration target:self selector:@selector(autoScrollTimerTick:) userInfo:nil repeats:YES];
//        }
//    }
//}
- (void) scrollViewInit {
    CGRect workingFrame = self.scrollView.frame;
    workingFrame.origin.x = 0;

    _scrollView.delegate=self;
    
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
    
//    _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:AutoScrollDuration target:self selector:@selector(autoScrollTimerTick:) userInfo:nil repeats:YES];
}





























- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([imageArray count] > imageNumber) {
        [self fetchTextFromImage:[imageArray objectAtIndex:imageNumber]];
    }

}

- (void) startTalking {
    speechPaused = NO;
    NSString *imageText = [NSString stringWithFormat:@"%@", [speakArray objectAtIndex:(speechNumber-1)]];
    AVSpeechUtterance* utter = [[AVSpeechUtterance alloc] initWithString:imageText];
    utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"languageForTTS"]];
    [utter setRate:0.1f];
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
    if ([speakArray count] > speechNumber) {
        speechPaused = NO;
        NSString *imageText = [NSString stringWithFormat:@"%@", [speakArray objectAtIndex:speechNumber]];
        AVSpeechUtterance* utter = [[AVSpeechUtterance alloc] initWithString:imageText];
        utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"languageForTTS"]];
        [utter setRate:0.2f];
        if (!self.synthesizer) {
            self.synthesizer = [AVSpeechSynthesizer new];
        }
        self.synthesizer.delegate = self;
        [self.synthesizer speakUtterance:utter];
        speechNumber++;
    } else {
//        dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//        dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
            AVSpeechUtterance* utter = [[AVSpeechUtterance alloc] initWithString:@""];
            utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"languageForTTS"]];
            [utter setRate:0.2f];
            if (!self.synthesizer) {
                self.synthesizer = [AVSpeechSynthesizer new];
            }
            self.synthesizer.delegate = self;
            [self.synthesizer speakUtterance:utter];
//        });
    }
}


/*---------------------------------
 GET TEXT FROM IMAGES
 ------------------------------- */

- (void) fetchTextFromImage: (NSData *)theImage {
//    compressingImage = YES;
    
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
//    if (compressingImage == NO) {
        NSLog(@"Uploaded to Google Drive");
        [self getFile];
//    } else {
//        NSError* error;
//        NSDictionary* json = [NSJSONSerialization
//                              JSONObjectWithData:receivedData // step 1
//                              options:kNilOptions
//                              error:&error];
//        
//        NSDictionary *output = [json objectForKey:@"output"];
//        compressedImageURL = [output objectForKey:@"url"];
//        
//        NSLog(@"The JSON Data: %@", json);
//        
//        [self getCompressedImage];
//    }
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


@end
