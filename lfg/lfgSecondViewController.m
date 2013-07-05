//
//  lfgSecondViewController.m
//  lfg
//
//  Created by Ferran Alejandre on 6/24/13.
//  Copyright (c) 2013 Me and my dog. All rights reserved.
//

#import "lfgSecondViewController.h"
#import "lfgUserAnnotation.h"

@interface lfgSecondViewController ()

@property CLLocationManager *userLocation;
@property IBOutlet MKMapView *mapView;
@property IBOutlet UIBarButtonItem *myLocationButton;
@property NSMutableArray *usersData;
@property NSString *color;

@end

@implementation lfgSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if(self.mapView == nil){
        self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    }
    self.mapView.delegate = self;
    
    self.mapView.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                          CGRectGetMidY(self.view.bounds));
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.mapType = MKMapTypeHybrid;
    
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    [self.view addSubview:self.mapView];
    
    self.userLocation = [[CLLocationManager alloc] init];
    self.userLocation.delegate = self;
    self.userLocation.desiredAccuracy = kCLLocationAccuracyBest;
    self.userLocation.pausesLocationUpdatesAutomatically = NO;
    [self.userLocation startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if([self.view window] == nil){
        self.view = nil;
    }
}

-(IBAction)updateMyLocation:(id)sender{
    if([CLLocationManager locationServicesEnabled]){
        self.userLocation = [[CLLocationManager alloc] init];
        self.userLocation.delegate = self;
        self.userLocation.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.userLocation.pausesLocationUpdatesAutomatically = NO;
        [self.userLocation startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *lastKnownLocation = [locations lastObject];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta = 0.0035f;
    span.longitudeDelta = 0.0035f;
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(
                                                                 lastKnownLocation.coordinate.latitude,
                                                                 lastKnownLocation.coordinate.longitude);
    region.span = span;
    region.center = location,
    
    self.mapView.showsUserLocation = YES;
    self.mapView.userLocation.coordinate = location;
    
    [self addUserAnnotations];
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
    [self.userLocation stopUpdatingLocation];
    self.userLocation = nil;
    
}

- (void)setUserData:(NSMutableArray *)userData{
    self.usersData = userData;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *result = nil;
    
    if(annotation != mapView.userLocation){
        lfgUserAnnotation *pinAnnotation = (lfgUserAnnotation *)annotation;
        
        UIImage *image = [UIImage imageNamed:pinAnnotation.imageName];
        
        CGRect resizeRect;
        resizeRect.size.height = image.size.height / 4;
        resizeRect.size.width = image.size.width / 4;
        resizeRect.origin = (CGPoint){0,0};
        
        UIGraphicsBeginImageContext(resizeRect.size);
        
        [image drawInRect:resizeRect];
        
        UIImage *resizedIMage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        static NSString *defaultPinId = @"otherUserPin";
        
        result = (MKPinAnnotationView *)[mapView
                                          dequeueReusableAnnotationViewWithIdentifier:defaultPinId];
        if(result == nil){
            result = [[MKAnnotationView alloc]
                   initWithAnnotation:annotation reuseIdentifier:defaultPinId];
            
            [result setAlpha:0.8f];
            
            result.canShowCallout = YES;
            result.image = resizedIMage;
        }
    }
    return result;
}

- (void)addUserAnnotations{
    for(int i = 0;i < [self.usersData count]; i++){
        NSString *pinImage = @"bluePin.png";
        NSMutableDictionary *userData = [self.usersData objectAtIndex:i];
        
        NSString *noUsersNearbyCheck = [userData objectForKey:@"userName"];
        
        if(noUsersNearbyCheck != nil){
            CLLocationCoordinate2D otherUserLocation = CLLocationCoordinate2DMake([[userData objectForKey:@"lat"] doubleValue],
                                                                              [[userData objectForKey:@"lng"] doubleValue]);
            if([[userData objectForKey:@"distance"] doubleValue] <= 100){
                pinImage = @"greenPin.png";
            }else if([[userData objectForKey:@"distance"] doubleValue] > 100 &&
                    [[userData objectForKey:@"distance"] doubleValue] <= 500){
                pinImage = @"orangePin.png";
            }else{
                pinImage = @"redPin.png";
            }
        
            lfgUserAnnotation *otherUserAnnotation = [[lfgUserAnnotation alloc]
                                                  initWithCoordinates:otherUserLocation
                                                  title:[userData objectForKey:@"userName"]
                                                  subtitle:@"asd"
                                                  imageString:pinImage];
        
            [self.mapView addAnnotation:otherUserAnnotation];
        }
    }
}
@end
