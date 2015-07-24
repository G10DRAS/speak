//
//  ViewController.m
//  Voice
//
//  Created by Shalin Shah on 7/26/14.
//  Copyright (c) 2014 Shalin Shah. All rights reserved.
//

#import "ViewController.h"
#import "SBJson4.h"
#import "UINavigationController+SGProgress.h"
#import "SGProgressView.h"

@interface ViewController ()

@end

@implementation ViewController


int const maxImagePixelsAmount = 3200000; // 3.2 MP


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self performSelectorInBackground:@selector(runPercentageLoop) withObject:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
    mixpanel = [Mixpanel sharedInstance];

//    self.imageView.image = nil;
    
    // Get the iphone's screen height and width
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    // If no language selected, defualt is english
    NSObject *ocr = [[NSUserDefaults standardUserDefaults] objectForKey:@"languageForOCR"];
    NSObject *tts = [[NSUserDefaults standardUserDefaults] objectForKey:@"languageForTTS"];

    if(ocr == nil || tts == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@"en-US" forKey:@"languageForTTS"];
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"languageForOCR"];
    }
    
    
    // Set the done button and the imageNumber to invisible initially, imageLibrary should be yes
    self.imageNumber.alpha = 0.0;
    self.doneButton.alpha = 0.0;
    self.clearButton.alpha = 0.0;
    self.imageLibrary.alpha = 1.0;
    
    
    // Getting a new Access Token each time user opens the app
    NSString *data = [NSString stringWithFormat:@"&client_id=949987337109-637mnc7ajesdiuthjdubmtkjnsgjrvud.apps.googleusercontent.com&client_secret=XatsSRPBJvS-8vqUd5-wuTKA&refresh_token=1/42-VzBRsbaSf1uO4IpD89pWL9EpJrAAJfsWBBQHZPYg&grant_type=refresh_token"];
    
    NSLog(@"Access token refresh parameters: %@",data);
    NSString *url = [NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/token"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *theConnection;
    theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    receivedData = [[NSMutableData alloc] init];
    isAuthenticating = YES;
    
    // Some UI stuff
    self.view.backgroundColor = [UIColor clearColor];
    UIImage *myImage = [UIImage imageNamed:@"background"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:myImage]];
    
    
    // Nav Bar UI Stuff
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:26.0f];;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Voice", @"");
    [label sizeToFit];
    
    // Custom Image for Back Button on NavBar
    [self.navigationItem setHidesBackButton:YES animated:YES];
    UIButton *leftButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton1 setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    leftButton1.frame = CGRectMake(0, 0, 30, 30);
    leftButton1.accessibilityHint = @"Double-tap to go to the settings menu";
    [leftButton1 addTarget:self action:@selector(moveToSettings) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton1];
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    
    rightButton.accessibilityLabel = [NSString stringWithFormat:@"Flash %s", self.camView.isTorchEnabled ? "On" : "Off"];
    [rightButton addTarget:self action:@selector(torchToggle) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    // NavBar is transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    [super viewDidLoad];
    
    // Clear some arrays
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ImagesArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ImageText"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TemporaryImages"];
    
    // Initialize some stuff
    tempImages = [[NSMutableArray alloc] init];
    
    [[NSUserDefaults standardUserDefaults] synchronize];


    self.imageView.image = [UIImage imageNamed:nil];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    willSpeak = NO;
    
    // Start Cam
    [self.camView setupCameraView];
    [self.camView setEnableBorderDetection:YES];
    [self.camView start];
    
    // Auto or Manual
    [self autoOrManual];
    
    // Timer
    labelUpdaterTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    
    // Set the done button and the imageNumber to invisible initially, imageLibrary should be yes
    self.imageNumber.alpha = 0.0;
    self.doneButton.alpha = 0.0;
    self.clearButton.alpha = 0.0;
    self.imageLibrary.alpha = 1.0;
    
    self.imageNumber.text = [NSString stringWithFormat:@"0"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.camView stop];
    
}

