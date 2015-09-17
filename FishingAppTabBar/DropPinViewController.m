//
//  DropPinViewController.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/15/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "DropPinViewController.h"
#import "MyAnnotation.h"
#import "MyManager.h"

@interface DropPinViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mkView;

@end

@implementation DropPinViewController



- (IBAction)DropPin:(id)sender {
  [_mkView removeAnnotations:_mkView.annotations];
    MyAnnotation *ann = [[MyAnnotation alloc] initWithPosition:_mkView.centerCoordinate];
    //ann.title = @"View Photo";
    //ann.subtitle = @"2/14/2014 6:30am";

    dispatch_async(dispatch_get_main_queue(), ^{
        [_mkView addAnnotation:ann];
    });
    
    
    CLLocationCoordinate2D coord = ann.coordinate;
    NSLog(@"lat = %f, lon = %f", coord.latitude, coord.longitude);
    
    NSString *latitude = [[NSNumber numberWithDouble:ann.coordinate.latitude] stringValue];
    
    NSString *longitude = [[NSNumber numberWithDouble:ann.coordinate.longitude] stringValue];
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    sharedManager.latitude = latitude;
    
    sharedManager.longitude = longitude;
    
    sharedManager.location = [PFGeoPoint geoPointWithLatitude:[sharedManager.latitude doubleValue] longitude:[sharedManager.longitude doubleValue]];
    
    
    NSLog(@"sharedManager lat:%@ long:%@",sharedManager.latitude, sharedManager.longitude);
    NSLog(@"Clicked");
}
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

        [self dropImagePin];
    
    
    _mkView.delegate=self;
    
    //[_mkView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    [_mkView setAutoresizingMask:
     (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	// Do any additional setup after loading the view.
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Instructions" message:@"Press drop pin button to drop a pin on the map, you can postion the pin by clicking and dragging it" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dropImagePin{
     MyManager *sharedManager = [MyManager sharedManager];
    
    NSLog(@"WTF: %@",sharedManager.longitude);
    
    if ([sharedManager.longitude doubleValue] != 0) {
        CLLocation *myPin = [[CLLocation alloc] initWithLatitude:[sharedManager.latitude doubleValue] longitude:[sharedManager.longitude doubleValue]];
        MyAnnotation *ann = [[MyAnnotation alloc] initWithPosition:myPin.coordinate];
        
            _mkView.delegate=self;
        
        MKCoordinateSpan span = MKCoordinateSpanMake(0.0001f, 0.0001f);
        CLLocationCoordinate2D coordinate = {[sharedManager.latitude doubleValue],[sharedManager.longitude doubleValue]};
        MKCoordinateRegion region = {coordinate, span};
        
        MKCoordinateRegion regionThatFits = [self.mapView regionThatFits:region];
        
        NSLog(@"Fit Region %f %f", regionThatFits.center.latitude, regionThatFits.center.longitude);
        
        [self.mapView setRegion:regionThatFits animated:YES];
            [_mkView setCenterCoordinate:myPin.coordinate animated:YES];
        
        //ann.title = @"View Photo";
        //ann.subtitle = @"2/14/2014 6:30am";
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mkView addAnnotation:ann];
        });
    } else if([sharedManager.longitude doubleValue] == 0) {
        
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
        
        
        CLLocation *currentlocation = [locationManager location];
        
        CLLocationCoordinate2D coordinate = [currentlocation coordinate];
        
        NSString *str=[[NSString alloc] initWithFormat:@"current latitude:%f longitude:%f",coordinate.latitude,coordinate.longitude];
        NSLog(@"%@",str);
        
        MyAnnotation *ann = [[MyAnnotation alloc] initWithPosition:coordinate];
        //ann.title = @"View Photo";
        //ann.subtitle = @"2/14/2014 6:30am";
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mkView addAnnotation:ann];
        });
    }

}

- (void)mapView:(MKMapView *)myMapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"Center: %f %f", myMapView.region.center.latitude,myMapView.region.center.longitude);
}

#pragma mark MKMapViewDelegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    } else {
        MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ann"];
        view.pinColor = MKPinAnnotationColorPurple;
        view.enabled = YES;
        view.animatesDrop = YES;
        //view.canShowCallout = YES;
        view.draggable = YES;
        
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"palmTree.png"]];
        //view.leftCalloutAccessoryView = imageView;
       // view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return view;
    }
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        
        MyManager *sharedManager = [MyManager sharedManager];
        
        sharedManager.longitude = [NSString stringWithFormat:@"%f", droppedAt.longitude];
        
        sharedManager.latitude = [NSString stringWithFormat:@"%f", droppedAt.latitude];
        
        
        NSLog(@"sharedManager lat:%@ long:%@",sharedManager.latitude, sharedManager.longitude);
        NSLog(@"Dropped");
    }
}

- (IBAction)searchText:(id)sender {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:_searchText.text
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     if (error) {
                         NSLog(@"%@", error);
                     } else {
                         CLPlacemark *placemark = [placemarks lastObject];
                         float spanX = 0.00725;
                         float spanY = 0.00725;
                         MKCoordinateRegion region;
                         region.center.latitude = placemark.location.coordinate.latitude;
                         region.center.longitude = placemark.location.coordinate.longitude;
                         region.span = MKCoordinateSpanMake(spanX, spanY);
                         [self.mapView setRegion:region animated:YES];
                         
                     }
                 }];
}





@end
