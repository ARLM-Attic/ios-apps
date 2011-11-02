//
//  SiteDetailViewController.m
//  SecurePasswords
//
//  Created by mac on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SiteDetailViewController.h"


@implementation SiteDetailViewController

@synthesize site;
@synthesize siteTextField;
@synthesize userNameTextField;
@synthesize passwordTextField;
@synthesize noteTextField;
@synthesize scrollView;
@synthesize backgroundButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //create button for saving sites
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];

    //create button for cancelling edits
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    //keyboard notifications get keyboard size
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeShown:) name:UIKeyboardWillShowNotification object:nil];

    //keyboard notifications when keyboard is hidden
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //must be set for scrolling to work
    scrollView.contentSize = backgroundButton.bounds.size;
}

//update site objet with new values and close screen
- (IBAction) save:(id)sender
{
    site.site = siteTextField.text;
    site.userName = userNameTextField.text;
    site.password = passwordTextField.text;
    site.note = noteTextField.text;

    [self textFieldDone:sender];
    [self.navigationController popViewControllerAnimated:YES];
}

//close screen without updating site object
- (IBAction) cancel:(id)sender
{
    [self textFieldDone:sender];
    [self.navigationController popViewControllerAnimated:YES];
}

//remove keyboard
- (IBAction)textFieldDone:(id)sender
{
    [siteTextField resignFirstResponder];
    [userNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [noteTextField resignFirstResponder];
}

//update text fields with site data
-(void) viewWillAppear:(BOOL)animated
{
    siteTextField.text = [site site];
    userNameTextField.text = [site userName];
    passwordTextField.text = [site password];
    noteTextField.text = [site note];    
}

// Called when the UIKeyboardDidShowNotification is sent. Store keyboard size
- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
    //get keyboard size
    NSDictionary* info = [aNotification userInfo];
    kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self scrollViewToFitActiveField];  //must be done here if this is the first time keyboard is shown

}

// Called when the UIKeyboardDidShowNotification is sent. Store keyboard size
- (void)keyboardDidHide:(NSNotification*)aNotification
{
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
   
}

//step through text fields as they are filled
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    if( textField == siteTextField ) {
        [userNameTextField becomeFirstResponder];
    }
    else if(textField == userNameTextField) {
        [passwordTextField becomeFirstResponder];        
    }
    else if(textField == passwordTextField) {
        [noteTextField becomeFirstResponder];        
    }
    else {
        [textField resignFirstResponder]; 
    }
    return YES; 
}

//keep track of textfield being edited
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    [self scrollViewToFitActiveField];  //must be done here if user moves from one field to the next
}

//reset scrollpane offset
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    activeField = nil;
}

//keep track of textfield being edited
- (void)textViewDidBeginEditing:(UITextView *)textField
{
    activeField = textField;
    [self scrollViewToFitActiveField];  //must be done here if user moves from one field to the next
}

//reset scrollpane offset
- (void)textViewDidEndEditing:(UITextView *)textField
{
//    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    activeField = nil;
}

// If active text field is hidden by keyboard, scroll it so it's visible
-(void) scrollViewToFitActiveField
{
    CGRect aRect = scrollView.frame;
    aRect.size.height -= self.interfaceOrientation==UIInterfaceOrientationPortrait?kbSize.height:kbSize.width;
    
    //test if bottom of field is visible
    CGPoint activePoint = activeField.frame.origin;
    activePoint.y += activeField.frame.size.height;
    if (!CGRectContainsPoint(aRect, activePoint) ) {
        CGPoint scrollPoint = CGPointMake(0.0, -aRect.size.height + activeField.frame.origin.y + activeField.frame.size.height +2);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    site = nil;
    siteTextField = nil;
    userNameTextField = nil;
    passwordTextField = nil;
    noteTextField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


@end