/*---------------------------------
 CAMERA METHODS
 ------------------------------- */


//// Progress Bar

- (void)runPercentageLoop
{
    while (self.camView._imageDetectionConfidence <= 2000.0f)
    {
        [NSThread sleepForTimeInterval:0.1];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController setSGProgressPercentage:((self.camView._imageDetectionConfidence/30)*100)
                                                  andTintColor:[UIColor colorWithRed:255/255.0f green:256/255.0f blue:255/255.0f alpha:1.0f]];
        });
        if(self.camView._imageDetectionConfidence >= 30.0f)
        {
//                [self.navigationController setSGProgressPercentage:0];
        }
    }
}

- (void)cancelPercentageLoop
{
    [self.navigationController cancelSGProgress];
}

- (IBAction)focusRecognized:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        CGPoint location = [sender locationInView:self.camView];
        [self focusIndicatorAnimateToPoint:location];
        [self.camView focusAtPoint:location completionHandler:^
         {
             [self focusIndicatorAnimateToPoint:location];
         }];
    }
}
- (void)focusIndicatorAnimateToPoint:(CGPoint)targetPoint {
    [self.focusIndication setCenter:targetPoint];
    self.focusIndication.alpha = 0.0;
    self.focusIndication.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^
     {
         self.focusIndication.alpha = 1.0;
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.4 animations:^
          {
              self.focusIndication.alpha = 0.0;
          }];
     }];
}
- (void)torchToggle {
    BOOL enable = !self.camView.isTorchEnabled;
    self.camView.enableTorch = enable;
    
    rightButton.accessibilityLabel = [NSString stringWithFormat:@"Flash %s", self.camView.isTorchEnabled ? "On" : "Off"];

}
-(IBAction)cropToggle:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsAuto"] == FALSE) {
        
        // Set the accessibility text for the crop button
        self.cropButton.accessibilityLabel = [NSString stringWithFormat:@"Crop %s", !self.camView.isBorderDetectionEnabled ? "On" : "Off"];
        self.cropButton.accessibilityHint = @"Double tap to toggle";

        BOOL enable = !self.camView.isBorderDetectionEnabled;
        [self changeButton:self.cropButton targetTitle:(enable) ? @"CROP On" : @"CROP Off" toStateEnabled:enable];
        self.camView.enableBorderDetection = enable;
        
    } else {
        [self.camView stop];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't turn off Crop"
                                                        message:@"Can't turn off crop while in automatic photo mode. Switch to manual mode to turn off crop."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
-(void)switchCropDuringTransition {
        BOOL enable = !self.camView.isBorderDetectionEnabled;
        [self changeButton:self.cropButton targetTitle:(enable) ? @"CROP On" : @"CROP Off" toStateEnabled:enable];
    
        self.camView.enableBorderDetection = enable;
}
-(IBAction)switchFilters:(id)sender {
    [self.camView setCameraViewType:(self.camView.cameraViewType == IPDFCameraViewTypeBlackAndWhite) ? IPDFCameraViewTypeNormal : IPDFCameraViewTypeBlackAndWhite];
}
- (void)changeButton:(UIButton *)button targetTitle:(NSString *)title toStateEnabled:(BOOL)enabled{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:(enabled) ? [UIColor colorWithRed:1 green:1 blue:1 alpha:1] : [UIColor whiteColor] forState:UIControlStateNormal];
}

/*---------------------------------
 GET THE PHOTO(S) FROM USER
 ------------------------------- */

