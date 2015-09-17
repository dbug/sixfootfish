//
//  FishViewDetail.h
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/17/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Fish.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import <iAd/iAd.h>


@class GADBannerView;
@class GADRequest;

@interface FishViewForMapViewController : UIViewController<GADBannerViewDelegate,ADBannerViewDelegate>

@property(nonatomic, strong) GADBannerView *adBanner;

- (GADRequest *)request;

//@property (strong, nonatomic) IBOutlet PFImageView *fishPhoto;

@property (strong, nonatomic) IBOutlet PFImageView *fishPhoto;

@property (strong, nonatomic) PFFile *file;

@property (strong, nonatomic) IBOutlet PFImageView *image;

@property (nonatomic, strong) Fish *fish;

@end