//
//  AppDelegate.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/14/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Reachability.h"
#import "FishViewForMapViewController.h"
#import "MyManager.h"
#import "Fish.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x067AB5)];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];

    
    [Parse setApplicationId:@"dfeRWe9JjdK7Tqu6im2MRZrpeYVod1x8OUYaElct"
                  clientKey:@"sLajhqDs17CgmyM9cw64aK8SEw2cg22mCjP3IuyD"];
    // Override point for customization after application launch.
    
    [PFImageView class];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"This app requires internet connectivity" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    } else {
        
        NSLog(@"There IS internet connection");
        
        
    }
    
    [PFFacebookUtils initializeFacebook];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (dictionary != nil)
    {
        NSLog(@"Launched from push notification: %@", dictionary);
        NSLog(@"objectId: %@", [dictionary objectForKey:@"objectId"]);
    }
    
    return YES;
}

//
// ****************************************************************************
// App switching methods to support Facebook Single Sign-On.
// ****************************************************************************
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [[PFInstallation currentInstallation] addUniqueObject:@"" forKey:@"channels"];
    [currentInstallation saveInBackground];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"ERROR PUSH REGISTER: %@", error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"objectId is %@",[userInfo objectForKey:@"objectId"]);
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    Fish *pushFish = [[Fish alloc] init];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Fish"];
    
    //NSArray *keys = [NSArray arrayWithObjects:, nil];
    [query selectKeys:@[@"longitude",@"latitude",@"username",@"date",@"notes",@"species",@"lure",@"lure",@"pounds",@"onces",@"clientId"]];
    
    [query whereKey:@"objectId" equalTo:[userInfo objectForKey:@"objectId"]];
    NSArray* parseArray = [query findObjects];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //fast enum and grab strings and put into tempCaption array
            for (PFObject *parseObject in parseArray) {
                //ann.imageFile = [parseObject objectForKey:@"imageFile"];
                pushFish.objectId = [parseObject objectId];
                pushFish.date = [parseObject objectForKey:@"date"];
                pushFish.latitude = [parseObject objectForKey:@"latitude"];
                pushFish.longitude = [parseObject objectForKey:@"longitude"];
                pushFish.species = [parseObject objectForKey:@"species"];
                pushFish.notes = [parseObject objectForKey:@"notes"];
                pushFish.username = [parseObject objectForKey:@"username"];
                pushFish.lure = [parseObject objectForKey:@"lure"];
                pushFish.pounds = [parseObject objectForKey:@"pounds"];
                pushFish.onces = [parseObject objectForKey:@"onces"];
                pushFish.clientId = [parseObject objectForKey:@"clientId"];
                
                //pushFish.objectId = [userInfo objectForKey:@"objectId"];
                
                sharedManager.fish = pushFish;
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"New Photo" message:[userInfo objectForKey:@"message"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"View", nil];
                [alertView show];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Cancel"])
    {
        NSLog(@"Button 1 was selected.");
    }
    else if([title isEqualToString:@"View"])
    {
        NSLog(@"Button 2 was selected.");
        
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FishViewForMapViewController* MainWeb = [storyBoard instantiateViewControllerWithIdentifier:@"FishView"];
        
        UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
        
        tabController.selectedIndex = 2;
        
        UINavigationController *navigationController = (UINavigationController *)tabController.selectedViewController;
        [navigationController pushViewController:MainWeb animated:YES];

    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        NSLog(@"There IS NO internet connection");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"This app requires internet connectivity" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    } else {
        
                
        
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PFFacebookUtils session] close];
}

@end