- (IBAction)captureClicked:(id)sender
{
    tempImages = [[NSMutableArray alloc]
                  initWithArray:[[NSUserDefaults standardUserDefaults]
                                 objectForKey:@"TemporaryImages"]];
    
    [self.camView captureImageWithCompletionHander:^(id data)
     {
         
         [UIView animateWithDuration:0.4 animations:^
          {
              self.captureButton.alpha = 0.0;
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.4 animations:^
               {
                   self.captureButton.alpha = 1.0;
               }];
          }];

         UIImage *image = ([data isKindOfClass:[NSData class]]) ? [UIImage imageWithData:data] : data;
         NSData *imageData = UIImagePNGRepresentation(image);
         [tempImages addObject:imageData];

         [[NSUserDefaults standardUserDefaults] setObject:tempImages forKey:@"TemporaryImages"];
         [[NSUserDefaults standardUserDefaults] synchronize];

         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"shouldUpdateLabel"];
         
         NSLog(@"%i", (int)[[NSUserDefaults standardUserDefaults] arrayForKey:@"TemporaryImages"].count); // For testing
    }];
}
-(void) autoOrManual {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsAuto"] == FALSE) {
        switchToAuto = false;
        
        [UIView animateWithDuration:0.4 animations:^
         {
             self.captureButton.alpha = 1.0;
         }];
        
    } else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsAuto"] == TRUE) {
        // If not auto-cropping, make it auto-crop
        if (!self.camView.isBorderDetectionEnabled) {
            [self switchCropDuringTransition];
        }
        [UIView animateWithDuration:0.4 animations:^
         {
             self.captureButton.alpha = 0.0;
         }];
    }
}
- (void) readyToRecognize { // done button clicked

    NSMutableArray *imgs = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TemporaryImages"]];
//    for (int i = 0; i < [tempImages count]; i++) {
//        NSData *imageData = UIImagePNGRepresentation([tempImages objectAtIndex:i]);
//        [imgs addObject:imageData];
//    }
    [[NSUserDefaults standardUserDefaults] setObject:imgs forKey:@"ImagesArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    tempImages = [[NSMutableArray alloc]
                  initWithArray:[[NSUserDefaults standardUserDefaults]
                                 objectForKey:@"TemporaryImages"]];
    
    if ([tempImages count] != 0) {
        self.imageView.image = [UIImage imageWithData:[tempImages objectAtIndex:0]];
        
        // Scale the image
        UIImage *myScaledImage = [self imageWithImage:self.imageView.image scaledToSize:CGSizeMake(self.imageView.image.size.width * .3, self.imageView.image.size.height * .3)];
        self.imageView.image = myScaledImage;
        
        // Create path for image.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
        
        // Save image to disk.
        [UIImagePNGRepresentation(self.imageView.image) writeToFile:imagePath atomically:YES];
        NSLog(@"First Image's Path: %@", imagePath);
        
        // Start Processing
        [self recognizePhoto];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ImagesArray"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TemporaryImages"];
        [tempImages removeAllObjects];
    }
}

- (IBAction)imageLibraryClicked:(id)sender {
    [self prepareToSwitchViews];

    [mixpanel track:@"Image Selection" properties:@{
                                                    @"Method": @"Photo Library",
                                                    }];
    
    // clear the array of images
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 10;
    elcPicker.returnsOriginalImage =YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.imagePickerDelegate = self;
    elcPicker.onOrder = YES;
    [self presentViewController:elcPicker animated:YES completion:nil];
    
}

-(IBAction)doneButtonClicked:(id)sender {
    [self readyToRecognize];
}
-(IBAction)clearButtonClicked:(id)sender {
    [self reset];
}

//
//
// Image Picker Delegate Methods
//
//
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self prepareToSwitchViews];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage *photo = [dict objectForKey:UIImagePickerControllerOriginalImage];
                UIImage *image = photo;
                [images addObject:image];
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage *photo = [dict objectForKey:UIImagePickerControllerOriginalImage];
                UIImage *image = photo;
                [images addObject:image];
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }
    NSMutableArray *imgs = [[NSMutableArray alloc] init];
    for (int i = 0; i < [images count]; i++) {
        NSData *imageData = UIImagePNGRepresentation([images objectAtIndex:i]);
        [imgs addObject:imageData];
    }
    [[NSUserDefaults standardUserDefaults] setObject:imgs forKey:@"ImagesArray"];
    
    self.imageView.image = [images objectAtIndex:0];
    
    // Scale the image
    UIImage *myScaledImage = [self imageWithImage:self.imageView.image scaledToSize:CGSizeMake(self.imageView.image.size.width * .8, self.imageView.image.size.height * .8)]; // .8 is also 80% of the image's original quality
    self.imageView.image = myScaledImage;
    
    // Create path for image.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
    
    // Save image to disk.
    [UIImagePNGRepresentation(self.imageView.image) writeToFile:imagePath atomically:YES];
    NSLog(@"First Image's Path: %@", imagePath);
    
    // Start Processing
    [self recognizePhoto];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*---------------------------------
 PROCESS THE PHOTO (OCR)
 ------------------------------- */
