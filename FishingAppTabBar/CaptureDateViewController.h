//
//  CaptureDateViewController.h
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/15/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import <iAd/iAd.h>

@protocol passData <NSObject>

-(void)setFileName:(NSString *)filename;

@end

@interface CaptureDateViewController : UIViewController <ADBannerViewDelegate>

@property (strong, nonatomic) IBOutlet UIDatePicker *MyDatePicker;

@property (weak, nonatomic) IBOutlet UILabel *imageName;

@end
