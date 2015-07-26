//
//  LanguageTableViewController.h
//  Voice
//
//  Created by Shalin Shah on 7/23/15.
//  Copyright (c) 2015 Shalin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LanguageTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *tableData;
    NSIndexPath* checkedIndexPath;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;

@end
