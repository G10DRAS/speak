//
//  ViewController.m
//  Voice
//
//  Created by Shalin Shah on 7/26/14.
//  Copyright (c) 2014 Shalin Shah. All rights reserved.
//

#import "ViewController.h"
#import "SBJson4.h"

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
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];

    self.imageView.image = nil;
    
    // Initialize Langauges for LanguagePicker
    _languagePickerData = @[@"Arabic (Saudi Arabia)", @"Chinese (China)", @"Chinese (Hong Kong)", @"Chinese (Taiwan)", @"Czech (Czech Republic)", @"Danish (Denmark)", @"Dutch (Belgium)", @"Dutch (Netherlands)", @"English (Australia)", @"English (Ireland)", @"English (South Africa)", @"English (UK)", @"English (USA)", @"Finnish (Finland)", @"French (Canada)", @"French (France)", @"German (Germany)", @"Greek (Greece)", @"Hindi (India)", @"Hungarian (Hungary)", @"Indonesian (Indonesia)", @"Italian (Italy)", @"Japanese (Japan)", @"Korean (South Korea)", @"Norwegian (Norway)", @"Polish (Poland)", @"Portuguese (Brazil)", @"Portuguese (Portugal)", @"Romanian (Romania)", @"Russian (Russia)", @"Slovak (Slovakia)", @"Spanish (Mexico)", @"Spanish (Spain)", @"Swedish (Sweden)", @"Thai (Thailand)", @"Turkish (Turkey)"];
    self.languagePicker.dataSource = self;
    self.languagePicker.delegate = self;
    
    // Initialize Data for UIPickerView
    _pickerData = @[@"Camera", @"Photos Library"];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
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
    
    self.view.backgroundColor = [UIColor clearColor];
    UIImage *myImage = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"speak", @"speak-568h")];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:myImage]];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView.image = [UIImage imageNamed:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*---------------------------------
 SELECT THE OCR LANGUAGE
 ------------------------------- */

- (IBAction)languageSelection:(id)sender {
    [UIView transitionWithView:self.languagePicker
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    self.languagePicker.hidden = NO;
    
    languageTap = [
                 [UITapGestureRecognizer alloc]
                 initWithTarget: self
                 action: @selector(whichLanguage:)
                 ];
    [languageTap setCancelsTouchesInView:NO];
    [[self view] addGestureRecognizer: languageTap];
}

- (void) whichLanguage:(id)sender {
    [[self view] removeGestureRecognizer:languageTap];
    self.languagePicker.hidden = YES;
    [self.languagePicker resignFirstResponder];
    
    NSString *languageForOCR;
    NSString *languageForTTS;
    
    if ([pickerRowName isEqualToString:@"Arabic (Saudi Arabia)"]) {
        languageForOCR = @"ar";
        languageForTTS = @"ar-SA";
    } else if ([pickerRowName isEqualToString:@"Chinese (China)"]) {
        languageForOCR = @"zh";
        languageForTTS = @"zh-CN";
    } else if ([pickerRowName isEqualToString:@"Chinese (Hong Kong)"]) {
        languageForOCR = @"zh";
        languageForTTS = @"zh-HK";
    } else if ([pickerRowName isEqualToString:@"Chinese (Taiwan)"]) {
        languageForOCR = @"zh";
        languageForTTS = @"zh-TW";
    } else if ([pickerRowName isEqualToString:@"Czech (Czech Republic)"]) {
        languageForOCR = @"cs";
        languageForTTS = @"cs-CZ";
    } else if ([pickerRowName isEqualToString:@"Danish (Denmark)"]) {
        languageForOCR = @"da";
        languageForTTS = @"da-DK";
    } else if ([pickerRowName isEqualToString:@"Dutch (Belgium)"]) {
        languageForOCR = @"nl";
        languageForTTS = @"nl-BE";
    } else if ([pickerRowName isEqualToString:@"Dutch (Netherlands)"]) {
        languageForOCR = @"nl";
        languageForTTS = @"nl-NL";
    } else if ([pickerRowName isEqualToString:@"English (Australia)"]) {
        languageForOCR = @"en";
        languageForTTS = @"en-AU";
    } else if ([pickerRowName isEqualToString:@"English (Ireland)"]) {
        languageForOCR = @"en";
        languageForTTS = @"en-IE";
    } else if ([pickerRowName isEqualToString:@"English (South Africa)"]) {
        languageForOCR = @"en";
        languageForTTS = @"en-ZA";
    } else if ([pickerRowName isEqualToString:@"English (UK)"]) {
        languageForOCR = @"en";
        languageForTTS = @"en-GB";
    } else if ([pickerRowName isEqualToString:@"English (USA)"]) {
        languageForOCR = @"en";
        languageForTTS = @"en-US";
    } else if ([pickerRowName isEqualToString:@"Finnish (Finland)"]) {
        languageForOCR = @"fi";
        languageForTTS = @"fi-FI";
    } else if ([pickerRowName isEqualToString:@"French (Canada)"]) {
        languageForOCR = @"fr";
        languageForTTS = @"fr-CA";
    } else if ([pickerRowName isEqualToString:@"French (France)"]) {
        languageForOCR = @"fr";
        languageForTTS = @"fr-FR";
    } else if ([pickerRowName isEqualToString:@"German (Germany)"]) {
        languageForOCR = @"de";
        languageForTTS = @"de-DE";
    } else if ([pickerRowName isEqualToString:@"Greek (Greece)"]) {
        languageForOCR = @"el";
        languageForTTS = @"el-GR";
    } else if ([pickerRowName isEqualToString:@"Hindi (India)"]) {
        languageForOCR = @"hi";
        languageForTTS = @"hi-IN";
    } else if ([pickerRowName isEqualToString:@"Hungarian (Hungary)"]) {
        languageForOCR = @"hu";
        languageForTTS = @"hu-HU";
    } else if ([pickerRowName isEqualToString:@"Indonesian (Indonesia)"]) {
        languageForOCR = @"id";
        languageForTTS = @"id-ID";
    } else if ([pickerRowName isEqualToString:@"Italian (Italy)"]) {
        languageForOCR = @"it";
        languageForTTS = @"it-IT";
    } else if ([pickerRowName isEqualToString:@"Japanese (Japan)"]) {
        languageForOCR = @"ja";
        languageForTTS = @"ja-JP";
    } else if ([pickerRowName isEqualToString:@"Korean (South Korea)"]) {
        languageForOCR = @"ko";
        languageForTTS = @"ko-KR";
    } else if ([pickerRowName isEqualToString:@"Norwegian (Norway)"]) {
        languageForOCR = @"no";
        languageForTTS = @"no-NO";
    } else if ([pickerRowName isEqualToString:@"Polish (Poland)"]) {
        languageForOCR = @"pl";
        languageForTTS = @"pl-PL";
    } else if ([pickerRowName isEqualToString:@"Portuguese (Brazil)"]) {
        languageForOCR = @"pt";
        languageForTTS = @"pt-BR";
    } else if ([pickerRowName isEqualToString:@"Portuguese (Portugal)"]) {
        languageForOCR = @"pt";
        languageForTTS = @"pt-PT";
    } else if ([pickerRowName isEqualToString:@"Romanian (Romania)"]) {
        languageForOCR = @"ro";
        languageForTTS = @"ro-RO";
    } else if ([pickerRowName isEqualToString:@"Russian (Russia)"]) {
        languageForOCR = @"ru";
        languageForTTS = @"ru-RU";
    } else if ([pickerRowName isEqualToString:@"Slovak (Slovakia)"]) {
        languageForOCR = @"sk";
        languageForTTS = @"sk-SK";
    } else if ([pickerRowName isEqualToString:@"Spanish (Mexico)"]) {
        languageForOCR = @"es";
        languageForTTS = @"es-MX";
    } else if ([pickerRowName isEqualToString:@"Spanish (Spain)"]) {
        languageForOCR = @"es";
        languageForTTS = @"es-ES";
    } else if ([pickerRowName isEqualToString:@"Swedish (Sweden)"]) {
        languageForOCR = @"sv";
        languageForTTS = @"sv-SE";
    } else if ([pickerRowName isEqualToString:@"Thai (Thailand)"]) {
        languageForOCR = @"th";
        languageForTTS = @"th-TH";
    } else if ([pickerRowName isEqualToString:@"Turkish (Turkey)"]) {
        languageForOCR = @"tr";
        languageForTTS = @"tr-TR";
    } else {
        languageForOCR = @"en";
        languageForTTS = @"en-US";
    }
    NSLog(@"%@", languageForOCR);
    NSLog(@"%@", languageForTTS);
    [[NSUserDefaults standardUserDefaults] setObject:languageForTTS forKey:@"languageForTTS"];
    [[NSUserDefaults standardUserDefaults] setObject:languageForOCR forKey:@"languageForOCR"];
}


/*---------------------------------
 GET THE PHOTO(S) FROM USER
 ------------------------------- */
- (IBAction)takePhoto:(id)sender {
    
    [UIView transitionWithView:self.picker
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    self.picker.hidden = NO;
    
    singleTap = [
                                         [UITapGestureRecognizer alloc]
                                         initWithTarget: self
                                         action: @selector(chooseWhichCamAction:)
                                         ];
    [singleTap setCancelsTouchesInView:NO];
    [[self view] addGestureRecognizer: singleTap];
}
- (void) chooseWhichCamAction:(id)sender {
    [[self view] removeGestureRecognizer:singleTap];
    self.picker.hidden = YES;
    [self.picker resignFirstResponder];
    if ([pickerRowName isEqualToString:@"Camera"]) {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ? UIImagePickerControllerSourceTypeCamera :  UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else if ([pickerRowName isEqualToString:@"Photos Library"]) {
//        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
//        picker.delegate = self;
//        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        
//        picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
//        [self presentViewController:picker animated:YES completion:nil];
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        
        elcPicker.maximumImagesCount = 10;
        elcPicker.returnsOriginalImage =YES; //Only return the fullScreenImage, not the fullResolutionImage
        elcPicker.imagePickerDelegate = self;
        elcPicker.onOrder = YES;
        [self presentViewController:elcPicker animated:YES completion:nil];
        
    } else {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ? UIImagePickerControllerSourceTypeCamera :  UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    pickerRowName = nil;
}

//
//
// Image Picker Delegate Methods
//
//

// If mult. images picked from photos library
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
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
    UIImage *myScaledImage = [self imageWithImage:self.imageView.image scaledToSize:CGSizeMake(self.imageView.image.size.width * .3, self.imageView.image.size.height * .3)];
    self.imageView.image = myScaledImage;
    
    // Create path for image.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
    
    // Save image to disk.
    [UIImagePNGRepresentation(self.imageView.image) writeToFile:imagePath atomically:YES];
    NSLog(@"%@", imagePath);

}

// If image taken from camera within the app
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *myScaledImage = [self imageWithImage:self.imageView.image scaledToSize:CGSizeMake(self.imageView.image.size.width * .3, self.imageView.image.size.height * .3)];
    self.imageView.image = myScaledImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    imagePath = [documentsDirectory stringByAppendingPathComponent:@"latest_photo.png"];
    
    //extracting image from the picker and saving it
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        NSData *webData = UIImagePNGRepresentation(self.imageView.image); //(self.imageView.image);
        [webData writeToFile:imagePath atomically:YES];
    }
    NSLog(@"%@", imagePath);
}

//
//
// The Options Picker Delegate Methods
//
//

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return ( pickerView == self.picker ? _pickerData.count: _languagePickerData.count);
}
// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return ( pickerView == self.picker ? _pickerData[row]: _languagePickerData[row]);
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSAttributedString *attString;
    if (pickerView == self.picker) {
        attString = [[NSAttributedString alloc] initWithString:[_pickerData objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    } else {
        attString = [[NSAttributedString alloc] initWithString:[_languagePickerData objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    return attString;
}
// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.picker) {
        pickerRowName = [NSString stringWithFormat:@"%@", [_pickerData objectAtIndex:row]];
    } else {
        pickerRowName = [NSString stringWithFormat:@"%@", [_languagePickerData objectAtIndex:row]];
    }
    NSLog(@"%@", pickerRowName);
}

/*---------------------------------
 PROCESS THE PHOTO (OCR)
 ------------------------------- */
- (IBAction)recognizePhoto:(id)sender {
    if (self.imageView.image == nil) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Take A Picture"
                                  message:@"You have to take a picture first before we can start reading it to you."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        [self startLoading];
        
        unsigned long long size = [[NSFileManager defaultManager] attributesOfItemAtPath:imagePath error:nil].fileSize;
        NSLog(@"Size %llu", size);
        
        // POST request to Google Drive
        NSData *file1Data = [[NSData alloc] initWithContentsOfFile:imagePath];
        NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/upload/drive/v2/files?uploadType=media&convert=true&ocr=true&ocrLanguage=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"languageForOCR"]];

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
        NSLog(@"Uploaded to Google Drive");
        [self getFile];
    }
}

/*---------------------------------
 NAVIGATION
 ------------------------------- */

-(void) moveToTalkView {
    UIViewController *myNext = [self.storyboard instantiateViewControllerWithIdentifier:@"TalkView"];
    [self.navigationController pushViewController:myNext animated:YES];
}
- (IBAction)helpPressed:(id)sender {
    UIViewController *myNext = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialView"];
    [self.navigationController pushViewController:myNext animated:YES];
}
/*---------------------------------
 EXTRA STUFF
 ------------------------------- */
-(void)startLoading
{
    loading = [[UIAlertView alloc]
               initWithTitle:@"Processing Image..."
               message:nil
               delegate:self
               cancelButtonTitle:nil
               otherButtonTitles:nil];
    [loading show];
}
-(void)stopLoading {
    [loading dismissWithClickedButtonIndex:0 animated:YES];
}

+ (NSString*)globalToken {
    return hardCodedToken;
}

/*
 THIS MAKES THE OCR'S IMAGE READING MORE ACCURATE AND WORK FASTER
 */

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end