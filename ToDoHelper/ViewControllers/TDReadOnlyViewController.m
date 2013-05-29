//
//  TDReadOnlyViewController.m
//  ToDoHelper
//
//  Created by Joseph Malandruccolo on 5/28/13.
//  Copyright (c) 2013 Joseph Malandruccolo. All rights reserved.
//

#import "TDReadOnlyViewController.h"

@interface TDReadOnlyViewController ()

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;


@end

@implementation TDReadOnlyViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"view did load");

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.noteTextView.text = self.payload;
    
}


@end
