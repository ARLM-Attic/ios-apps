//
//  RootViewController.h
//  SecurePasswords
//
//  Created by mac on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteDetailViewController.h"

@interface PasswordListController : UITableViewController {
    NSMutableArray *passwordList;
    SiteDetailViewController *detailViewController;
    UIBarButtonItem *addButton;
}

@property(nonatomic, retain) NSMutableArray *passwordList;

-(SiteDetailViewController*)getDetailViewController;

- (IBAction) add:(id)sender;

@end
