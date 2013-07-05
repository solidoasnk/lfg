//
//  LFGXMLElement.m
//  LFG
//
//  Created by Ferran Alejandre on 2/15/13.
//  Copyright (c) 2013 Me and my dog. All rights reserved.
//

#import "lfgXMLElement.h"

@implementation lfgXMLElement

-(NSMutableArray *) subElements{
    if(_subElements == nil){
        _subElements = [[NSMutableArray alloc] init];
    }
    return _subElements;
}

@end
