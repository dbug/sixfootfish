//
//  SecondViewController.h
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/14/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FollowingMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic)
NSString *followingId;

@property (nonatomic,weak) IBOutlet UISegmentedControl *segmentedControl;

@end

