//
//  User.h
//  lfg
//
//  Created by Ferran Alejandre on 7/4/13.
//  Copyright (c) 2013 Me and my dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * userHash;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userPassword;
@property (nonatomic, retain) NSString * userMail;

@end
