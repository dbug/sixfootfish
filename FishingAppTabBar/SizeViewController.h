//
//  SizeViewController.h
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/22/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface SizeViewController : UIViewController<ADBannerViewDelegate> {
    
    IBOutlet UIPickerView *pickerView;
    NSMutableArray *pickerArray;
    
}

@end
