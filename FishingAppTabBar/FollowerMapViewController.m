//
//  SecondViewController.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/14/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "FollowerMapViewController.h"
#import "MyAnnotation.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "FishViewForMapViewController.h"
#import "MyManager.h"
#import "MBProgressHUD.h"

@interface FollowerMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mkView;
@property (weak, nonatomic) MyAnnotation *ann;

@end

@implementation FollowerMapViewController
@synthesize followerId;
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.mkView.delegate = self;
    
    //[self.mkView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    //[self.mkView setAutoresizingMask:
    //(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
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
    [query whereKey:@"clientId" containsString:followerId];
    [query setLimit: 1000];
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
           self.mkView.mapType = MKMapTypeStandard;
            break;
        case 1:
            
            NSLog(@"CASE 1");
           self.mkView.mapType = MKMapTypeSatellite;
            break;
        default:
            NSLog(@"Default");
            self.mkView.mapType = MKMapTypeStandard;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
