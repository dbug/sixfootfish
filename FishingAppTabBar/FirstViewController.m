//
//  FirstViewController.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/14/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "FirstViewController.h"
#import "MyManager.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"


@class GADBannerView;
@class GADRequest;

@interface FirstViewController (){
    IBOutlet UIImageView * _imageView;
	IBOutlet UILabel * _label;
}


@end

@implementation FirstViewController



- (IBAction)selectPhoto:(id)sender {
    [self startCameraControllerFromViewController:self usingDelegate:self];
}



#pragma mark - UIImagePickerControllerDelegate methods

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate {
	if (([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == NO) || (delegate == nil) || (controller == nil))
		return NO;
    
	UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
	cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
	cameraUI.delegate = delegate;
	[controller presentViewController:cameraUI animated:YES completion:nil];
	return YES;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage * image = info[UIImagePickerControllerOriginalImage];
	_label.text = [NSString stringWithFormat:@"Have image: %d x %d", (int) image.size.width, (int) image.size.height];
	_imageView.image = image;
    MyManager *sharedManager = [MyManager sharedManager];
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 250*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    NSURL *url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:url
                   resultBlock:^(ALAsset *asset) {
                       NSDate *myDate = [asset valueForProperty:ALAssetPropertyDate];
                       CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
                       
                       NSLog(@"LONG FROM IMAGE: %f", location.coordinate.longitude);
                       
                       NSString *imageLat = [[NSNumber numberWithDouble:location.coordinate.latitude] stringValue];
                       
                       NSString *imageLong =[[NSNumber numberWithDouble:location.coordinate.longitude] stringValue];
                       
                       sharedManager.latitude = imageLat;
                       
                       sharedManager.longitude = imageLong;
                       
                       sharedManager.createDate = myDate;
                       
                       sharedManager.location = [PFGeoPoint geoPointWithLatitude:[sharedManager.latitude doubleValue] longitude:[sharedManager.longitude doubleValue]];
                       
                       NSLog(@"Date: %@", myDate);
                   } failureBlock:^(NSError *error) {
                       NSLog(@"Error");
                   }];

    
    sharedManager.imageData = imageData;
    
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    sharedManager.filename = [[imageURL path] lastPathComponent];
    
    [NSString stringWithFormat:@"%@", sharedManager.filename];
    
	[self dismissViewControllerAnimated:YES completion:nil];
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [super viewDidLoad];
    [self decideViewController];
    
    
     /* Initialize the banner at the bottom of the screen.
    CGPoint origin = CGPointMake(0.0,self.view.frame.size.height -
                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height-50);
     
     // Use predefined GADAdSize constants to define the GADBannerView.
     self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
     
     self.adBanner.adUnitID = @"ca-app-pub-8015116409018415/4489198269";
     self.adBanner.delegate = self;
     self.adBanner.rootViewController = self;
     [self.view addSubview:self.adBanner];
    
    [self.adBanner loadRequest:[self request]];
    
	// Do any additional setup after loading the view, typically from a nib.
      */
}

- (void) decideViewController  {
    
    PFUser *user = [PFUser currentUser];
    NSLog(@"USER: %@",user.username);
    if (user.username == NULL) {
    
    self.navigationController.navigationBarHidden = YES;
        
    self.hidesBottomBarWhenPushed = YES;
        // Assuming you don't want a navigationbar
    UIViewController *screen = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    [self.navigationController pushViewController:screen animated:NO]; // so it looks like it's the first view to get loaded
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear{
        [self decideViewController];
    self.navigationController.navigationBarHidden = NO;
}


- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    //request.testDevices = @[
    // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
    // the console when the app is launched.
    //GAD_SIMULATOR_ID,
    //@"2968cc6404f7edb5a6fa4d9f15f26a04"
    //];
    
    return request;
}

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}


@end
