//
//  TutorialViewController.m
//  Her
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
    [[NSUserDefaults standardUserDefaults] setInteger:20 forKey:@"isFirstTimeInt"];
    
    NSLog(@"Tut View");
    [super viewDidLoad];
    [self showIntroWithCrossDissolve];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}
- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = nil;
    page1.desc = nil;
    page1.titleIconView = nil;
    UIImage *bg1 = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"1", @"1-568h")];
    page1.bgImage = [UIImage imageNamed:@"1.png"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = nil;
    page2.desc = nil;
    page2.titleIconView = nil;
    UIImage *bg2 = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"1", @"1-568h")];
    page2.bgImage = [UIImage imageNamed:@"2.png"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = nil;
    page3.desc = nil;
    page3.titleIconView = nil;
    UIImage *bg3 = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"1", @"1-568h")];
    page3.bgImage = [UIImage imageNamed:@"3.png"];

    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = nil;
    page4.desc = nil;
    page4.titleIconView = nil;
    UIImage *bg4 = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"1", @"1-568h")];
    page4.bgImage = [UIImage imageNamed:@"4.png"];
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.title = nil;
    page5.desc = nil;
    page5.titleIconView = nil;
    UIImage *bg5 = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"1", @"1-568h")];
    page5.bgImage = [UIImage imageNamed:@"5.png"];

    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4,page5]];
    
    intro.pageControlY = 40.0f;
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btn setFrame:CGRectMake((320-230)/2, [UIScreen mainScreen].bounds.size.height - 60, 230, 40)];
//    [btn setTitle:@"SKIP NOW" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btn.layer.borderWidth = 2.0f;
//    btn.layer.cornerRadius = 10;
//    btn.layer.borderColor = [[UIColor whiteColor] CGColor];
    intro.skipButton = nil;
    
    [intro setDelegate:self];
    
    [intro showInView:self.view animateDuration:0.5];
}

- (void)introDidFinish:(EAIntroView *)introView {
    NSLog(@"introDidFinish callback");
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"firstTime"];
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