- (void)recognizePhoto {
        [self startLoading];
    
        NSMutableArray *sizeArray = [[NSMutableArray alloc] init];
        NSMutableArray *imageArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ImagesArray"]];
        
        for (int i = 0; i < [imageArray count]; i++) {
            // Create path for image.
            imagePathSize = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"image_for_size.png"];
            
            // Save image to disk.
            [[imageArray objectAtIndex:i] writeToFile:imagePathSize atomically:YES];
            
            // Get the image size
            unsigned long long size = [[NSFileManager defaultManager] attributesOfItemAtPath:imagePathSize error:nil].fileSize;
            [sizeArray addObject:[NSString stringWithFormat:@"%llu",size]];
            
            // Delete the image afterwards
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *pngFilePath = [docDir stringByAppendingPathComponent:imagePathSize];
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:pngFilePath error:&error];
            
            // Track the size with MixPanel
            NSString *mixpanelString = [NSString stringWithFormat:@"%@", [sizeArray objectAtIndex:i]];
            
            [mixpanel track:@"Image Sizes" properties:@{
                                                        @"Size": mixpanelString,
                                                        }];
        }
        NSString *recogNum = [NSString stringWithFormat:@"%i", (int)[imageArray count]];
        NSString *recogDate = [NSString stringWithFormat:@"%@", [NSDate date]];

        [mixpanel track:@"Recognition" properties:@{
                                               @"Image Count": recogNum,
                                               @"Date of Recognition" : recogDate,
                                               }];
    
        unsigned long long size = [[NSFileManager defaultManager] attributesOfItemAtPath:imagePath error:nil].fileSize;
        NSLog(@"Size %llu", size);
        
        // POST request to Google Drive
        NSData *file1Data = [[NSData alloc] initWithContentsOfFile:imagePath];
        NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/upload/drive/v2/files?uploadType=media&convert=true&ocr=true&ocrLanguage=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"languageForOCR"]];
        
        NSLog(@"URL TO CHECK: %@",url);

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        
        // Headers
        [request setValue:[NSString stringWithFormat:@"%llu", size] forHTTPHeaderField:@"Content-length"];
        [request setValue:[NSString stringWithFormat:@"Bearer %@", hardCodedToken] forHTTPHeaderField:@"Authorization"];

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
    [request setValue:[NSString stringWithFormat:@"Bearer %@", hardCodedToken] forHTTPHeaderField:@"Authorization"];
    
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
    [request setValue:[NSString stringWithFormat:@"Bearer %@", hardCodedToken] forHTTPHeaderField:@"Authorization"];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    NSString *actualText = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %f", plainTextURL, (float)[responseCode statusCode]);
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:actualText forKey:@"ImageText"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%@",[[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding]);
    
    NSMutableURLRequest *deleteRequest = [[NSMutableURLRequest alloc] init];
    [deleteRequest setHTTPMethod:@"DELETE"];
    [deleteRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/drive/v2/files/%@", imageFileID]]];
    [deleteRequest setValue:[NSString stringWithFormat:@"Bearer %@", hardCodedToken] forHTTPHeaderField:@"Authorization"];
    
    NSData *theResponseData;
    theResponseData = [NSURLConnection sendSynchronousRequest:deleteRequest returningResponse:&responseCode error:&error];
    
    [self stopLoading];
    [self moveToTalkView];
}
// This is for sending get, post, delete, and other types of requests
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (isAuthenticating == YES) {
        [receivedData appendData:data];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        NSLog(@"%@",[dictionary description]);
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[NSString stringWithFormat:@"%@", error]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (isAuthenticating == YES) {
        // get request for google oauth tokens
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:receivedData // step 1
                              options:kNilOptions
                              error:&error];
        
        NSDictionary *contentsOfJSON = [json objectForKey:@"access_token"]; // step 2
        
        hardCodedToken = [NSString stringWithFormat:@"%@", contentsOfJSON];
        isAuthenticating = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:[json objectForKey:@"access_token"] forKey:@"accessToken"];
        
        NSLog(@"access token 2: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]);
    } else {
        // post request after uploading the image
        NSLog(@"Uploaded to Google Drive");
        [mixpanel track:@"Image Uploaded to Google Drive"];

        [self getFile];
    }
}

