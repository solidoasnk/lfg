//
//  lfgRegisterViewController.h
//  lfg
//
//  Created by Ferran Alejandre on 6/28/13.
//  Copyright (c) 2013 Me and my dog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lfgRegisterViewController : UIViewController <UITextFieldDelegate>{
    NSFetchedResultsController *fetchResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (retain, nonatomic) NSFetchedResultsController *fetchResultsController;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
