//
//  ViewController.m
//  OCRSDKDemo
//
//  Created by Shalin Shah on 5/2/14.
//  Copyright (c) 2014 ABBYY. All rights reserved.
//

#import "ViewController.h"
#import "SBJson4.h"
#import "UIImage+Grayscale.h"

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
    
    // Getting a new Access Token each time user opens the app
    NSString *data = [NSString stringWithFormat:@"&client_id=438231029903-9ve0hmokgvv3cbtidj0ousq94j4g7akv.apps.googleusercontent.com&client_secret=VKasD9vBIfxScguFcSLCvS-c&refresh_token=1/IG_uAZ0G1zuuvJT5XFl5P2Sie1F5RMJQf53vwniPfZQ&grant_type=refresh_token"];
    
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
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.sourceType = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ? UIImagePickerControllerSourceTypeCamera :  UIImagePickerControllerSourceTypePhotoLibrary;
	imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
	imagePicker.allowsEditing = NO;
	imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (IBAction)recognizePhoto:(id)sender {
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
        NSLog(@"Error getting %@, HTTP status code %i", plainTextURL, [responseCode statusCode]);
    }
    
    self.textViewController = [[SpeakViewController alloc] initWithNibName:nil bundle:nil];
    self.textViewController.text = [[NSString alloc] initWithString:actualText];
    [self moveToSpeakView];
    
    NSLog(@"%@",[[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding]);
    
    [self stopLoading];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *grayscaleImg = [self.imageView.image convertToGrayscale];

    self.imageView.image = grayscaleImg;

	[picker dismissViewControllerAnimated:YES completion:nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    imagePath = [documentsDirectory stringByAppendingPathComponent:@"latest_photo.jpg"];

    //extracting image from the picker and saving it
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        NSData *webData = UIImageJPEGRepresentation(self.imageView.image, 0.5); //(self.imageView.image);
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
             message:@"\n"
             delegate:self
             cancelButtonTitle:nil
             otherButtonTitles:nil];
    [loading show];
}
-(void)stopLoading {
    [loading dismissWithClickedButtonIndex:0 animated:YES];
}

-(void) moveToSpeakView {
    UIViewController *myNext = [self.storyboard instantiateViewControllerWithIdentifier:@"SpeakView"];
    [self.navigationController pushViewController:myNext animated:YES];
}



/*
 
 THESE MAKE TESSERACT'S IMAGE READING MORE ACCURATE AND WORK BETTER
 (IT MAY ALSO MAKE IT SLOWER, BUT NOT NECESSARILY)
 
 */


@end