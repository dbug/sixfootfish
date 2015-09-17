//
//  LoginResetPasswordViewController.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/24/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "LoginResetPasswordViewController.h"

@interface LoginResetPasswordViewController ()
@property (strong, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginResetPasswordViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)passwordReset:(id)sender {

    [PFUser requestPasswordResetForEmailInBackground:_password.text];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Email Sent" message:@"Please check your email instructions to reset your password have been sent" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
    
     [self performSegueWithIdentifier:@"password" sender:sender];
}


@end
