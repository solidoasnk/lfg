//
//  lfgFirstViewController.m
//  lfg
//
//  Created by Ferran Alejandre on 6/24/13.
//  Copyright (c) 2013 Me and my dog. All rights reserved.
//

#import "lfgFirstViewController.h"
#import "lfgSecondViewController.h"
#import "lfgLoginViewController.h"

@interface lfgFirstViewController ()

@property BOOL firstRun;
@property NSMutableArray *userTableDataSource;
@property NSMutableDictionary *usersDataDictionary;

@property UIRefreshControl *refreshControl;
@property UITableView *userTableView;
@property UIActivityIndicatorView *spinner;

@property lfgFetchUserData *userReader;
@property CLLocationManager *userLocation;

@property lfgSecondViewController *mapView;

@end

@implementation lfgFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if(self.navigationItem.leftBarButtonItem == nil){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log out"
                                                                                 style:UIBarButtonSystemItemSearch
                                                                                target:self
                                                                                action:@selector(logOut:)];
    }
    
    if(self.navigationItem.rightBarButtonItem == nil){
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map"
                                                                              style:UIBarButtonSystemItemSearch
                                                                             target:self
                                                                             action:@selector(viewMap:)];
    }
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.userTableDataSource = [[NSMutableArray alloc] init];
    
    if(self.userTableView == nil){
        self.userTableView = [[UITableView alloc]
                              initWithFrame:CGRectMake(0.0f,
                                                       5.0f,
                                                       self.view.bounds.size.width,
                                                       (self.view.bounds.size.height - self.view.bounds.size.height / 2) + 50.0f)];
    }
    
    if(self.userTableView.tableFooterView == nil){
        self.userTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    self.userTableView.dataSource = self;
    
    if(self.spinner == nil){
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActionSheetStyleBlackTranslucent];
    }
    
    self.spinner.center = CGPointMake(CGRectGetMidX(self.userTableView.bounds),
                                      CGRectGetMidY(self.userTableView.bounds));
    
    [self.userTableView addSubview:self.spinner];
    
    if(self.refreshControl == nil){
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl = self.refreshControl;
        [self.refreshControl addTarget:self
                                action:@selector(handleRefresh:)
                      forControlEvents:UIControlEventValueChanged];
    }
    
    self.firstRun = YES;
    self.userTableView.userInteractionEnabled = NO;
    
    self.refreshControl.hidden = YES;
    
    [self.view addSubview:self.userTableView];
    [self.view bringSubviewToFront:self.userTableView];
    [self.userTableView addSubview:self.refreshControl];
    [self.userTableView sendSubviewToBack:self.refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayAll)
                                                 name:@"userIsRegistered"
                                               object:nil];
}

- (void)displayAll{
    self.spinner.hidden = NO;
     self.refreshControl.hidden = NO;
    [self.spinner startAnimating];
    [self performUserDataFetch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if([self.view window] == nil){
        self.mapView = nil;
        self.view = nil;
    }
}

- (void)delaySelector:(UIViewController *)topView{
    lfgLoginViewController *loginViewController = [[lfgLoginViewController alloc] init];
    loginViewController.view.bounds = self.parentViewController.view.bounds;
    [topView presentViewController:loginViewController animated:YES completion:^{
        
    }];
}

- (void)logOut:(id)paramSender{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayAll)
                                                 name:@"userLoggedIn"
                                               object:nil];
   [self performSelector:@selector(delaySelector:) withObject:self.tabBarController afterDelay:0.01];
}

- (void)viewMap:(id)paramSender{
    self.mapView = [lfgSecondViewController new];
    [self.navigationController pushViewController:self.mapView animated:YES];
    [self.mapView setUserData:self.userTableDataSource];
}

- (void)handleRefresh:(id)paramSender{
    self.userTableView.userInteractionEnabled = NO;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self performUserDataFetch];
}

