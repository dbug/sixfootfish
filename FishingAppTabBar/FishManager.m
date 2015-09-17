//
//  FishManager.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/19/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "FishManager.h"

@implementation FishManager


#pragma mark Singleton Methods

+ (id)sharedManager {
    static FishManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}
@end
