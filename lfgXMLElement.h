//
//  LFGXMLElement.h
//  LFG
//
//  Created by Ferran Alejandre on 2/15/13.
//  Copyright (c) 2013 Me and my dog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lfgXMLElement : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDictionary *attributes;
@property (strong, nonatomic) NSMutableArray *subElements;
@property (weak, nonatomic) lfgXMLElement *parent;

@end
