//
//  lfgFirstViewController.h
//  lfg
//
//  Created by Ferran Alejandre on 6/24/13.
//  Copyright (c) 2013 Me and my dog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "lfgFetchUserData.h"

@interface lfgFirstViewController : UIViewController <  CLLocationManagerDelegate,
                                                        UITableViewDelegate,
                                                        UITableViewDataSource>

@end
