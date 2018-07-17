//
//  NSDictionary+CLLocation.m
//  TravelNote
//
//  Created by liu  on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+CLLocation.h"

@implementation NSDictionary (CLLocation)

-(CLLocation*)locationFromGPSDictionary{
    CLLocationDegrees latitude= [(NSNumber*)[self objectForKey:(NSString*)kCGImagePropertyGPSLatitude] doubleValue];
    CLLocationDegrees longitude= [(NSNumber*)[self objectForKey:(NSString*)kCGImagePropertyGPSLongitude] doubleValue];
    CLLocationDistance altitude= [(NSNumber*)[self objectForKey:(NSString*)kCGImagePropertyGPSAltitude] doubleValue];
   
    NSTimeZone    *timeZone   = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init]; 
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"HH:mm:ss.SS"];
    NSString * timeStamp=[self objectForKey:(NSString*)kCGImagePropertyGPSTimeStamp];
    NSDate *timeDate=[formatter dateFromString:timeStamp];
    
    CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(latitude, longitude);
    CLLocation *loc=[[CLLocation alloc] initWithCoordinate:(CLLocationCoordinate2D)coordinate
                                                        altitude:altitude
                                              horizontalAccuracy:0
                                                verticalAccuracy:0
                                                       timestamp:timeDate];
    return loc;
}
@end
