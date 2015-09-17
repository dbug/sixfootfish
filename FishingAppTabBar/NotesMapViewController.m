//
//  NotesMapViewController.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/22/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "NotesMapViewController.h"
#import "MyManager.h"

@interface NotesMapViewController ()

@end

@implementation NotesMapViewController

@synthesize fish;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //_notes.text = fish.notes;
    MyManager *sharedManager = [MyManager sharedManager];
        _notes.text = sharedManager.fish.notes;
    NSLog( @"NOTES: %@",sharedManager.fish.notes);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
