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
    
    // Initialize Data for UIPickerView
    _pickerData = @[@"Camera", @"Photos Library"];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    // Getting a new Access Token each time user opens the app
    NSString *data = [NSString stringWithFormat:@"&client_id=949987337109-637mnc7ajesdiuthjdubmtkjnsgjrvud.apps.googleusercontent.com&client_secret=XatsSRPBJvS-8vqUd5-wuTKA&refresh_token=1/m9DHwxkFR6Wm2f2NwOxhBzon6MyoHUl3ohqv7ezV10c&grant_type=refresh_token"];
    
    NSLog(@"Access token refresh parameters: %@",data);
    NSString *url = [NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/token"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    receivedData = [[NSMutableData alloc] init];
    isAuthenticating = YES;
    
    self.view.backgroundColor = [UIColor clearColor];
    UIImage *myImage = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"speak", @"speak-568h")];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:myImage]];
    
    //    }
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
        NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
        
        NSData *file1Data = [[NSData alloc] initWithContentsOfFile:imagePath];
        NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/upload/drive/v2/files?uploadType=media&convert=true&ocr=true&ocrLanguage=en"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        
        // Headers
        [request setValue:[NSString stringWithFormat:@"%llu", size] forHTTPHeaderField:@"Content-length"];
        [request setValue:[NSString stringWithFormat:@"Bearer %@", hardCodedToken] forHTTPHeaderField:@"Authorization"];
        [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[NSData dataWithData:file1Data]];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:body];
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
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
        NSLog(@"Error getting https://www.googleapis.com/drive/v2/files, HTTP status code %i", [responseCode statusCode]);
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
    theOCRText = actualText;
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", plainTextURL, [responseCode statusCode]);
    }
    
    
    NSMutableURLRequest *deleteRequest = [[NSMutableURLRequest alloc] init];
    [deleteRequest setHTTPMethod:@"DELETE"];
    [deleteRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/drive/v2/files/%@", imageFileID]]];
    [deleteRequest setValue:[NSString stringWithFormat:@"Bearer %@", hardCodedToken] forHTTPHeaderField:@"Authorization"];
    
    NSData *theResponseData = [NSURLConnection sendSynchronousRequest:deleteRequest returningResponse:&responseCode error:&error];
    
    self.talkView = [[TalkViewController alloc] initWithNibName:nil bundle:nil];
    self.talkView.text = [[NSString alloc] initWithString:actualText];
    [self moveToTalkView];
    
    NSLog(@"%@",[[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding]);
    
    [self stopLoading];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];

    CGRect screen = [UIScreen mainScreen].bounds;
    UIImage *myScaledImage = [self imageWithImage:self.imageView.image scaledToSize:CGSizeMake(screen.size.width * 2, screen.size.height * 2)];
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (isAuthenticating == YES) {
        [receivedData appendData:data];
    }
}
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
//    if ([response respondsToSelector:@selector(allHeaderFields)]) {
//        NSDictionary *dictionary = [httpResponse allHeaderFields];
//        NSLog(@"%@",[dictionary description]);
//    }
//}
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

-(void) moveToTalkView {
    UIViewController *myNext = [self.storyboard instantiateViewControllerWithIdentifier:@"TalkView"];
    [self.navigationController pushViewController:myNext animated:YES];
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[_pickerData objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickerRowName = [NSString stringWithFormat:@"%@", [_pickerData objectAtIndex:row]];
    NSLog(@"%@", pickerRowName);
}

- (void) chooseWhichCamAction:(id)sender {
    NSLog(@"HIIII");
    self.picker.hidden = YES;
    [self.picker resignFirstResponder];
    if ([pickerRowName isEqualToString:@"Camera"]) {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ? UIImagePickerControllerSourceTypeCamera :  UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
        [[self view] removeGestureRecognizer:singleTap];
    }
    else if ([pickerRowName isEqualToString:@"Photos Library"]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        [self presentViewController:picker animated:YES completion:nil];
        [[self view] removeGestureRecognizer:singleTap];
    } else {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ? UIImagePickerControllerSourceTypeCamera :  UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
        [[self view] removeGestureRecognizer:singleTap];
    }
    pickerRowName = nil;
}

- (IBAction)helpPressed:(id)sender {
    UIViewController *myNext = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialView"];
    [self.navigationController pushViewController:myNext animated:YES];
}

+ (NSString*)globalText {
    return theOCRText;
}
/*
 
 THESE MAKE TESSERACT'S IMAGE READING MORE ACCURATE AND WORK BETTER
 (IT MAY ALSO MAKE IT SLOWER, BUT NOT NECESSARILY)
 
 */

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end