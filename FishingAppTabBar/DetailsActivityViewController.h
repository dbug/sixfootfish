//
//  DetailsMapViewController.h
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/19/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fish.h"

@interface DetailsActivityViewController : UIViewController

@property (strong, nonatomic) Fish *fish;

@property (strong, nonatomic) IBOutlet UILabel *username;

@property (strong, nonatomic) IBOutlet UILabel *date;

@property (strong, nonatomic) IBOutlet UILabel *species;

@property (strong, nonatomic) IBOutlet UITextView *notes;

@property (strong, nonatomic) IBOutlet UILabel *lure;

@property (strong, nonatomic) IBOutlet UILabel *size;

@end
