//
//  TDMyNotesViewController.m
//  ToDoHelper
//
//  Created by Joseph Malandruccolo on 5/27/13.
//  Copyright (c) 2013 Joseph Malandruccolo. All rights reserved.
//


static NSString * const    kNotePreviewCellIdentifier = @"note preview cell";


#import "TDMyNotesViewController.h"
#import "TDNotePreviewCell.h"

@interface TDMyNotesViewController ()

@property (nonatomic) DBFilesystem *filesystem;
@property (nonatomic, retain) DBPath *root;
@property (nonatomic, assign) BOOL loadingFiles;
@property (nonatomic, retain) NSMutableArray *contents;

@end

@implementation TDMyNotesViewController


#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad before shared file system");
    
    if ([DBFilesystem sharedFilesystem]) {
        _filesystem = [DBFilesystem sharedFilesystem];
        _root = [DBPath root];
    }
    
    NSLog(@"view did load after shared file system");
    
    if (!self.filesystem) {
        
        DBAccount *appAccount = [DBAccountManager sharedManager].linkedAccount;
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:appAccount];
        
        _filesystem = filesystem;
        _root = [DBPath root];
    }
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"viewWillAppear called");
    
	[super viewWillAppear:animated];
    
	__weak TDMyNotesViewController *weakSelf = self;
	[self.filesystem addObserver:self block:^() { [weakSelf reload]; }];
	[self.filesystem addObserver:self forPathAndChildren:self.root block:^() { [weakSelf loadFiles]; }];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_contents) return 1;
    NSLog(@"count of notes: %lu", (unsigned long)[_contents count]);
	return [_contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TDNotePreviewCell *cell = (TDNotePreviewCell*)[tableView dequeueReusableCellWithIdentifier:kNotePreviewCellIdentifier forIndexPath:indexPath];
    
    DBFileInfo *info = [_contents objectAtIndex:[indexPath row]];
	cell.filenameLabel.text = [info.path name];
    
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
     */
}


#pragma mark - private helpers
- (void)reload
{
	[self.tableView reloadData];
}

- (void)loadFiles {
	if (self.loadingFiles) return;
	self.loadingFiles = YES;
    
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^() {
		NSArray *immContents = [self.filesystem listFolder:self.root error:nil];
		NSMutableArray *mContents = [NSMutableArray arrayWithArray:immContents];
		[mContents sortUsingFunction:sortFileInfos context:NULL];
		dispatch_async(dispatch_get_main_queue(), ^() {
			self.contents = mContents;
			self.loadingFiles = NO;
			[self reload];
		});
	});
}

NSInteger sortFileInfos(id obj1, id obj2, void *ctx) {
	return [[obj1 path] compare:[obj2 path]];
}


@end
