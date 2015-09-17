//
//  SizeViewController.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/22/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "SizeViewController.h"
#import "MyManager.h"

@interface SizeViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewOutLet;

@end

@implementation SizeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [pickerArray addObject:@"16"];
    [pickerArray addObject:@"17"];
    [pickerArray addObject:@"18"];
    [pickerArray addObject:@"19"];
    [pickerArray addObject:@"20"];
    [pickerArray addObject:@"21"];
    [pickerArray addObject:@"22"];
    [pickerArray addObject:@"23"];
    [pickerArray addObject:@"24"];
    [pickerArray addObject:@"25"];
    [pickerArray addObject:@"26"];
    [pickerArray addObject:@"27"];
    [pickerArray addObject:@"28"];
    [pickerArray addObject:@"29"];
    [pickerArray addObject:@"30"];
    [pickerArray addObject:@"31"];
    [pickerArray addObject:@"32"];
    [pickerArray addObject:@"33"];
    [pickerArray addObject:@"34"];
    [pickerArray addObject:@"35"];
    
    [pickerArray addObject:@"36"];
    [pickerArray addObject:@"37"];
    [pickerArray addObject:@"38"];
    [pickerArray addObject:@"39"];
    [pickerArray addObject:@"40"];
    [pickerArray addObject:@"41"];
    [pickerArray addObject:@"42"];
    [pickerArray addObject:@"43"];
    [pickerArray addObject:@"44"];
    [pickerArray addObject:@"45"];
    [pickerArray addObject:@"46"];
    [pickerArray addObject:@"47"];
    [pickerArray addObject:@"48"];
    [pickerArray addObject:@"49"];
    [pickerArray addObject:@"50"];
    [pickerArray addObject:@"51"];
    [pickerArray addObject:@"52"];
    [pickerArray addObject:@"53"];
    [pickerArray addObject:@"54"];
    [pickerArray addObject:@"55"];
    [pickerArray addObject:@"56"];
    [pickerArray addObject:@"57"];
    [pickerArray addObject:@"58"];
    [pickerArray addObject:@"59"];
    [pickerArray addObject:@"60"];
    [pickerArray addObject:@"61"];
    [pickerArray addObject:@"62"];
    [pickerArray addObject:@"63"];
    [pickerArray addObject:@"64"];
    [pickerArray addObject:@"65"];
    [pickerArray addObject:@"66"];
    [pickerArray addObject:@"67"];
    [pickerArray addObject:@"68"];
    [pickerArray addObject:@"69"];
    [pickerArray addObject:@"70"];
    
    [pickerArray addObject:@"71"];
    [pickerArray addObject:@"72"];
    [pickerArray addObject:@"73"];
    [pickerArray addObject:@"74"];
    [pickerArray addObject:@"75"];
    [pickerArray addObject:@"76"];
    [pickerArray addObject:@"77"];
    [pickerArray addObject:@"78"];
    [pickerArray addObject:@"79"];
    [pickerArray addObject:@"80"];
    [pickerArray addObject:@"81"];
    [pickerArray addObject:@"82"];
    [pickerArray addObject:@"83"];
    [pickerArray addObject:@"84"];
    [pickerArray addObject:@"85"];
    [pickerArray addObject:@"86"];
    [pickerArray addObject:@"87"];
    [pickerArray addObject:@"88"];
    [pickerArray addObject:@"89"];
    [pickerArray addObject:@"90"];
    [pickerArray addObject:@"91"];
    [pickerArray addObject:@"92"];
    [pickerArray addObject:@"93"];
    [pickerArray addObject:@"94"];
    [pickerArray addObject:@"95"];
    [pickerArray addObject:@"96"];
    [pickerArray addObject:@"97"];
    [pickerArray addObject:@"98"];
    [pickerArray addObject:@"99"];
    [pickerArray addObject:@"100"];
    
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
    
    sharedManager.pounds = [pickerArray objectAtIndex: row];
    
    NSLog(@"Selection: %@", sharedManager.pounds);
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
