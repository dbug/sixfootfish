//
//  Fish.h
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/17/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Fish : NSObject

@property (nonatomic, strong) PFFile *imageFile;

@property (nonatomic, strong) NSString *objectId;

@property (nonatomic, strong) NSString *clientId;

@property (nonatomic,strong) NSString *date;

@property (nonatomic,strong) NSString *latitude;

@property (nonatomic,strong) NSString *longitude;

@property (nonatomic,strong) NSString *notes;

@property (nonatomic,strong) NSString *species;

@property (nonatomic,strong) NSString *username;

@property (nonatomic,strong) NSString *pounds;

@property (nonatomic,strong) NSString *onces;

@property (nonatomic,strong) NSString *lure;

@property (nonatomic,strong) NSString *followingId;

@end
