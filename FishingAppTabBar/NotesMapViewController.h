//
//  NotesMapViewController.h
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/22/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fish.h"
#import <iAd/iAd.h>

@interface NotesMapViewController : UIViewController <ADBannerViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *notes;

@property (strong, nonatomic) Fish *fish;

@end
