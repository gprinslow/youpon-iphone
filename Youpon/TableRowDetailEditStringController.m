//
//  TableRowDetailEditStringController.m
//  Youpon
//
//  Created by Garrison on 8/4/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import "TableRowDetailEditStringController.h"


@implementation TableRowDetailEditStringController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableRowDetailEditStringCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 25)];
        label.textAlignment = UITextAlignmentRight;
        label.tag = kLabelTag;
        UIFont *font = [UIFont boldSystemFontOfSize:14.0];
        label.textColor = kNonEditableTextColor;
        label.font = font;
        [cell.contentView addSubview:label];
        [label release];
        
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 190, 25)];
        
        [cell.contentView addSubview:theTextField];
        theTextField.tag = kTextFieldTag;
        [theTextField release];
    }
    
    // Configure the cell...
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:kLabelTag];
    label.text = rowLabel;
    
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:kTextFieldTag];
    
    NSString *currentValue = [self.data valueForKeyPath:self.keypath];
    
    textField.text = currentValue;
    [textField becomeFirstResponder];
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Custom methods

-(IBAction)saveEditedDataLocally {
    NSUInteger onlyRow[] = {0, 0};
    NSIndexPath *onlyRowPath = [NSIndexPath indexPathWithIndexes:onlyRow length:2];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:onlyRowPath];
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:kTextFieldTag];
    
    [self.data setValue:textField.text forKey:self.keypath];
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
