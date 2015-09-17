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

@interface FishViewDetail : UIViewController

@property (strong, nonatomic) IBOutlet PFImageView *fishPhoto;

@property (nonatomic, strong) Fish *fish;

@end
