//
//  FishViewDetail.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/17/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "FishViewDetail.h"
#import "Fish.h"
#import "MyManager.h"
#import "DetailsActivityViewController.h"

@interface FishViewDetail ()

@end

@implementation FishViewDetail

@synthesize fishPhoto;
@synthesize fish;


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
    
    self.fishPhoto.file = fish.imageFile;
    
        NSLog(@"FISH Loaded: %@", fish.username);
    
}

- (void)viewDidUnload
{
    [self setFishPhoto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)gotoDetails:(id)sender {
    DetailsActivityViewController *det=[[DetailsActivityViewController alloc]init];
    NSLog(@"FISH OBJ ID: %@", self.fish.objectId);
    det.fish = self.fish;
    [self.navigationController pushViewController:det animated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFishActivityDetail"]) {

    
        DetailsActivityViewController *det=[[DetailsActivityViewController alloc]init];
        
        det = [segue destinationViewController];
        NSLog(@"FISH OBJ ID: %@", self.fish.objectId);
        det.fish = self.fish;
        
    }
}

@end

