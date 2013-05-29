//
//  TDAddNoteViewController.m
//  ToDoHelper
//
//  Created by Joseph Malandruccolo on 5/27/13.
//  Copyright (c) 2013 Joseph Malandruccolo. All rights reserved.
//


NSString * const    kExportSegueIdentifier = @"export note segue";
NSString * const    kViewAllNotesSegueIdentifier = @"see all notes segue";



#import "TDAddNoteViewController.h"
#import "TDComposeNoteToolbar.h"
#import "TDDropBoxViewController.h"
#import "TDMyNotesViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TDAddNoteViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

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
        //  set the text payload
        if (self.textView.text) {
            
            NSLog(@"setting text as: %@", self.textView.text);
            [destinationVC setNotePayload:self.textView.text];
            
        }
        else {
            [destinationVC setNotePayload:@" "];
        }
        
        
        //  set the image payload
        if (self.imageView.image) {
            [destinationVC setImagePayload:[self blendImageAndText]];
        }
        else {
            [destinationVC setImagePayload:nil];
        }
        
    }
    else if ([[segue identifier] isEqualToString:kViewAllNotesSegueIdentifier]) {
        //  do nothing
    }
    
}


#pragma mark - unwind segues
- (IBAction)didFinishInterfacingWithDropBox:(UIStoryboardSegue*)segue
{
    //  do nothing
    self.imageView.image = nil;
    self.textView.text = @"Start typing...";
    [self.imageView setNeedsDisplay];
    [self.textView setNeedsDisplay];
}


- (IBAction)didSelectNoteToView:(UIStoryboardSegue*)sender
{
    //  grab the text from the note and allow the user to edit
}


#pragma mark - IBAction
- (void)doneButtonPressed:(id)sender
{
    [self.textView resignFirstResponder];
}


- (void)cameraButtonPressed:(id)sender
{
    NSLog(@"camera button pressed");
    
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerVC.delegate = (id)self;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}


#pragma mark - UIImagePickPickerViewController Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = pickedImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - private helpers
- (UIImage*)blendImageAndText
{
    UIGraphicsBeginImageContextWithOptions(self.imageView.image.size, NO, 0.0);
    
    [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    [self.textView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return blendedImage;
    
}



@end