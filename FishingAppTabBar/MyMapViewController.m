//
//  SearchMapViewController.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/23/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "MyMapViewController.h"
#import "MBProgressHUD.h"
#import "MyAnnotation.h"
#import "Fish.h"
#import "FishViewForMapViewController.h"
#import "MyManager.h"


@interface MyMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mkView;

@end

@implementation MyMapViewController


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
    self.mapView.delegate = self;
    
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
    
    PFUser *user = [PFUser currentUser];
    NSString *userId = user.objectId;
    
    [query whereKey:@"clientId" equalTo:userId];
    
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
                ann.title =  [parseObject objectForKey:@"species"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
    
}
/*
 - (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
 NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
 }
 */
- (IBAction)switchView:(id)sender {
    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case 0:
            NSLog(@"CASE 0");
            _mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            
            NSLog(@"CASE 1");
            _mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            NSLog(@"Default");
            _mapView.mapType = MKMapTypeStandard;
    }
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // get reference to the annotation to access its data
    MyAnnotation *myAnnotation = (MyAnnotation *)view.annotation;
    // deselect the button
    [self.mapView deselectAnnotation:myAnnotation animated:YES];
    
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
    
    NSLog(@"FISH USER NAME %@",fish.username );
    
    det.fish = fish;
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    sharedManager.fish = fish;
    
    [self performSegueWithIdentifier: @"fishViewDetails" sender: self];
    
    //[self.navigationController pushViewController:det animated:YES];
    
    //[self performSegueWithIdentifier:@"fishViewDetails" sender:self ];
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
    PFUser *user = [PFUser currentUser];
    NSString *userId = user.objectId;
    
    [query whereKey:@"clientId" equalTo:userId];
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
                ann.title =  [parseObject objectForKey:@"species"];
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


- (IBAction)refreshMap:(id)sender {
    [self updateVisibleAnnotations];
}


@end
