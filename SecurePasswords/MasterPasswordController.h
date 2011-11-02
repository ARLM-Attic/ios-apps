//
//  MasterPasswordController.h
//  SecurePasswords
//
//  Created by mac on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordListController.h"

@interface MasterPasswordController : UIViewController<UITextFieldDelegate> {
    PasswordListController *passwordListController;
    NSString *passwordFilePath;
    NSString *currentMasterPassword;
}

@property (nonatomic, retain) IBOutlet UITextField *masterPassword;
@property (nonatomic, retain) IBOutlet UILabel *status;
@property (nonatomic, retain) IBOutlet UITextField *newMasterPassword;
@property (nonatomic, retain) IBOutlet UITextField *repeatMasterPassword;
@property (nonatomic, retain) IBOutlet UIView *createPasswordView;
@property (nonatomic, retain) IBOutlet UIView *enterPasswordView;

- (IBAction) unlock:(id)sender;
- (IBAction) create:(id)sender;
- (IBAction)textFieldDone:(id)sender;
-(void) savePasswords;
-(void) savePasswords:(NSString*)xml;
-(void)showPasswordViews;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end
