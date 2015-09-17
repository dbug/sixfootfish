//
//  SecondViewController.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/14/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "SecondViewController.h"
#import "MyAnnotation.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "FishViewForMapViewController.h"
#import "MyManager.h"
#import "MBProgressHUD.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mkView;
@property (weak, nonatomic) MyAnnotation *ann;

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Initialize the banner at the bottom of the screen.
    /*
    CGPoint origin = CGPointMake(0.0,self.view.frame.size.height -
                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height-50);
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    self->adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    
    self->adBanner.adUnitID = @"ca-app-pub-8015116409018415/4489198269";
    self->adBanner.rootViewController = self;
    [self.view addSubview:self->adBanner];
    
    [self->adBanner loadRequest:[self request]];
     */
    
    self.mkView.delegate = self;
    
    [self.mkView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    [self.mkView setAutoresizingMask:
     (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
    [self.mkView dequeueReusableAnnotationViewWithIdentifier:@"ann"];
    // Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Getting Last 1000 Catches";
    [hud show:YES];
    NSArray *existingpoints = _mkView.annotations;
	if ([existingpoints count] > 0){
		[_mkView removeAnnotations:existingpoints];
        NSLog(@"Removing Annonation");
    }    //get server objects
    PFQuery *query = [PFQuery queryWithClassName:@"Fish"];
    [query setLimit: 1000];
    //NSArray *keys = [NSArray arrayWithObjects:, nil];
    [query selectKeys:@[@"longitude",@"latitude",@"username",@"date",@"notes",@"species",@"lure",@"lure",@"pounds",@"onces",@"clientId"]];
        [query orderByDescending:@"createdAt"];
    NSArray* parseArray = [query findObjects];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //fast enum and grab strings and put into tempCaption array
            for (PFObject *parseObject in parseArray) {
                
                CLLocationCoordinate2D location;
                location.latitude = [[parseObject objectForKey:@"latitude"] doubleValue];
                location.longitude = [[parseObject objectForKey:@"longitude"] doubleValue];
                MyAnnotation *ann = [[MyAnnotation alloc] initWithPosition:location];
                
                NSString *title = [NSString stringWithFormat:@"%@ - %@", [parseObject objectForKey:@"username"], [parseObject objectForKey:@"species"]];
                ann.title =  title;
                ann.subtitle = [parseObject objectForKey:@"date"];
                //ann.imageFile = [parseObject objectForKey:@"imageFile"];
                ann.objectId = [parseObject objectId];
                ann.date = [parseObject objectForKey:@"date"];
                ann.latitude = [parseObject objectForKey:@"latitude"];
                ann.longitude = [parseObject objectForKey:@"longitude"];
                ann.species = [parseObject objectForKey:@"species"];
                ann.notes = [parseObject objectForKey:@"notes"];
                ann.username = [parseObject objectForKey:@"username"];
                ann.lure = [parseObject objectForKey:@"lure"];
                ann.pounds = [parseObject objectForKey:@"pounds"];
                ann.onces = [parseObject objectForKey:@"onces"];
                ann.clientId = [parseObject objectForKey:@"clientId"];
                
                NSLog(@"THE USER FOR THE PIN %@", ann.username);
                
                ann.reuseIdentifier = @"pin";
                ann.canShowCallout = YES;
                //NSLog(@"ID: %@", ann.objectId);
                //NSLog(@"ID: %@", ann.imageFile);
                [self.mkView addAnnotation:ann];
            }
            
            hud.hidden = YES;
            // The find succeeded. The first 100 objects are available in objects
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    } else {
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ann"];
    view.pinColor = MKPinAnnotationColorPurple;
    view.enabled = YES;
    view.animatesDrop = NO;
    view.canShowCallout = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"palmTree.png"]];
    view.leftCalloutAccessoryView = imageView;
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return view;
    }
}
- (IBAction)refreshMap:(id)sender {
        [self updateVisibleAnnotations];
}

- (void)didZoom:(UIPinchGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        [self updateVisibleAnnotations];
    }
}

