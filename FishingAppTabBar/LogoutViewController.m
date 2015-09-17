//
//  LogoutViewController.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/16/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "LogoutViewController.h"

@interface LogoutViewController ()

@end

@implementation LogoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)logOut:(id)sender {
    
    PFUser *user = [PFUser currentUser];
    NSString *name = user.username;
    NSLog(@"NAME: %@", name);

    if(FBSession.activeSession.isOpen){
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession.activeSession close];
        [FBSession setActiveSession:nil];
        NSLog(@"session close");
    }
    
    NSLog(@"Logging out");
    [PFUser logOut];

    NSLog(@"NAME: %@", name);
    
    self.navigationController.navigationBarHidden = YES;
    
    self.hidesBottomBarWhenPushed = YES;
    // Assuming you don't want a navigationbar
[self performSegueWithIdentifier:@"logout" sender:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)following:(id)sender {
    
    [self performSegueWithIdentifier:@"followingSegue" sender:self];
}


@end
