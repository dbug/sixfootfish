//
//  MyAnnotation.h
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/14/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface MyAnnotation : NSObject <MKAnnotation, MKMapViewDelegate>
// Normally, there'd be some variables that contain the name and location.
// And maybe some means to populate them from a URL or a database.
// This example hard codes everything.

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *reuseIdentifier;
@property BOOL canShowCallout;
@property (nonatomic, strong) PFFile *imageFile;
@property (nonatomic, copy) NSString *objectId;

@property (nonatomic,strong) NSString *date;

@property (nonatomic,strong) NSString *latitude;

@property (nonatomic,strong) NSString *longitude;

@property (nonatomic,strong) NSString *notes;

@property (nonatomic,strong) NSString *species;

@property (nonatomic,strong) NSString *username;

@property (nonatomic,strong) NSString *pounds;

@property (nonatomic,strong) NSString *onces;

@property (nonatomic,strong) NSString *lure;

@property (nonatomic,strong) NSString *clientId;


- initWithPosition:(CLLocationCoordinate2D) coords;

@end