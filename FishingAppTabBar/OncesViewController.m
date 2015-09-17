//
//  OncesViewController.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/22/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "OncesViewController.h"
#import "MyManager.h"

@interface OncesViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewOutLet;

@end

@implementation OncesViewController

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
    
    [pickerArray addObject:@"0"];
    [pickerArray addObject:@"1"];
    [pickerArray addObject:@"2"];
    [pickerArray addObject:@"3"];
    [pickerArray addObject:@"4"];
    [pickerArray addObject:@"5"];
    [pickerArray addObject:@"6"];
    [pickerArray addObject:@"7"];
    [pickerArray addObject:@"8"];
    [pickerArray addObject:@"9"];
    [pickerArray addObject:@"10"];
    [pickerArray addObject:@"11"];
    [pickerArray addObject:@"12"];
    [pickerArray addObject:@"13"];
    [pickerArray addObject:@"14"];
    [pickerArray addObject:@"15"];
    
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
    
    sharedManager.onces = [pickerArray objectAtIndex: row];
    
    NSLog(@"Selection: %@", sharedManager.onces);
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
