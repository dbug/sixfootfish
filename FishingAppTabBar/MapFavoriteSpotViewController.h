//
//  MapFavoriteSpotViewController.h
//  FishingAppTabBar
//
//  Created by Donald Bugden on 3/21/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

#import <CoreLocation/CoreLocation.h>


@interface MapFavoriteSpotViewController : UIViewController <MKMapViewDelegate> {
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@property (strong, nonatomic) IBOutlet UITextField *searchText;

@property (nonatomic,weak) IBOutlet UISegmentedControl *segmentedControl;

@end
