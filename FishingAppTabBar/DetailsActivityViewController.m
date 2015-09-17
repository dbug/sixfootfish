//
//  DetailsMapViewController.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/19/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "DetailsActivityViewController.h"
#import "MyManager.h"

@interface DetailsActivityViewController ()

@end

@implementation DetailsActivityViewController

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
    
    _notes.text = self.fish.notes;
    _species.text = self.fish.species;
    _date.text = self.fish.date;
    
    NSLog(@"USER IN DETAIL: %@", self.fish.username);
    
    _username.text = self.fish.username;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
