//
//  TDAddNoteViewController.m
//  ToDoHelper
//
//  Created by Joseph Malandruccolo on 5/27/13.
//  Copyright (c) 2013 Joseph Malandruccolo. All rights reserved.
//


NSString * const    kExportSegueIdentifier = @"export note segue";



#import "TDAddNoteViewController.h"
#import "TDComposeNoteToolbar.h"
#import "TDDropBoxViewController.h"

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
    
    
    //  prep the text view
    self.textView.text = @"Start typing...";
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kExportSegueIdentifier]) {
        TDDropBoxViewController *destinationVC = [segue destinationViewController];
        NSLog(@"setting text as: %@", self.textView.text);
        [destinationVC setNotePayload:self.textView.text];
    }
}


- (IBAction)didFinishInterfacingWithDropBox:(UIStoryboardSegue*)segue
{
    //  do nothing
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
