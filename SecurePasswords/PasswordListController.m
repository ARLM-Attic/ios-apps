//
//  RootViewController.m
//  SecurePasswords
//
//  Created by mac on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PasswordListController.h"
#import "Site.h"

@implementation PasswordListController

@synthesize passwordList;

- (void)viewDidLoad
{
 
    //if password list was not set by previous list create an empty one
/*    if( passwordList == nil) {
        passwordList = [[NSMutableArray alloc] init];
    }        
*/
    //create button for adding sites
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];

    //enable edit button
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Password List";
    [super viewDidLoad];
}

-(void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if(editing) {
        [self.navigationItem setLeftBarButtonItem:addButton animated:YES];
    }
    else {
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    }
}

- (IBAction) add:(id)sender
{
    Site *site = [[Site alloc] init];
    site.site = @"new site";
    [passwordList addObject:site];    
    int index = [passwordList indexOfObject:site];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [site release];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    //reload data to make sure any changes in detail view are being shown
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [passwordList count];
    return count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell.
    cell.textLabel.text = [[passwordList objectAtIndex:indexPath.row] site];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [passwordList removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Pass the selected object to the new view controller.
    [self getDetailViewController].site = [passwordList objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:detailViewController animated:YES];
	
}

//Get the detail view controller for sites or creat it if not previously created
-(SiteDetailViewController*)getDetailViewController
{
    if(detailViewController == nil)
    {
        detailViewController = [[SiteDetailViewController alloc] initWithNibName:@"SiteDetailViewController" bundle:nil];
    }
    return detailViewController;
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    detailViewController = nil;
}

- (void)dealloc
{
    [detailViewController release];
    [addButton release];
    [passwordList release];
    [super dealloc];
}

@end
