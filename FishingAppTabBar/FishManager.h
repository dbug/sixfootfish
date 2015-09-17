//
//  FishManager.h
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/19/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Fish.h"

@interface FishManager : NSObject

@property (nonatomic, strong) PFFile *imageFile;
@property (nonatomic, strong) Fish *fish;
@end
