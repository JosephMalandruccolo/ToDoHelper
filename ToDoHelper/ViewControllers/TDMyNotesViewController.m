//
//  TDMyNotesViewController.m
//  ToDoHelper
//
//  Created by Joseph Malandruccolo on 5/27/13.
//  Copyright (c) 2013 Joseph Malandruccolo. All rights reserved.
//


NSString * const    kNotePreviewCellIdentifier = @"note preview cell";


#import "TDMyNotesViewController.h"

@interface TDMyNotesViewController ()

@property (nonatomic, retain) DBFilesystem *filesystem;
@property (nonatomic, retain) DBPath *root;
@property (nonatomic, retain) NSMutableArray *contents;
@property (nonatomic, assign) BOOL creatingFolder;
@property (nonatomic, retain) DBPath *fromPath;
@property (nonatomic, retain) UITableViewCell *loadingCell;
@property (nonatomic, assign) BOOL loadingFiles;
@property (nonatomic, assign, getter=isMoving) BOOL moving;

@end

@implementation TDMyNotesViewController


#pragma mark - life cycle
- (id)initWithFilesystem:(DBFilesystem *)filesystem root:(DBPath *)root {
	if ((self = [super init])) {
		self.filesystem = filesystem;
		self.root = root;
		self.navigationItem.title = [root isEqual:[DBPath root]] ? @"Dropbox" : [root name];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	__weak TDMyNotesViewController *weakSelf = self;
	[_filesystem addObserver:self block:^() { [weakSelf reload]; }];
	[_filesystem addObserver:self forPathAndChildren:self.root block:^() { [weakSelf loadFiles]; }];
	[self.navigationController setToolbarHidden:NO];
	[self loadFiles];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[_filesystem removeObserver:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark - private helpers
- (void)reload
{
	[self.tableView reloadData];
}

- (void)loadFiles {
	if (_loadingFiles) return;
	_loadingFiles = YES;
    
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^() {
		NSArray *immContents = [_filesystem listFolder:_root error:nil];
		NSMutableArray *mContents = [NSMutableArray arrayWithArray:immContents];
		[mContents sortUsingFunction:sortFileInfos context:NULL];
		dispatch_async(dispatch_get_main_queue(), ^() {
			self.contents = mContents;
			_loadingFiles = NO;
			[self reload];
		});
	});
}

NSInteger sortFileInfos(id obj1, id obj2, void *ctx) {
	return [[obj1 path] compare:[obj2 path]];
}


@end
