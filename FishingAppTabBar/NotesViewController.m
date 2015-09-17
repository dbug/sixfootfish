//
//  NotesViewController.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/22/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "NotesViewController.h"
#import "MyManager.h"
#import "MBProgressHUD.h"

@interface NotesViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textField;
@end

@implementation NotesViewController

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

- (BOOL) textView: (UITextView*) textView shouldChangeTextInRange: (NSRange) range replacementText: (NSString*) text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        MyManager *sharedManager = [MyManager sharedManager];
        
        sharedManager.notes = _textField.text;
        
        NSLog(@"Notes: %@", sharedManager.notes);
        return NO;
    }
    return YES;
}

- (IBAction)saveData:(id)sender {
    
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    PFUser *user = [PFUser currentUser];
    NSString *name = user.username;
    
    sharedManager.username = name;
    
    sharedManager.clientId= user.objectId;
    
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSString *facebookName = [result objectForKey:@"name"];
             
             NSLog(@"NAME FROM FB: %@", facebookName);
             
                 MyManager *sharedManager = [MyManager sharedManager];
                 
                 NSString *name = facebookName;
                 
                 sharedManager.username = name;
             // Show progress
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeIndeterminate;
             hud.labelText = @"Uploading";
             [hud show:YES];
             
             //[sharedManager saveJson];
             
             // Create PFObject with recipe information
             PFObject *fishData = [PFObject objectWithClassName:@"Fish"];
             
             [fishData setObject:sharedManager.username forKey:@"username"];
             [fishData setObject:sharedManager.date forKey:@"date"];
             [fishData setObject:sharedManager.latitude forKey:@"latitude"];
             [fishData setObject:sharedManager.longitude forKey:@"longitude"];
             [fishData setObject:sharedManager.species forKey:@"species"];
             [fishData setObject:sharedManager.notes forKey:@"notes"];
             [fishData setObject:sharedManager.pounds forKey:@"pounds"];
             [fishData setObject:sharedManager.onces forKey:@"onces"];
             [fishData setObject:sharedManager.lure forKey:@"lure"];
             [fishData setObject:sharedManager.location forKey:@"location"];
             [fishData setObject:sharedManager.clientId forKey:@"clientId"];
             
             PFFile *imageFile = [PFFile fileWithName:sharedManager.filename data:sharedManager.imageData];
             [fishData setObject:imageFile forKey:@"imageFile"];
             
             NSLog(@"Geopoint: %@", sharedManager.location);
             
             // Upload recipe to Parse
             [fishData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                     NSLog(@"PUSHING: %@", sharedManager.clientId);
                 if (!error) {
                     
                       NSLog(@"PUSHING: %@", sharedManager.clientId);
                     
                     // Show success message
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved your catch" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     
                     PFPush *push = [[PFPush alloc] init];
                     
                     [push setChannel:sharedManager.clientId];
                    
                     NSString *messageText = [NSString stringWithFormat:@"%@ just shared a fish!", sharedManager.username];
                     
                     [push setMessage:messageText];
                     
                     [push setData: @{ @"alert": messageText, @"objectId":fishData.objectId, @"message":messageText }];
                     [push sendPushInBackground];
                     
                     [hud hide:YES];
                     
                     // Notify table view to reload the recipes from Parse cloud
                     //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                     
                 } else {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     
                 }
                 
             }
              ];

         } else {
             // Show progress
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeIndeterminate;
             hud.labelText = @"Uploading";
             [hud show:YES];
             
             //[sharedManager saveJson];
             
             // Create PFObject with recipe information
             PFObject *fishData = [PFObject objectWithClassName:@"Fish"];
             
             [fishData setObject:sharedManager.username forKey:@"username"];
             [fishData setObject:sharedManager.date forKey:@"date"];
             [fishData setObject:sharedManager.latitude forKey:@"latitude"];
             [fishData setObject:sharedManager.longitude forKey:@"longitude"];
             [fishData setObject:sharedManager.species forKey:@"species"];
             [fishData setObject:sharedManager.notes forKey:@"notes"];
             [fishData setObject:sharedManager.pounds forKey:@"pounds"];
             [fishData setObject:sharedManager.onces forKey:@"onces"];
             [fishData setObject:sharedManager.lure forKey:@"lure"];
             [fishData setObject:sharedManager.location forKey:@"location"];
             [fishData setObject:sharedManager.clientId forKey:@"clientId"];
             
             PFFile *imageFile = [PFFile fileWithName:sharedManager.filename data:sharedManager.imageData];
             [fishData setObject:imageFile forKey:@"imageFile"];
             
             NSLog(@"Geopoint: %@", sharedManager.location);
             
             // Upload recipe to Parse
             [fishData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 
                 if (!error) {
                     // Show success message
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved your catch" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     
                     PFPush *push = [[PFPush alloc] init];
                     
                     [push setChannel:sharedManager.clientId];
                     
                     NSString *messageText = [NSString stringWithFormat:@"%@ just shared a fish!", sharedManager.username];
                     
                     [push setMessage:messageText];
                     
                     [push setData: @{ @"alert": messageText, @"objectId":fishData.objectId, @"message":messageText }];
                     [push sendPushInBackground];
                     
                     [hud hide:YES];
                     
                     // Notify table view to reload the recipes from Parse cloud
                     //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                     
                 } else {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     
                 }
                 
             }
              ];
             
         }
     }];
}

// Method is called when the iAd is loaded.
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    // Creates animation.
    [UIView beginAnimations:nil context:nil];
    
    // Sets the duration of the animation to 1.
    [UIView setAnimationDuration:1];
    
    // Sets the alpha to 1.
    // We do this because we are going to have it set to 0 to start and setting it to 1 will cause the iAd to fade into view.
    [banner setAlpha:1];
    
    //  Performs animation.
    [UIView commitAnimations];
    
}

// Method is called when the iAd fails to load.
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    // Creates animation.
    [UIView beginAnimations:nil context:nil];
    
    // Sets the duration of the animation to 1.
    [UIView setAnimationDuration:1];
    
    // Sets the alpha to 0.
    // We do this because we are going to have it set to 1 to start and setting it to 0 will cause the iAd to fade out of view.
    [banner setAlpha:0];
    
    //  Performs animation.
    [UIView commitAnimations];
    
}


@end
