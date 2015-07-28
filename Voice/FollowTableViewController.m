//
//  FollowTableViewController.m
//  
//
//  Created by Shalin Shah on 1/31/15.
//
//

#import "FollowTableViewController.h"

@interface FollowTableViewController ()

@end

@implementation FollowTableViewController

- (void)viewDidLoad {
    // Nav Bar UI Stuff
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:26.0f];;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Follow Us", @"");
    [label sizeToFit];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:@"background"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int website = 1;
    int twitter = 2;
    int facebook = 3;
    
        if (website == indexPath.row) {
            NSURL *url = [[NSURL alloc] initWithString:@"http://www.shalinshah.me/voice"];
            [[UIApplication sharedApplication] openURL:url];
        } else if (twitter == indexPath.row) {
            NSURL *url = [[NSURL alloc] initWithString:@"https://twitter.com/getvoiceios"];
            [[UIApplication sharedApplication] openURL:url];
        } else if (facebook == indexPath.row) {
            NSURL *url = [[NSURL alloc] initWithString:@"https://www.facebook.com/getvoiceios"];
            [[UIApplication sharedApplication] openURL:url];
        }
}

@end
