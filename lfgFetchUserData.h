//
//  LFGFetchUserData.h
//  LFG
//
//  Created by Ferran Alejandre on 2/14/13.
//  Copyright (c) 2013 Me and my dog. All rights reserved.
//

#import "lfgXMLElement.h"

#import <Foundation/Foundation.h>

@class lfgXMLElement;

@interface lfgFetchUserData : NSURLConnection <NSXMLParserDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (strong, nonatomic) NSDictionary *userDataSet;
@property (retain, nonatomic) NSMutableData *recievedData;

@property (strong, nonatomic) lfgXMLElement *rootElement;
@property (strong, nonatomic) lfgXMLElement *currentElementPointer;

-(void)fetchData:(NSNumber *)latitude
       longitude:(NSNumber *)longitude
        distance:(NSNumber *)dist;
@end
