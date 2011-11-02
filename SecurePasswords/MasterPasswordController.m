//
//  MasterPasswordController.m
//  SecurePasswords
//
//  Created by mac on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MasterPasswordController.h"
#import "../ZipArchive/ZipArchive.h"
#import "Site.h"

#define PASSWORD_FILE @"SecurePasswords.zip"

@implementation MasterPasswordController

@synthesize masterPassword;
@synthesize status;
@synthesize newMasterPassword;
@synthesize repeatMasterPassword;
@synthesize createPasswordView;
@synthesize enterPasswordView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Lock";
    //move views for entering and creating passwords to same position, this allows the NIB file to have them in different positions for easier editing
    CGRect frame = enterPasswordView.frame;
    frame.origin.y = 0;
    enterPasswordView.frame = frame;
    frame = createPasswordView.frame;
    frame.origin.y = 0;
    createPasswordView.frame = frame;
    
    //make sure passwords are saved if app goes to background
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savePasswords) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
}

//check if passwords file exists, and if not allow user to create one, else if listview exists save the file
-(void) viewDidAppear:(BOOL)animated
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    passwordFilePath = [[documentsDirectory stringByAppendingPathComponent:PASSWORD_FILE] copy];
    NSLog(passwordFilePath, nil);
    [self showPasswordViews];
    status.text = nil;
    
    //might need to save if returned from list, the method will only save if they could have been edited.
    [self savePasswords];
    
}

//determine if view for creating new password file should be shown
-(void) showPasswordViews
{
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:passwordFilePath];
    createPasswordView.hidden = fileExists;
    enterPasswordView.hidden = !fileExists;
}


//called when the user taps the create button
//Creates a new zip file for passwords
- (IBAction)create:(id)sender
{
    if( [newMasterPassword.text length] <= 0)
    {
        status.text = @"You must enter a new master password";
        return;
    }
    else if ( ![newMasterPassword.text isEqualToString:repeatMasterPassword.text] )
    {
        status.text = @"Passwords are not equal";
        return;
    }
    currentMasterPassword = newMasterPassword.text;
    
    [self savePasswords:@"dummy"];
    
    //unlock the new password automatically
    self.masterPassword.text = currentMasterPassword;
    [self unlock:sender];
    
}


//create backup of current passwords and save the list
-(void) savePasswords
{
    //must have a master password and have opened the list for there to be anything to save
    if( passwordListController != nil && currentMasterPassword != nil)
    {
        //create backup
        if([[NSFileManager defaultManager] fileExistsAtPath:passwordFilePath])
        {
            [[NSFileManager defaultManager] moveItemAtPath:passwordFilePath toPath:[passwordFilePath stringByReplacingOccurrencesOfString:@".zip" withString:@".bak"] error:nil]; 
        }
        
        //generate xml
        NSMutableString *xml = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"];
        [xml appendFormat:@"<%@>\n", ROOT_ELEMENT];
        
        for( Site *site in passwordListController.passwordList)
        {
            [xml appendString:[site createXml]];
        }
        [xml appendFormat:@"\n</%@>", ROOT_ELEMENT];
        
        //save it
        [self savePasswords:xml];
        [xml release];
    }
}

//save a passwords xml using the current master password
-(void) savePasswords:(NSString *)xml
{
    //create new zip file with password
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile2:passwordFilePath Password:currentMasterPassword];
    [za addDataToZip:[xml dataUsingEncoding:NSUTF8StringEncoding] newname:@"SecurePasswords.xml"];
    [za UnzipCloseFile];
    [za release];   
    
    NSLog(@"password:%@, xml:\n%@", currentMasterPassword, xml);
}

//called when the user taps the unlock button
//Loads the zip file with passwords
- (IBAction)unlock:(id)sender
{
   
    //Open zip file with passwords
    ZipArchive *za = [[ZipArchive alloc] init];
    if ([za UnzipOpenFile: passwordFilePath Password:masterPassword.text]) {
        
        //read the one xml file into memory
        NSArray *files = [za UnzipFileToData];
        NSDictionary *dict = [files objectAtIndex:0];
        NSMutableData *passwordFile = [[dict allValues] objectAtIndex:0];
        
        //check if we got file, if not password is probably incorrect
        if( passwordFile.length > 0 )
        {
            if(currentMasterPassword != nil )
            {
                [currentMasterPassword release];
            }
            currentMasterPassword = [masterPassword.text copy];

            //create controller for list of passwords if not already done
            if( passwordListController == nil)
            {
                passwordListController = [[PasswordListController alloc] init];        
            }
        
            //load from xml
            Site *parser = [[Site alloc]init];
            NSMutableArray *passwordList = [parser parseXml:passwordFile];
            passwordListController.passwordList = passwordList; 
            [passwordList release];
            [parser release];
          
        
            //navigate to password list, but clear password for if we return
            masterPassword.text = nil;
            [self.navigationController pushViewController:passwordListController animated:YES];

        }
        else
        {
            status.text = @"Could not open passwords. Master password correct?";
        }
        [za UnzipCloseFile];

    }
    else {
        status.text = @"Passwords file not found.";
    }
    
    [za release];
    
}

- (IBAction)textFieldDone:(id)sender
{
    [newMasterPassword resignFirstResponder];
    [repeatMasterPassword resignFirstResponder];
    [masterPassword resignFirstResponder];
}







- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{ 
    if( textField == newMasterPassword ) {
        [repeatMasterPassword becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder]; 
	}
    return YES; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.masterPassword = nil;
    self.newMasterPassword = nil;
    self.repeatMasterPassword = nil;
    self.createPasswordView = nil;
    self.enterPasswordView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc
{
    [masterPassword release];
    [currentMasterPassword release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
