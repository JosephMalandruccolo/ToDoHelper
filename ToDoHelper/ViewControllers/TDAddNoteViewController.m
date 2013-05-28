//
//  TDAddNoteViewController.m
//  ToDoHelper
//
//  Created by Joseph Malandruccolo on 5/27/13.
//  Copyright (c) 2013 Joseph Malandruccolo. All rights reserved.
//

#import "TDAddNoteViewController.h"
#import "TDComposeNoteToolbar.h"

@interface TDAddNoteViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TDAddNoteViewController


#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //  add accessory view to the keyboard
    TDComposeNoteToolbar *composeNoteAccessoryView = [[[NSBundle mainBundle] loadNibNamed:@"ComposeNoteAccessoryView" owner:self options:nil] objectAtIndex:0];
    
    //  set button targets
    composeNoteAccessoryView.doneButton.target = self;
    composeNoteAccessoryView.cameraButton.target = self;
    
    //  set button actions
    composeNoteAccessoryView.doneButton.action = @selector(doneButtonPressed:);
    composeNoteAccessoryView.cameraButton.action = @selector(cameraButtonPressed:);
    
    self.textView.inputAccessoryView = composeNoteAccessoryView;
}


#pragma mark - IBAction
- (void)doneButtonPressed:(id)sender
{
    [self.textView resignFirstResponder];
}


- (void)cameraButtonPressed:(id)sender
{
    NSLog(@"camera button pressed");
}

@end
