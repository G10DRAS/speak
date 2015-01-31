//
//  TutorialViewController.m
//  Voice
//
//  Created by Shalin Shah on 7/18/14.
//  Copyright (c) 2014 Shalin Shah. All rights reserved.
//

#import "TutorialViewController.h"
#import "SBJson4.h"

@interface TutorialViewController ()

@end

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation TutorialViewController

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

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    
    NSLog(@"Tut View");
    [super viewDidLoad];
    [self showIntroWithCrossDissolve];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}
- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"You take a picture and Voice reads it to you.";
    page1.desc = nil;
    page1.titleColor = [UIColor clearColor];
    page1.titleIconView = nil;
    UIImage *bg1 = [UIImage imageNamed:@"slide1"];

    page1.bgImage = bg1;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"Take a picture of anything with words.";
    page2.desc = nil;
    page2.titleColor = [UIColor clearColor];
    page2.titleIconView = nil;
    UIImage *bg2 = [UIImage imageNamed:@"slide2"];
    page2.bgImage = bg2;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"Voice processes and reads the text.";
    page3.desc = nil;
    page3.titleColor = [UIColor clearColor];
    page3.titleIconView = nil;
    UIImage *bg3 = [UIImage imageNamed:@"slide3"];
    page3.bgImage = bg3;

    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"Multiple pictures can be read one by one.";
    page4.desc = nil;
    page4.titleColor = [UIColor clearColor];
    page4.titleIconView = nil;
    UIImage *bg4 = [UIImage imageNamed:@"slide4"];
    page4.bgImage = bg4;
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.title = @"Point the camera at the text to auto-capture";
    page5.desc = nil;
    page5.titleColor = [UIColor clearColor];
    page5.titleIconView = nil;
    UIImage *bg5 = [UIImage imageNamed:@"slide5"];
    page5.bgImage = bg5;
    
    EAIntroPage *page6 = [EAIntroPage page];
    page6.title = @"Welcome to Voice.";
    page6.desc = nil;
    page6.titleColor = [UIColor clearColor];
    page6.titleIconView = nil;
    UIImage *bg6 = [UIImage imageNamed:@"slide6"];
    page6.bgImage = bg6;


    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4,page5,page6]];
    
    intro.pageControlY = 40.0f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [btn setFrame:CGRectMake((self.view.frame.size.width/2)-115, [UIScreen mainScreen].bounds.size.height - 60, 230, 40)];
    [btn setTitle:@"CONTINUE" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 2.0f;
    btn.layer.cornerRadius = 10;
    btn.layer.borderColor = [[UIColor whiteColor] CGColor];
    btn.accessibilityLabel = @"continue";
    btn.accessibilityHint = @"double-tap to start using voice";
    
    
    intro.skipButton = btn;
    intro.showSkipButtonOnlyOnLastPage = TRUE;
    
    [intro setDelegate:self];
    
    [intro showInView:self.view animateDuration:0.5];
    
    
}

- (void)introDidFinish:(EAIntroView *)introView {
    NSLog(@"introDidFinish callback");
    [[NSUserDefaults standardUserDefaults] setInteger:20 forKey:@"isFirstTimeInt"];
    [self moveToMain];
}

-(void) moveToMain {
    UIViewController *myNext = [self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    [self.navigationController pushViewController:myNext animated:YES];
}

-(void) moveToAccount {
    UIViewController *myNext = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountView"];
    [self.navigationController pushViewController:myNext animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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