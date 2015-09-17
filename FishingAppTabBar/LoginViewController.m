//
//  LoginViewController.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/16/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "LoginViewController.h"
#import "MyManager.h"
#import "MBProgressHUD.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

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

- (void)viewDidAppear:(BOOL)animated {
    PFUser *user = [PFUser currentUser];
    if (user.username != nil) {
        self.navigationController.navigationBarHidden = YES;
        
        self.hidesBottomBarWhenPushed = NO;
        [self performSegueWithIdentifier:@"uploader" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)login:(id)sender {
}

- (IBAction)registerAction:(id)sender {
    [_usernameField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_reEnterPasswordField resignFirstResponder];
    [self checkFieldsComplete];
}

- (void) checkFieldsComplete {
    if ([_usernameField.text isEqualToString:@""] || [_emailField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""] || [_reEnterPasswordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"You need to complete all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self checkPasswordsMatch];
    }
}

- (void) checkPasswordsMatch {
    if (![_passwordField.text isEqualToString:_reEnterPasswordField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Passwords don't match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self registerNewUser];
    }
}

- (void) registerNewUser {
    NSLog(@"registering....");
    PFUser *newUser = [PFUser user];
                NSString *lowerUsername = [_usernameField.text lowercaseString];
    newUser.username = lowerUsername;
                NSString *lowerEmail = [_emailField.text lowercaseString];
    newUser.email = lowerEmail;

    newUser.password = _passwordField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Registration success!");
            _loginPasswordField.text = nil;
            _loginUsernameField.text = nil;
            _usernameField.text = nil;
            _passwordField.text = nil;
            _reEnterPasswordField.text = nil;
            _emailField.text = nil;
            //[self performSegueWithIdentifier:@"login" sender:self];
            if (newUser.username != nil) {
                
                MyManager *sharedManager = [MyManager sharedManager];
                
                sharedManager.username = newUser.username;
                
                self.navigationController.navigationBarHidden = NO;
                
                self.hidesBottomBarWhenPushed = NO;
                [self performSegueWithIdentifier:@"uploader" sender:self];
            }
        }
        else {
            NSLog(@"There was an error in registration, %@", error);
            
            if (error.code == 125) {
                NSLog(@"IN REG: invalid email");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Please enter a valid email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            if (error.code == 202) {
                NSLog(@"IN REG: name already taken");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Username already in use" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            if (error.code == 203) {
                NSLog(@"IN REG: name already taken");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"email address already in use" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            
        }
    }];
}

- (IBAction)registeredButton:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _loginOverlayView.frame = self.view.frame;
    }];
}


- (IBAction)loginUser:(id)sender{
    
    PFQuery *query = [PFUser query];
                    NSString *lowerUsername = [_username.text lowercaseString];
    [query whereKey:@"email" equalTo:lowerUsername];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (objects.count > 0) {
            
            PFObject *object = [objects objectAtIndex:0];
            NSString *username = [object objectForKey:@"username"];
            [PFUser logInWithUsernameInBackground:username password:_password.text block:^(PFUser* user, NSError* error){
                
                if (error.code == 101) {
                    NSLog(@"IN REG: invalid login");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Invalid Login Credentials" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                
                
                MyManager *sharedManager = [MyManager sharedManager];
                
                sharedManager.username = user.username;

            }];
            
            PFUser *user = [PFUser currentUser];
            if (user.username == NULL) {
                self.navigationController.navigationBarHidden = NO;
                
                self.hidesBottomBarWhenPushed = NO;
                [self performSegueWithIdentifier:@"uploaderFromLogin" sender:self];
            }
        
        }else{
            
                                NSString *lowerUsername = [_username.text lowercaseString];
            [PFUser logInWithUsernameInBackground: lowerUsername password:_password.text block:^(PFUser* user, NSError* error){
                
                if (error.code == 101) {
                    NSLog(@"IN REG: invalid login");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Invalid Login Credentials" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                
                MyManager *sharedManager = [MyManager sharedManager];
                
                sharedManager.username = user.username;

            }];
            
            PFUser *user = [PFUser currentUser];
            if (user.username == NULL) {
                self.navigationController.navigationBarHidden = NO;
                
                self.hidesBottomBarWhenPushed = NO;
                [self performSegueWithIdentifier:@"uploaderFromLogin" sender:self];
            }
            
        }
        
        
    }];
    
    
}

- (IBAction)loginButton:(id)sender {
    [PFUser logInWithUsernameInBackground:_loginUsernameField.text password:_loginPasswordField.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            NSLog(@"Login user!");
            _loginPasswordField.text = nil;
            _loginUsernameField.text = nil;
            _usernameField.text = nil;
            _passwordField.text = nil;
            _reEnterPasswordField.text = nil;
            _emailField.text = nil;
            [self performSegueWithIdentifier:@"login" sender:self];
        }
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Sorry we had a problem logging you in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

#pragma mark - Login mehtods


/* Login to facebook method */

- (IBAction)loginButtonTouchHandler:(id)sender  {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Connecting";
    [hud show:YES];
    
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"email"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
 
        if (!user) {
            
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
                hud.hidden = YES;
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
                hud.hidden = YES;
                
            }
        } else if (user.isNew) {

            NSLog(@"User with facebook signed up and logged in!");
            self.navigationController.navigationBarHidden = NO;
            
            self.hidesBottomBarWhenPushed = NO;
            [self performSegueWithIdentifier:@"uploader" sender:self];
            [FBRequestConnection
             startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSString *facebookName = [result objectForKey:@"name"];
                     
                     MyManager *sharedManager = [MyManager sharedManager];
                     sharedManager.username = facebookName;
                     
                     NSLog(@"NAME FROM FB: %@", facebookName);
                     
                     PFUser *currentUser = [PFUser currentUser];
                     NSString *userID = currentUser.objectId;
                     
                     
                     NSLog(@"Parse User ObjectID: %@",userID);
                     
                     
                     NSDictionary *userData = (NSDictionary *)result;
                     
                     
                     
                     [currentUser setObject:facebookName forKey:@"displayName"];
                     
                     NSLog(@"FB EMAIL: %@",[userData objectForKey:@"email"]);
                     
                     [currentUser setObject:[userData objectForKey:@"email"] forKey:@"email"];
                     
                     [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                         if (!error) {
                             // The currentUser saved successfully.
                         } else {
                             // There was an error saving the currentUser.
                         }
                     }];
                     
                     NSLog(@"Saving %@",facebookName);
                 }
             }];
            hud.hidden = YES;
        } else {
            
            NSLog(@"User with facebook logged in!");
            self.navigationController.navigationBarHidden = NO;
            
            self.hidesBottomBarWhenPushed = NO;
            [self performSegueWithIdentifier:@"uploader" sender:self];
            [FBRequestConnection
             startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSString *facebookName = [result objectForKey:@"name"];
                     
                     MyManager *sharedManager = [MyManager sharedManager];
                     sharedManager.username = facebookName;
                     
                     NSLog(@"NAME FROM FB: %@", facebookName);
                     
                     PFUser *currentUser = [PFUser currentUser];
                     NSString *userID = currentUser.objectId;
                     
                     
                     NSLog(@"Parse User ObjectID: %@",userID);
                     
                     [currentUser setObject:facebookName forKey:@"displayName"];
                     
                     [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                         if (!error) {
                             // The currentUser saved successfully.
                         } else {
                             // There was an error saving the currentUser.
                         }
                     }];
                     
                     NSLog(@"Saving %@",facebookName);
                 }
             }];
            hud.hidden = YES;
        }
    }];
    
    // Show loading indicator until login is finished
}


@end
