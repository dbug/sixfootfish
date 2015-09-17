//
//  UploadDataGlobal.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/15/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "UploadDataGlobal.h"

@interface MyDataModel : NSObject
{
}

+ (MyDataModel *) sharedDataModel;

@end

@implementation MyDataModel

static MyDataModel *sharedDataModel = nil;

+ (MyDataModel *) sharedDataModel
{
    
    @synchronized(self)
    {
        if (sharedDataModel == nil)
        {
            sharedDataModel = [[MyDataModel alloc] init];
        }
    }
    return sharedDataModel;
}

@end