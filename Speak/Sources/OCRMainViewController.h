#import <UIKit/UIKit.h>
#import "OCRTextViewController.h"
#import "SpeakViewController.h"

@interface OCRMainViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePhoto:(id)sender;
- (IBAction)recognizePhoto:(id)sender;

@property (strong, nonatomic) UIAlertView *alertView;

@property (strong, nonatomic) SpeakViewController *textViewController;

@end
