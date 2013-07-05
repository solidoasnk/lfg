//
//  lfgSecondViewController.h
//  lfg
//
//  Created by Ferran Alejandre on 6/24/13.
//  Copyright (c) 2013 Me and my dog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface lfgSecondViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

- (void)setUserData:(NSMutableArray *)userData;

@end
