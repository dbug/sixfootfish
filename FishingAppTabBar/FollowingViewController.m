//
//  ActivityView.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/17/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "ActivityView.h"
#import "FollowingViewController.h"
#import "Fish.h"
#import "FollowingMapViewController.h"


@interface FollowingViewController ()

@end

@implementation FollowingViewController {
    
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Follow";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"objectId";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"refreshTable"
                                               object:nil];
}

- (void)refreshTable:(NSNotification *) notification
{
    // Reload the recipes
    [self loadObjects];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTable" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    /*    if ([self.objects count] == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }*/
    
    //[query orderByAscending:@"name"];
    
    PFUser *user = [PFUser currentUser];
    NSString *objectId = user.objectId;
    
    [query whereKey:@"followerId" containsString:objectId];
    
    [query orderByDescending:@"createdAt"];
    
    
    return query;
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"FollowingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    //nameLabel.text = [object objectForKey:@"followingId"];
    
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"objectId" equalTo:[object objectForKey:@"followingId"]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if ([object objectForKey:@"displayName"] != NULL) {
            nameLabel.text = [object objectForKey:@"displayName"];
        } else {
            nameLabel.text = [object objectForKey:@"username"];
        // code
        }
    }];
    
    
    return cell;
}




 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Remove the row from data model
 PFObject *object = [self.objects objectAtIndex:indexPath.row];
 [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
 [self refreshTable:nil];
 }];
 }


- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"showFollowingDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         
         FollowingMapViewController *destViewController = [[FollowingMapViewController alloc]init];
         
         destViewController = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
         NSLog(@"OBJECT ID: %@",[object objectForKey:@"followingId"]);
         
         destViewController.followingId = [object objectForKey:@"followingId"];
         
         
    }
}

@end


