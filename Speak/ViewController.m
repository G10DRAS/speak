//
//  ViewController.m
//  OCRSDKDemo
//
//  Created by Shalin Shah on 5/2/14.
//  Copyright (c) 2014 ABBYY. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
    self.imageView.image = [UIImage imageNamed:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
	[self presentModalViewController:imagePicker animated:YES];
}

- (IBAction)recognizePhoto:(id)sender {
    self.alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Authorizing...", @"Authorizing...")
												message:@"\n\n"
											   delegate:self
									  cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
									  otherButtonTitles:nil];
	
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[self.alertView addSubview:activityIndicator];
	[self.alertView show];
	activityIndicator.center = CGPointMake(self.alertView.bounds.size.width / 2, self.alertView.bounds.size.height - 90);
	
	[activityIndicator startAnimating];
    
    tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    //[tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"];
    [tesseract setImage:[UIImage imageNamed:@"image_sample.jpg"]];
    [tesseract recognize];
    
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.5);

    
    NSLog(@"%@", [tesseract recognizedText]);
	

}


- (void)showError:(NSError *)error
{
	if (error.code != NSURLErrorCancelled) {
		[self.alertView dismissWithClickedButtonIndex:-1 animated:YES];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
														message:[error localizedDescription]
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok")
											  otherButtonTitles:nil];
		
		[alert show];
	}
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
	[picker dismissModalViewControllerAnimated:YES];
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
