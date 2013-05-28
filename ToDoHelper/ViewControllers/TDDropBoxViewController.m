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

@end

@implementation TDDropBoxViewController


#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self initializeButtonAppearance:self.linkWithDropboxButton];
    [self initializeButtonAppearance:self.unlinkButton];
    [self initializeButtonAppearance:self.saveToDropboxButton];
    [self initializeButtonAppearance:self.cancelButton];
    [self configureButtons];
    
    //  determine appropriate buttons to enable userinteraction, depending on
    //  whether a dropbox account is linked or not
    
    
    
    
}




#pragma mark - helpers
- (void)configureButtons
{
    //  detemine which buttons should be enabled, based on whether a dropbox account has
    //  been linked or not
    if ([DBAccountManager sharedManager].linkedAccount) {
        
        self.linkWithDropboxButton.userInteractionEnabled = NO;
        self.linkWithDropboxButton.backgroundColor = [UIColor grayColor];
    }
    else {
        
        self.unlinkButton.userInteractionEnabled = NO;
        self.unlinkButton.backgroundColor = [UIColor grayColor];
        
        self.saveToDropboxButton.userInteractionEnabled = NO;
        self.saveToDropboxButton.backgroundColor = [UIColor grayColor];
        
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
