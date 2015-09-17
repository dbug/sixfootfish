//
//  FishViewDetail.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/17/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "FishViewForMapViewController.h"
#import "Fish.h"
#import <Parse/Parse.h>
#import "DetailsMapViewController.h"
#import "MyManager.h"
#import "GADBannerView.h"

@interface FishViewForMapViewController (){
    GADBannerView * bannerView_;
}

@end

@implementation FishViewForMapViewController

@synthesize fish;
@synthesize fishPhoto;

BOOL adLoaded = NO;

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
    /*
    if (adLoaded == NO) {
        // Initialize the banner at the bottom of the screen.
        CGPoint origin = CGPointMake(0.0,self.view.frame.size.height -
                                     CGSizeFromGADAdSize(kGADAdSizeBanner).height-50);
        
        // Use predefined GADAdSize constants to define the GADBannerView.
        self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
        
        self.adBanner.adUnitID = @"ca-app-pub-8015116409018415/4489198269";
        //self.adBanner.delegate = self;
        [self.adBanner setDelegate:self];
        self.adBanner.rootViewController = self;
        //[self.parentViewController.parentViewController.view addSubview:self.adBanner];
        
        
        [self.navigationController.tabBarController.view addSubview:self.adBanner];
        
        [self.adBanner loadRequest:[self request]];
    }
    
    */

    
    //[self.window.rootViewController.view addSubView:_adBanner];
    /*
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.adBanner
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0
                                   constant:0]];
    
    self.adBanner.translatesAutoresizingMaskIntoConstraints = NO;
    */
    
    //GADRequest *request = [self request];
    //request.testDevices = [NSArray arrayWithObjects:@"X", nil];
    
    //[self.adBanner loadRequest:[self request]];
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Fish"];
    
    NSString *objectId = sharedManager.fish.objectId;
    
    NSLog(@"MY ID IS: %@", objectId);

    NSLog(@"MY cleintId IS: %@", sharedManager.fish.clientId);
    
    [query whereKey:@"objectId" equalTo:objectId];
    
    [query selectKeys:@[@"imageFile"]];
    
    NSArray* parseArray = [query findObjects];
    //fast enum and grab strings and put into tempCaption array
    for (PFObject *parseObject in parseArray) {
        PFFile *file = [parseObject objectForKey:@"imageFile"];
        
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if(!error) {
                [self.image setImage:[UIImage imageWithData:data]];
                 }
        }];
       
        
        NSLog(@"FILE: %@", file);
        
        //NOT UPDATING THE IMAGE IN THE VIEW
        //self.image.file = file;

    };

    
    
    //NSLog(@"Fish Obj File: %@",fish.imageFile);
    
    //NSLog(@"Id: %@",fish.objectId);
    
    NSLog(@"FISH PHOTO FILE: %@", self.image.file);
    //PFObject *object;

}

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    //request.testDevices = @[
                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
                            // the console when the app is launched.
                            //GAD_SIMULATOR_ID,
                            //@"2968cc6404f7edb5a6fa4d9f15f26a04"
                            //];
    
    return request;
}

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
     adLoaded = YES;
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

- (IBAction)gotoDetails:(id)sender {
    
    NSLog(@"FISH clientId GO TO DETAILS: %@", fish.clientId);
       DetailsMapViewController *det=[[DetailsMapViewController alloc]init];
    det.fish = fish;
    [self.navigationController pushViewController:det animated:YES];
}


- (void)viewDidUnload
{
    [self setFishPhoto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