- (void)updateUserDetails:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSMutableArray *insertPaths = [NSMutableArray array];
    NSMutableArray *deletePaths = [NSMutableArray array];
    
    if(notification.object != nil){
        if(!self.firstRun){
            
            for(int i = 0; i < [self.userTableDataSource count]; i++){
                NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
                [deletePaths addObject:path];
            }
            [self.userTableDataSource removeAllObjects];
            int i = 0;
            
            for(id key in notification.object){
                NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
                [insertPaths addObject:path];
                [self.userTableDataSource insertObject:[notification.object objectForKey:key] atIndex:i];
                i++;
            }
        }else{
            int i = 0;
            for(id key in notification.object){
                NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
                [insertPaths addObject:path];
                [self.userTableDataSource insertObject:[notification.object objectForKey:key] atIndex:i];
                i++;
            }
        }
    
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
        NSArray *tmpSortingArray = [self.userTableDataSource
                                    sortedArrayUsingDescriptors:[NSMutableArray arrayWithObject:sortDescriptor]];
    
        for(int i = 0; i < [tmpSortingArray count] ;i++){
            [self.userTableDataSource replaceObjectAtIndex:i withObject:[tmpSortingArray objectAtIndex:i]];
        }
    }else{
        if(!self.firstRun){
            NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
            [deletePaths addObject:path];
            [self.userTableDataSource removeAllObjects];
        }
        
        NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
        NSMutableDictionary *noDataDic = [[NSMutableDictionary alloc] init];
        
        [insertPaths addObject:path];
        [noDataDic setValue:@"1" forKey:@"noData"];
        [self.userTableDataSource insertObject:noDataDic atIndex:0];
    }
    
    self.usersDataDictionary = notification.object;
    
    if(self.firstRun){
        self.firstRun = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.userTableView beginUpdates];
        
        [self.userTableView insertRowsAtIndexPaths:insertPaths
                                  withRowAnimation:UITableViewRowAnimationTop];
        [self.userTableView deleteRowsAtIndexPaths:deletePaths
                                  withRowAnimation:UITableViewRowAnimationBottom];
        
        [self.userTableView endUpdates];
         
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
        if(!self.spinner.hidden){
            [self.spinner stopAnimating];
            self.spinner.hidden = YES;
        }
        
        self.userTableView.userInteractionEnabled = YES;
        [self.refreshControl endRefreshing];
        self.userReader = nil;
    });
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self.userLocation stopUpdatingLocation];
    
    CLLocation *lastKnownLocation = [locations lastObject];
    
    if(self.userReader == nil){
        self.userReader = [[lfgFetchUserData alloc] init];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserDetails:)
                                                 name:@"userDataUpdated"
                                               object:nil];
    
    [self.userReader fetchData:[NSNumber numberWithDouble:lastKnownLocation.coordinate.latitude]
                     longitude:[NSNumber numberWithDouble:lastKnownLocation.coordinate.longitude]
                      distance:[NSNumber numberWithDouble:1000000.0f]];
}

- (void)performUserDataFetch{
    if([CLLocationManager locationServicesEnabled]){
        if(self.userLocation == nil){
            self.userLocation = [[CLLocationManager alloc] init];
        }
        self.userLocation.delegate = self;
        self.userLocation.desiredAccuracy = kCLLocationAccuracyBest;
        self.userLocation.pausesLocationUpdatesAutomatically = YES;
        
        [self.userLocation startUpdatingLocation];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger result = 0;
    
    if([tableView isEqual:self.userTableView]){
        result = [self.userTableDataSource count];
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    
    if([tableView isEqual:self.userTableView]){
        if([self.userTableDataSource count] > section){
            result = [self.userTableDataSource count];
        }
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if([tableView isEqual:self.userTableView]){
        static NSString *CellIdentifier = @"userName";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:CellIdentifier];
        
        NSDictionary *userCellData = [self.userTableDataSource objectAtIndex:indexPath.row];
        
        NSString *noDataChlnge = [userCellData objectForKey:@"noData"];

        if(noDataChlnge == nil){
            UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f,
                                                                           10.f,
                                                                           self.userTableView.bounds.size.width / 2,
                                                                           30.0f)];
            userNameLabel.textAlignment = NSTextAlignmentLeft;
        
            UILabel *userDistanceLabel = [[UILabel alloc]
                                      initWithFrame:CGRectMake((self.userTableView.bounds.size.width / 2) + 15.0f,
                                                               10.0f,
                                                               (self.userTableView.bounds.size.width / 2) - 30.0f,
                                                               30.0f)];
            
            userDistanceLabel.textAlignment = NSTextAlignmentRight;
        
            userNameLabel.text = [NSString stringWithFormat:@"%@", [userCellData objectForKey:@"userName"]];
            userDistanceLabel.text = [NSString stringWithFormat:@"%.02f", [[userCellData
                                                                        objectForKey:@"distance"] doubleValue]];
        
            userDistanceLabel.text = [userDistanceLabel.text stringByAppendingString:@"m."];
            if([[userCellData
                 objectForKey:@"distance"] doubleValue] <= 50){
                userDistanceLabel.textColor = [UIColor blueColor];
            }else if([[userCellData
                       objectForKey:@"distance"] doubleValue] > 50 &&
                     [[userCellData
                      objectForKey:@"distance"] doubleValue] <= 200){
                userDistanceLabel.textColor = [UIColor magentaColor];
            }else{
                userDistanceLabel.textColor = [UIColor purpleColor];
            }
            //NSLog(@"%@ - %@", [userCellData objectForKey:@"lat"],[userCellData objectForKey:@"lng"]);
            [cell addSubview:userNameLabel];
            [cell addSubview:userDistanceLabel];
        }else{
            UILabel *userNameLabel = [[UILabel alloc]
                                      initWithFrame:CGRectMake(15.0f,
                                                               10.f,
                                                               self.userTableView.bounds.size.width - 15,
                                                               30.0f)];
            
            userNameLabel.textAlignment = NSTextAlignmentCenter;
            
            userNameLabel.text = @"No people found nearby";
                        
            [cell addSubview:userNameLabel];
        }
    }
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     NSLog(@"Navigating away");
 }*/

@end
