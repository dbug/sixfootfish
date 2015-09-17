//
//  DropPinViewController.h
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/15/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DropPinViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchText;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic,weak) IBOutlet UISegmentedControl *segmentedControl;




@end
