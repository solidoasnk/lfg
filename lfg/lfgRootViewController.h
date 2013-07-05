//
//  lfgRootViewController.h
//  lfg
//
//  Created by Ferran Alejandre on 6/27/13.
//  Copyright (c) 2013 Me and my dog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface lfgRootViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
