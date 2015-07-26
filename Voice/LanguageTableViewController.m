//
//  LanguageTableViewController.m
//  Voice
//
//  Created by Shalin Shah on 7/23/15.
//  Copyright (c) 2015 Shalin Shah. All rights reserved.
//

#import "LanguageTableViewController.h"

@interface LanguageTableViewController ()

@end

@implementation LanguageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    
    
    tableData = [NSArray arrayWithObjects:@"Arabic (Saudi Arabia)", @"Chinese (China)", @"Chinese (Hong Kong)", @"Chinese (Taiwan)", @"Czech (Czech Republic)", @"Danish (Denmark)", @"Dutch (Belgium)", @"Dutch (Netherlands)", @"English (Australia)", @"English (Ireland)", @"English (South Africa)", @"English (UK)", @"English (USA)", @"Finnish (Finland)", @"French (Canada)", @"French (France)", @"German (Germany)", @"Greek (Greece)", @"Hindi (India)", @"Hungarian (Hungary)", @"Indonesian (Indonesia)", @"Italian (Italy)", @"Japanese (Japan)", @"Korean (South Korea)", @"Norwegian (Norway)", @"Polish (Poland)", @"Portuguese (Brazil)", @"Portuguese (Portugal)", @"Romanian (Romania)", @"Russian (Russia)", @"Slovak (Slovakia)", @"Spanish (Mexico)", @"Spanish (Spain)", @"Swedish (Sweden)", @"Thai (Thailand)", @"Turkish (Turkey)", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Languages";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    //Pre-check lang that was already chosen
    
    
    if([self.checkedIndexPath isEqual:indexPath] || indexPath.row == [[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfSelection"])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.font = [UIFont fontWithName:@"Avernir Next Regular" size:17];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Uncheck the previous checked row
    if(self.checkedIndexPath)
    {
        UITableViewCell* uncheckCell = [tableView
                                        cellForRowAtIndexPath:self.checkedIndexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.checkedIndexPath = indexPath;
    
    
    NSString *languageForOCR;
    NSString *languageForTTS;
    
    if ([indexPath row] == 0) {
        languageForOCR = @"ar";
        languageForTTS = @"ar-SA";
    } else if ([indexPath row] == 1) {
        languageForOCR = @"zh";
        languageForTTS = @"zh-CN";
    } else if ([indexPath row] == 2) {
        languageForOCR = @"zh";
        languageForTTS = @"zh-HK";
    } else if ([indexPath row] == 3) {
        languageForOCR = @"zh";
        languageForTTS = @"zh-TW";
    } else if ([indexPath row] == 4) {
        languageForOCR = @"cs";
        languageForTTS = @"cs-CZ";
    } else if ([indexPath row] == 5) {
        languageForOCR = @"da";
        languageForTTS = @"da-DK";
    } else if ([indexPath row] == 6) {
        languageForOCR = @"nl";
        languageForTTS = @"nl-BE";
    } else if ([indexPath row] == 7) {
        languageForOCR = @"nl";
        languageForTTS = @"nl-NL";
    } else if ([indexPath row] == 8) {
        languageForOCR = @"en";
        languageForTTS = @"en-AU";
    } else if ([indexPath row] == 9) {
        languageForOCR = @"en";
        languageForTTS = @"en-IE";
    } else if ([indexPath row] == 10) {
        languageForOCR = @"en";
        languageForTTS = @"en-ZA";
    } else if ([indexPath row] == 11) {
        languageForOCR = @"en";
        languageForTTS = @"en-GB";
    } else if ([indexPath row] == 12) {
        languageForOCR = @"en";
        languageForTTS = @"en-US";
    } else if ([indexPath row] == 13) {
        languageForOCR = @"fi";
        languageForTTS = @"fi-FI";
    } else if ([indexPath row] == 14) {
        languageForOCR = @"fr";
        languageForTTS = @"fr-CA";
    } else if ([indexPath row] == 15) {
        languageForOCR = @"fr";
        languageForTTS = @"fr-FR";
    } else if ([indexPath row] == 16) {
        languageForOCR = @"de";
        languageForTTS = @"de-DE";
    } else if ([indexPath row] == 17) {
        languageForOCR = @"el";
        languageForTTS = @"el-GR";
    } else if ([indexPath row] == 18) {
        languageForOCR = @"hi";
        languageForTTS = @"hi-IN";
    } else if ([indexPath row] == 19) {
        languageForOCR = @"hu";
        languageForTTS = @"hu-HU";
    } else if ([indexPath row] == 20) {
        languageForOCR = @"id";
        languageForTTS = @"id-ID";
    } else if ([indexPath row] == 21) {
        languageForOCR = @"it";
        languageForTTS = @"it-IT";
    } else if ([indexPath row] == 22) {
        languageForOCR = @"ja";
        languageForTTS = @"ja-JP";
    } else if ([indexPath row] == 23) {
        languageForOCR = @"ko";
        languageForTTS = @"ko-KR";
    } else if ([indexPath row] == 24) {
        languageForOCR = @"no";
        languageForTTS = @"no-NO";
    } else if ([indexPath row] == 25) {
        languageForOCR = @"pl";
        languageForTTS = @"pl-PL";
    } else if ([indexPath row] == 26) {
        languageForOCR = @"pt";
        languageForTTS = @"pt-BR";
    } else if ([indexPath row] == 27) {
        languageForOCR = @"pt";
        languageForTTS = @"pt-PT";
    } else if ([indexPath row] == 28) {
        languageForOCR = @"ro";
        languageForTTS = @"ro-RO";
    } else if ([indexPath row] == 29) {
        languageForOCR = @"ru";
        languageForTTS = @"ru-RU";
    } else if ([indexPath row] == 30) {
        languageForOCR = @"sk";
        languageForTTS = @"sk-SK";
    } else if ([indexPath row] == 31) {
        languageForOCR = @"es";
        languageForTTS = @"es-MX";
    } else if ([indexPath row] == 32) {
        languageForOCR = @"es";
        languageForTTS = @"es-ES";
    } else if ([indexPath row] == 33) {
        languageForOCR = @"sv";
        languageForTTS = @"sv-SE";
    } else if ([indexPath row] == 34) {
        languageForOCR = @"th";
        languageForTTS = @"th-TH";
    } else if ([indexPath row] == 35) {
        languageForOCR = @"tr";
        languageForTTS = @"tr-TR";
    }
    
    NSLog(@"%@", languageForOCR);
    NSLog(@"%@", languageForTTS);
    [[NSUserDefaults standardUserDefaults] setObject:languageForTTS forKey:@"languageForTTS"];
    [[NSUserDefaults standardUserDefaults] setObject:languageForOCR forKey:@"languageForOCR"];
    [[NSUserDefaults standardUserDefaults] setInteger:[indexPath row] forKey:@"numberOfSelection"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
