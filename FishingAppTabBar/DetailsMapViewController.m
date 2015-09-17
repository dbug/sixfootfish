//
//  DetailsMapViewController.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/19/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "DetailsMapViewController.h"
#import "MyManager.h"
#import "NotesMapViewController.h"

@interface DetailsMapViewController ()

@property (strong, nonatomic) IBOutlet UILabel *size;

@property (strong, nonatomic) IBOutlet UILabel *lure;

@end

@implementation DetailsMapViewController

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
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    _notes.text = sharedManager.fish.notes;
    _species.text = sharedManager.fish.species;
    _date.text = sharedManager.fish.date;
    
    NSString *concat = [NSString stringWithFormat:@"%@ lbs %@ ounces", sharedManager.fish.pounds, sharedManager.fish.onces];
    
    _size.text = concat;
    
    _lure.text = sharedManager.fish.lure;
    
    NSLog(@"USER IN DETAIL: %@", sharedManager.fish.username);
    
    _username.text = sharedManager.fish.username;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoNotes:(id)sender {
    NotesMapViewController *det=[[NotesMapViewController alloc]init];
    det.fish = fish;
    [self.navigationController pushViewController:det animated:YES];
}

- (IBAction)followWithClientId:(id)sender {
    PFUser *user = [PFUser currentUser];
    NSString *followerId = user.objectId;
    
    PFQuery *queryCheck = [PFQuery queryWithClassName:@"Follow"];
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    NSLog(@"followerId: %@ followingId %@", followerId, sharedManager.fish.clientId);
    [queryCheck whereKey:@"followerId" equalTo:followerId];
    [queryCheck whereKey:@"followingId" equalTo:sharedManager.fish.clientId];
    
    PFObject *followingData = [PFObject objectWithClassName:@"Follow"];
    
    [queryCheck findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects.count) {
            NSLog(@"shucks, the employeeId isn't unique");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already Following" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
           [alert show];
        } else {
            
            PFUser *user = [PFUser currentUser];
            NSString *followerId = user.objectId;
            [followingData setObject: followerId forKey:@"followerId"];
            
            [followingData setObject: sharedManager.fish.clientId forKey:@"followingId"];
            
            // Upload recipe to Parse
            [followingData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (!error) {
                    // Show success message
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Following Complete" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    // When users indicate they are Giants fans, we subscribe them to that channel.
                    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                    [currentInstallation addUniqueObject:sharedManager.fish.clientId forKey:@"channels"];
                    [currentInstallation saveInBackground];
                    
                    // Notify table view to reload the recipes from Parse cloud
                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                    
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Follow Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
                
            }];
            
            
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



/*
- (IBAction)follow:(id)sender {
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    PFObject *followingData = [PFObject objectWithClassName:@"Follow"];
    
    PFUser *user = [PFUser currentUser];
    NSString *followerId = user.objectId;
    
        [followingData setObject:followerId forKey:@"followerId"];
    
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:sharedManager.fish.username];
    
    
    
    NSLog(@"FISH USER: %@", sharedManager.fish.username);
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed. ERROR: %@", error );
        } else {
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
            
            PFUser *user = [PFUser currentUser];
            NSString *followerId = user.objectId;
            
            PFQuery *queryCheck = [PFQuery queryWithClassName:@"Follow"];
            [queryCheck whereKey:@"followerId" equalTo:followerId];
            [queryCheck whereKey:@"followingId" equalTo:object.objectId];
            
            [queryCheck findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (objects.count) {
                    NSLog(@"shucks, the employeeId isn't unique");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already Following" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                } else {
                    
                    [followingData setObject:object.objectId forKey:@"followingId"];
                    
                    // Upload recipe to Parse
                    [followingData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        
                        if (!error) {
                            // Show success message
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Following Complete" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alert show];
                            
                            // Notify table view to reload the recipes from Parse cloud
                            //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                            
                        } else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Follow Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alert show];
                            
                        }
                        
                    }];


                }
            }];
            
         }
    }];
  */
    /*
    
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    
    NSLog(@"FISH USER NAME: %@", sharedManager.fish.username);
    
    [query whereKey:@"username" equalTo:sharedManager.fish.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        NSLog(@"COUNT: %lu", (unsigned long)objects.count);
    
        if (!error) {
            
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                NSString *followingId = object.objectId;
                [followingData setObject:followingId forKey:@"followingId"];
            }
            
        }
    }];
     

}*/

@end
