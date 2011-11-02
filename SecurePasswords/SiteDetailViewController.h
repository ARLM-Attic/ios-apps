//
//  SiteDetailViewController.h
//  SecurePasswords
//
//  Created by mac on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Site.h"

@interface SiteDetailViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate> {
    UIView *activeField;
    CGSize kbSize;
}


@property(nonatomic, retain) Site *site;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) IBOutlet UITextField *siteTextField;
@property(nonatomic, retain) IBOutlet UITextField *userNameTextField;
@property(nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property(nonatomic, retain) IBOutlet UITextView *noteTextField;
@property(nonatomic, retain) IBOutlet UIButton *backgroundButton;

- (IBAction) save:(id)sender;
- (IBAction) cancel:(id)sender;
- (IBAction)textFieldDone:(id)sender;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (void)textViewDidBeginEditing:(UITextView *)textField;
- (void)textViewDidEndEditing:(UITextView *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
-(void) scrollViewToFitActiveField;
@end