- (void) updateVisibleAnnotations {
    // Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Getting Last 1000 Catches";
    [hud show:YES];
    NSArray *existingpoints = _mkView.annotations;
	if ([existingpoints count] > 0){
		[_mkView removeAnnotations:existingpoints];
        NSLog(@"Removing Annonation");
    }    //get server objects
    PFQuery *query = [PFQuery queryWithClassName:@"Fish"];
    [query setLimit: 1000];
    [query orderByDescending:@"createdAt"];
    //NSArray *keys = [NSArray arrayWithObjects:, nil];
    [query selectKeys:@[@"longitude",@"latitude",@"username",@"date",@"notes",@"species",@"lure",@"lure",@"pounds",@"onces",@"clientId"]];
    NSArray* parseArray = [query findObjects];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //fast enum and grab strings and put into tempCaption array
            for (PFObject *parseObject in parseArray) {
                
                CLLocationCoordinate2D location;
                location.latitude = [[parseObject objectForKey:@"latitude"] doubleValue];
                location.longitude = [[parseObject objectForKey:@"longitude"] doubleValue];
                MyAnnotation *ann = [[MyAnnotation alloc] initWithPosition:location];
                NSString *title = [NSString stringWithFormat:@"%@ - %@", [parseObject objectForKey:@"username"], [parseObject objectForKey:@"species"]];
                ann.title =  title;
                ann.subtitle = [parseObject objectForKey:@"date"];
                //ann.imageFile = [parseObject objectForKey:@"imageFile"];
                ann.objectId = [parseObject objectId];
                ann.date = [parseObject objectForKey:@"date"];
                ann.latitude = [parseObject objectForKey:@"latitude"];
                ann.longitude = [parseObject objectForKey:@"longitude"];
                ann.species = [parseObject objectForKey:@"species"];
                ann.notes = [parseObject objectForKey:@"notes"];
                ann.username = [parseObject objectForKey:@"username"];
                ann.lure = [parseObject objectForKey:@"lure"];
                ann.pounds = [parseObject objectForKey:@"pounds"];
                ann.onces = [parseObject objectForKey:@"onces"];
                ann.clientId = [parseObject objectForKey:@"clientId"];
                
                NSLog(@"THE clientId FOR THE PIN %@", ann.clientId);
                
                NSLog(@"THE USER FOR THE PIN %@", ann.username);
                
                ann.reuseIdentifier = @"pin";
                ann.canShowCallout = YES;
               // NSLog(@"ID: %@", ann.objectId);
               // NSLog(@"ID: %@", ann.imageFile);
                [self.mkView addAnnotation:ann];
            }
            
        hud.hidden = YES;
            // The find succeeded. The first 100 objects are available in objects
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // get reference to the annotation to access its data
    MyAnnotation *myAnnotation = (MyAnnotation *)view.annotation;
    // deselect the button
    [self.mkView deselectAnnotation:myAnnotation animated:YES];
    
    FishViewForMapViewController *det=[[FishViewForMapViewController alloc]init];
    
    NSLog(@"Object ID: %@", myAnnotation.objectId);

    Fish *fish = [[Fish alloc] init];
    //fish.imageFile = myAnnotation.imageFile;
     //NSLog(@"File: %@", fish.imageFile);
    fish.objectId = myAnnotation.objectId;
    fish.date = myAnnotation.date;
    
    fish.latitude = myAnnotation.latitude;
    
    fish.longitude = myAnnotation.longitude;
    
    fish.notes = myAnnotation.notes;
    
    fish.species = myAnnotation.species;
    
    fish.username = myAnnotation.username;
    
    fish.lure = myAnnotation.lure;
    
    fish.pounds = myAnnotation.pounds;
    
    fish.onces = myAnnotation.onces;
    
    fish.clientId = myAnnotation.clientId;
    
    NSLog(@"FISH clientId is %@",fish.clientId );
    
    det.fish = fish;
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    sharedManager.fish = fish;
    
    [self performSegueWithIdentifier: @"fishViewDetails" sender: self];
    
    //[self.navigationController pushViewController:det animated:YES];

//[self performSegueWithIdentifier:@"fishViewDetails" sender:self ];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"fishViewDetails"]) {
        NSLog(@"IN PREPARE FUNCTION");
        //FishViewForMapViewController *destViewController = segue.destinationViewController;
        //destViewController.fish = self.fish;
    }
}


- (IBAction)switchView:(id)sender {
    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case 0:
            NSLog(@"CASE 0");
            _mkView.mapType = MKMapTypeStandard;
            break;
        case 1:
            
            NSLog(@"CASE 1");
            _mkView.mapType = MKMapTypeSatellite;
            break;
        default:
            NSLog(@"Default");
            _mkView.mapType = MKMapTypeStandard;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
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
*/

/*
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
*/

@end
