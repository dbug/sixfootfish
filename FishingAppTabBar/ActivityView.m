//
//  ActivityView.m
//  FishingAppTabBar
//
//  Created by Donald Bugden on 2/17/14.
//  Copyright (c) 2014 Donnie Bugden. All rights reserved.
//

#import "ActivityView.h"
#import "FishViewDetail.h"
#import "Fish.h"
#import "MyManager.h"


@interface ActivityView ()

@end

@implementation ActivityView  {
    
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Fish";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"objectId";
        
        self.imageKey = @"imageFile";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
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
        if ([self.objects count] == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }
    
    //[query orderByAscending:@"name"];
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
/*
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *identifier = @"FishCell";
    PFTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:identifier];
    }
    //PFFile *thumbnail = [object objectForKey:@"imageFile"];
    //cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    //cell.imageView.file = thumbnail;
    
    PFFile *imageFile = [object objectForKey:@"imageFile"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            NSLog(@"erroring:%@", error);
        } else if (!error){
        // Now that the data is fetched, update the cell's image property.
        cell.imageView.image = [UIImage imageWithData:data];
        }
    }];
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = [object objectForKey:@"username"];
    
    return cell;
}
*/


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"FishCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    /* Configure the cell
    PFFile *thumbnail = [object objectForKey:@"imageFile"];
    PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:103];
    thumbnailImageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        // Now that the data is fetched, update the cell's image property.
       thumbnailImageView.image = [UIImage imageWithData:data];
    }];
    // Set your placeholder image first
    /* cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    PFFile *imageFile = [object objectForKey:@"imageFile"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        // Now that the data is fetched, update the cell's image property.
        cell.imageView.image = [UIImage imageWithData:data];
    }];
*/
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = [object objectForKey:@"username"];
    
    //UILabel *prepTimeLabel = (UILabel*) [cell viewWithTag:102];
    //prepTimeLabel.text = [object objectForKey:@"species"];
    
    return cell;
}


/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self refreshTable:nil];
    }];
}
 */

- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFishDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //FishViewDetail *destViewController = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        Fish *fish = [[Fish alloc] init];
        fish.imageFile = [object objectForKey:@"imageFile"];
        
        fish.objectId = [object objectId];
        fish.date = [object objectForKey:@"date"];
        
        fish.latitude = [object objectForKey:@"latitude"];
        
        fish.longitude = [object objectForKey:@"longitude"];
        
        fish.notes = [object objectForKey:@"notes"];
        
        fish.species = [object objectForKey:@"species"];
        
        fish.username = [object objectForKey:@"username"];
        
        fish.pounds = [object objectForKey:@"pounds"];
        
        fish.onces = [object objectForKey:@"onces"];
        
        fish.lure = [object objectForKey:@"lure"];
        
        fish.clientId = [object objectForKey:@"clientId"];
        
        NSLog(@"Actity View Fish Uesername: %@", fish.username );
        
        //destViewController.fish = fish;
        
        MyManager *sharedManager = [MyManager sharedManager];
        
        sharedManager.fish = fish;
        
    }
}

@end
 

