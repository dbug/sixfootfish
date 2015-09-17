//
//  CaptureDateViewController.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/15/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "CaptureDateViewController.h"
#import "MyManager.h"

@interface CaptureDateViewController ()

@property (weak, nonatomic) IBOutlet UILabel *myLabel;
- (IBAction)datePicker:(id)sender;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation CaptureDateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)datePicker:(id)sender{
    
    // NSDateFormatter automatically inits with system calendar and timezone
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // Setup an output style
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    sharedManager.date =
    [dateFormatter stringFromDate:_datePicker.date];
    
    NSLog(@"Date is %@",sharedManager.date);
    
    /*
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy HH:mm:ss"];
    
    NSString *stringFromDate = [formatter stringFromDate:sharedManager.createDate];
    
    sharedManager.date = stringFromDate;
    
    NSLog(@"DATE FORM: %@", sharedManager.date);
     */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    
    MyManager *sharedManager = [MyManager sharedManager];
    
   // NSTimeInterval ti = [sharedManager.createDate timeIntervalSince1970];
    
    
    [_datePicker setDate:sharedManager.createDate animated:NO];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy HH:mm:ss"];
    
    NSString *stringFromDate = [formatter stringFromDate:sharedManager.createDate];
    
    sharedManager.date = stringFromDate;
    
    NSLog(@"DATE FORM: %@", sharedManager.date);   
    
    
    /*
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Setup an output styl
    
    NSString *stringFromDate = [formatter stringFromDate:sharedManager.createDate];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    sharedManager.date = stringFromDate;
    
    NSLog(@"DATE FORM: %@", sharedManager.date);
     */
    
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
