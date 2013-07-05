//
//  lfgUserAnnotation.h
//  lfg
//
//  Created by Ferran Alejandre on 7/1/13.
//  Copyright (c) 2013 Me and my dog. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface lfgUserAnnotation : NSObject <MKAnnotation>

@property (nonatomic, unsafe_unretained,readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subTitle;
@property (nonatomic, copy, readonly) NSString *imageName;

- (id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                   title:(NSString *)paramTitle
                 subtitle:(NSString *)paramSubtitle
              imageString:(NSString *)paramImage;
;

@end
