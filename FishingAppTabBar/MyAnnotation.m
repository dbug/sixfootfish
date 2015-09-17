//
//  MyAnnotation.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/14/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

- initWithPosition:(CLLocationCoordinate2D) coords {
    if (self = [super init]){
        self.coordinate = coords;
    }
    return self;
}



@end
