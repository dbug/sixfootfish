//
//  SearchMapViewController.h
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/23/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

#import <CoreLocation/CoreLocation.h>

#import "GADBannerView.h"

@interface MyMapViewController : UIViewController <MKMapViewDelegate> {
    //GADBannerView *adBanner;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic,weak) IBOutlet UISegmentedControl *segmentedControl;


/*
 @property(nonatomic, strong) GADBannerView *adBanner;
 */

@end
