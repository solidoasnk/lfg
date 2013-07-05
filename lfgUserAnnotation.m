//
//  lfgUserAnnotation.m
//  lfg
//
//  Created by Ferran Alejandre on 7/1/13.
//  Copyright (c) 2013 Me and my dog. All rights reserved.
//

#import "lfgUserAnnotation.h"

@implementation lfgUserAnnotation

- (id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                    title:(NSString *)paramTitle
                 subtitle:(NSString *)paramSubtitle
                imageString:(NSString *)paramImage{
    self = [super init];
    if (self != nil) {
        // Initialization code
        _coordinate = paramCoordinates;
        _title = paramTitle;
        _subTitle = paramSubtitle;
        _imageName = paramImage;
    }
    return self;
}

@end
