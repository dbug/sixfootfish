//
//  SecondViewController.h
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/14/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <iAd/iAd.h>
#import "GADInterstitial.h"
#import "GADBannerView.h"

@interface SecondViewController : UIViewController <MKMapViewDelegate,ADBannerViewDelegate> {
    GADBannerView *adBanner;
}

@property (nonatomic,weak) IBOutlet UISegmentedControl *segmentedControl;

@end


