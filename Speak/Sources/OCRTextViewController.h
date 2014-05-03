#import <UIKit/UIKit.h>

@interface OCRTextViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;
//@property (weak, nonatomic) IBOutlet UITextView *imageText;

@property (strong, nonatomic) NSString *text;

@end
