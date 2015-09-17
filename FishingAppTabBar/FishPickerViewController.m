//
//  FishPickerViewController.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/15/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "FishPickerViewController.h"
#import "MyManager.h"
//#import "JSONModel.h"
//#import "JSONModelLib.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface FishPickerViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewOutLet;


@end

@implementation FishPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    pickerArray = [[NSMutableArray alloc] init];
    [pickerArray addObject:@"american shad"];
    [pickerArray addObject:@"black crappie"];
    [pickerArray addObject:@"blue catfish"];
    [pickerArray addObject:@"bluegill"];
    [pickerArray addObject:@"bodie bass"];
    [pickerArray addObject:@"bowfin"];
    [pickerArray addObject:@"brook trout"];
    [pickerArray addObject:@"brown trout"];
    [pickerArray addObject:@"bullhead catfish"];
    [pickerArray addObject:@"chain pickerel"];
    [pickerArray addObject:@"channel catfish"];
    [pickerArray addObject:@"common carp"];
    [pickerArray addObject:@"flathead catfish"];
    [pickerArray addObject:@"green sunfish"];
    [pickerArray addObject:@"hickory shad"];
    [pickerArray addObject:@"largemouth bass"];
    [pickerArray addObject:@"muskellunge"];
    [pickerArray addObject:@"pumpkinseed"];
    [pickerArray addObject:@"rainbow trout"];
    [pickerArray addObject:@"redbreast sunfish"];
    [pickerArray addObject:@"redear sunfish"];
    [pickerArray addObject:@"roanoke bass"];
    [pickerArray addObject:@"rock bass"];
    [pickerArray addObject:@"smallmouth bass"];
    [pickerArray addObject:@"spotted bass"];
    [pickerArray addObject:@"striped bass"];
    [pickerArray addObject:@"walleye"];
    [pickerArray addObject:@"warmouth"];
    [pickerArray addObject:@"white bass"];
    [pickerArray addObject:@"white catfish"];
    [pickerArray addObject:@"white crappie"];
    [pickerArray addObject:@"white perch"];
    [pickerArray addObject:@"yellow perch"];
    [pickerArray addObject:@"OTHER"];
    
    [pickerView selectedRowInComponent:0];
}

// Number of components.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex: row];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"You selected this: %@", [pickerArray objectAtIndex: row]);
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    sharedManager.species = [pickerArray objectAtIndex: row];
    
        NSLog(@"Selection: %@", sharedManager.species);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// Method is called when the iAd is loaded.
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    // Creates animation.
    [UIView beginAnimations:nil context:nil];
    
    // Sets the duration of the animation to 1.
    [UIView setAnimationDuration:1];
    
    // Sets the alpha to 1.
    // We do this because we are going to have it set to 0 to start and setting it to 1 will cause the iAd to fade into view.
    [banner setAlpha:1];
    
    //  Performs animation.
    [UIView commitAnimations];
    
}

// Method is called when the iAd fails to load.
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    // Creates animation.
    [UIView beginAnimations:nil context:nil];
    
    // Sets the duration of the animation to 1.
    [UIView setAnimationDuration:1];
    
    // Sets the alpha to 0.
    // We do this because we are going to have it set to 1 to start and setting it to 0 will cause the iAd to fade out of view.
    [banner setAlpha:0];
    
    //  Performs animation.
    [UIView commitAnimations];
    
}
@end
