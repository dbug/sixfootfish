//
//  MyManager.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/15/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "MyManager.h"
//#import "JSONModelLib.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>


@implementation MyManager

@synthesize date;

@synthesize latitude;

@synthesize longitude;

@synthesize species;

@synthesize notes;

@synthesize username;

@synthesize clientId;

@synthesize pounds;

@synthesize onces;

@synthesize lure;

@synthesize imageData;

@synthesize createDate;

@synthesize filename;

@synthesize fish;

@synthesize imageCoordinate;

@synthesize latDouble;

@synthesize longDouble;

@synthesize location;

@synthesize favoriteSpot;


#pragma mark Singleton Methods

+ (id)sharedManager {
    static MyManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    
    if (self = [super init]) {
        self.notes = @"No notes";
        self.species = @"Not set";
        self.latitude =  0;
        self.longitude = 0;
        NSLog(@"LONG and LAT: %@ , %@",self.longitude, self.latitude);
        //self.imageCoordinate = currentLocation;
        self.pounds = @"0";
        self.onces = @"0";
        self.lure = @"Not set";
        self.location = nil;
        
        PFUser *user = [PFUser currentUser];
        
        self.clientId = user.objectId;
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

- (void) saveJson {
    
    
    //NSLog(@"%@", [self toJSONString]);
    
    // Create PFObject with recipe information
    PFObject *fishData = [PFObject objectWithClassName:@"Fish"];
    
    [fishData setObject:self.username forKey:@"username"];
    [fishData setObject:self.date forKey:@"date"];
    [fishData setObject:self.latitude forKey:@"latitude"];
    [fishData setObject:self.longitude forKey:@"longitude"];
    [fishData setObject:self.species forKey:@"species"];
    [fishData setObject:self.notes forKey:@"notes"];
    PFFile *imageFile = [PFFile fileWithName:self.filename data:self.imageData];
    [fishData setObject:imageFile forKey:@"imageFile"];
    
    
    // Upload recipe to Parse
    [fishData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            // Show success message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved your catch" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the recipes from Parse cloud
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }
     ];

}
    


@end
