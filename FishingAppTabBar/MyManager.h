//
//  MyManager.h
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/15/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "JSONModel.h"
#import <Parse/Parse.h>
#import "Fish.h"

@interface MyManager : NSObject {
    NSString *date;
    NSString *latitude;
    NSString *longitude;
    NSString *species;
    NSString *notes;
    NSString *username;
    NSData *imageData;
    NSString *fileName;
    NSString *favoriteSpot;
    Fish *fish;
    
}

@property (nonatomic, retain) NSString *date;

@property (nonatomic, retain) NSString *latitude;

@property (nonatomic, retain) NSString *longitude;

@property (nonatomic, retain) NSString *species;

@property (nonatomic, retain) NSString *notes;

@property (nonatomic, retain) NSString *username;

@property (nonatomic, retain) NSString *clientId;

@property (nonatomic, retain) NSString *pounds;

@property (nonatomic, retain) NSString *onces;

@property (nonatomic, retain) NSString *lure;


@property NSData *imageData;

@property NSDate *createDate;

@property (nonatomic, retain) NSString *filename;

@property (nonatomic, retain) Fish *fish;

@property (nonatomic) CLLocationCoordinate2D *imageCoordinate;

@property float *latDouble;

@property float *longDouble;

@property PFGeoPoint *location;

@property (nonatomic, retain) NSString *favoriteSpot;

+ (id)sharedManager;

- (void) saveJson;


@end
