//
//  TDDropBoxViewController.m
//  ToDoHelper
//
//  Created by Joseph Malandruccolo on 5/27/13.
//  Copyright (c) 2013 Joseph Malandruccolo. All rights reserved.
//

#import "TDDropBoxViewController.h"
#import <dropbox/dropbox.h>
#import <QuartzCore/QuartzCore.h>

@interface TDDropBoxViewController ()

@property (weak, nonatomic) IBOutlet UIButton *linkWithDropboxButton;
@property (weak, nonatomic) IBOutlet UIButton *unlinkButton;
@property (weak, nonatomic) IBOutlet UIButton *saveToDropboxButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)pressedLinkWithDropbox:(UIButton *)sender;
- (IBAction)pressedSave:(UIButton *)sender;

@end

@implementation TDDropBoxViewController


//  TODO: implement an nsarray and secure coding to store file names for retrieval

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self initializeButtonAppearance:self.linkWithDropboxButton];
    [self initializeButtonAppearance:self.unlinkButton];
    [self initializeButtonAppearance:self.saveToDropboxButton];
    [self initializeButtonAppearance:self.cancelButton];
    [self configureButtons];
    
    //  something should be set, even the empty string
    assert(self.notePayload);
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [self configureButtons];
}


#pragma mark - IBAction
- (IBAction)pressedLinkWithDropbox:(UIButton *)sender
{
    [[DBAccountManager sharedManager] linkFromController:self];
}


- (IBAction)pressedSave:(UIButton *)sender
{
    DBAccount *account = [DBAccountManager sharedManager].linkedAccount;
    
    if (account) {
        
        //  set current date for file name
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd-yyyy-HH:mm:ss"];
        NSMutableString *filename = [[NSMutableString alloc] init];
        [filename appendString:[formatter stringFromDate:[NSDate date]]];
        [filename appendString:@".txt"];
        
        //  dropbox api
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
        
        DBPath *newPath = [[DBPath root] childPath:filename];
        DBFile *file = [[DBFilesystem sharedFilesystem] createFile:newPath error:nil];
        [file writeString:self.notePayload error:nil];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



#pragma mark - helpers
- (void)configureButtons
{
    
    //  detemine which buttons should be enabled, based on whether a dropbox account has
    //  been linked or not
    if ([DBAccountManager sharedManager].linkedAccount) {
        
        //  block unavailable btn
        self.linkWithDropboxButton.userInteractionEnabled = NO;
        self.linkWithDropboxButton.backgroundColor = [UIColor grayColor];
        
        
        //  enable available btn
        self.unlinkButton.userInteractionEnabled = YES;
        self.unlinkButton.backgroundColor = [UIColor clearColor];
        
        self.saveToDropboxButton.userInteractionEnabled = YES;
        self.saveToDropboxButton.backgroundColor = [UIColor clearColor];
        
        
    }
    else {
        
        //  block unavailable btn
        self.unlinkButton.userInteractionEnabled = NO;
        self.unlinkButton.backgroundColor = [UIColor grayColor];
        
        self.saveToDropboxButton.userInteractionEnabled = NO;
        self.saveToDropboxButton.backgroundColor = [UIColor grayColor];
        
        
        //  enable available btn
        self.linkWithDropboxButton.userInteractionEnabled = YES;
        self.linkWithDropboxButton.backgroundColor = [UIColor clearColor];
        
    }
}

- (void)initializeButtonAppearance:(UIButton*)btn
{
    //  make a custom button look like a default button
    [btn.layer setCornerRadius:8.0f];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setBorderWidth:1.0f];
    [btn.layer setBorderColor:[[UIColor blackColor] CGColor]];
    
    
    //  set highlighted properties
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
}


@end
