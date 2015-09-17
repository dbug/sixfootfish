//
//  FirstViewController.h
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/14/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface FirstViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *imageName;

@property(nonatomic, strong) GADBannerView *adBanner;

@end