/*---------------------------------
 NAVIGATION
 ------------------------------- */

-(void) moveToTalkView {
    [mixpanel track:@"Image Converted to Text"];
    [self prepareToSwitchViews];
    UIViewController *myNext = [self.storyboard instantiateViewControllerWithIdentifier:@"TalkView"];
    [self.navigationController pushViewController:myNext animated:YES];
}
-(void) moveToSettings {
    [self prepareToSwitchViews];
    UIViewController *myNext = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsView"];
    [self.navigationController pushViewController:myNext animated:YES];
}
/*---------------------------------
 EXTRA STUFF
 ------------------------------- */
// Alert View Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        if (!willSpeak) {
            [self.camView start];
        }
    }
}

-(void)startLoading
{
    [self.camView stop];
    
    willSpeak = YES;
    loading = [[UIAlertView alloc] initWithTitle:@"Processing Image..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [loading show];
    
    [mixpanel timeEvent:@"Image Upload"];
}
-(void)stopLoading {
    [mixpanel track:@"Image Upload"];

    [loading dismissWithClickedButtonIndex:0 animated:YES];
}
- (void) updateLabel {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"shouldUpdateLabel"] == YES) {
        if (self.imageNumber.alpha != 1.0) {
            [UIView animateWithDuration:0.4 animations:^
             {
                 self.imageNumber.alpha = 1.0;
                 self.doneButton.alpha = 1.0;
                 self.clearButton.alpha = 1.0;
                 self.imageLibrary.alpha = 0.0;
             }];
        }
        self.imageNumber.text = [NSString stringWithFormat:@"%i",
                                 (int)[[NSUserDefaults standardUserDefaults] arrayForKey:@"TemporaryImages"].count];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"shouldUpdateLabel"];
    }
}

-(void) prepareToSwitchViews {
    [labelUpdaterTimer invalidate];
    [self cancelPercentageLoop];
}

-(void) reset {
    [self.camView stop];
    
    [labelUpdaterTimer invalidate];
    
    // Start Cam
    [self.camView setupCameraView];
    [self.camView setEnableBorderDetection:YES];
    [self.camView start];
    
    // Clear some arrays
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ImagesArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ImageText"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TemporaryImages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [tempImages removeAllObjects];
    
    // Set the done button and the imageNumber to invisible initially, imageLibrary should be yes
    [UIView animateWithDuration:0.4 animations:^
     {
         self.imageNumber.alpha = 0.0;
         self.doneButton.alpha = 0.0;
         self.clearButton.alpha = 0.0;
         self.imageLibrary.alpha = 1.0;
         
         self.imageNumber.text = [NSString stringWithFormat:@"0"];
     }];
    
    // Timer
    labelUpdaterTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    
    [self clearTmpDirectory];
}


+ (NSString*)globalToken {
    return hardCodedToken;
}

- (void)clearTmpDirectory
{
    NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    for (NSString *file in tmpDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
    }
}

/*
 THIS MAKES THE OCR'S IMAGE PROCESS FASTER THROUGH COMPRESSION
 */

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end