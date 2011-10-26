//
//  TableRowDetailEditController.m
//  Youpon
//
//  Created by Garrison on 8/4/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import "TableRowDetailEditController.h"


@implementation TableRowDetailEditController

@synthesize data;
@synthesize keyPath;
@synthesize rowLabel;


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
    [data release];
    [keyPath release];
    [rowLabel release];
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
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveEditedDataLocally)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
    
    [super viewWillAppear:animated];
}


#pragma mark - Custom methods

-(IBAction)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)saveEditedDataLocally {
    //Throw an exception - this is an abstract method, should be implemented by subclass
    NSException *ex = [NSException exceptionWithName:@"Abstract Method Not Overridden" reason:@"You MUST override the save method" userInfo:nil];
    [ex raise];
}


@end
