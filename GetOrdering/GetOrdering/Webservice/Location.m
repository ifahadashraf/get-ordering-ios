//
//  Location.m
//  Water
//
//  Created by shahbaz tariq on 1/18/18.
//  Copyright © 2018 shahbaz tariq. All rights reserved.
//

#import "Location.h"


@implementation Location

+ (instancetype)sharedInstace
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if ((self = [super init])) {
        [self initializeLocation];
    }
    return self;
}

-(void)initializeLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    if (IS_OS_8_OR_LATER) {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
            [self.locationManager requestAlwaysAuthorization];
        } else
            [self.locationManager startUpdatingLocation];
    } else {
        if ([CLLocationManager locationServicesEnabled])
            [self.locationManager startUpdatingLocation];
        else {
            UIAlertView *alertLocation =
            [[UIAlertView alloc] initWithTitle:@"Unable to access location"
                                       message:@"Please enable location service "
             @"for GetOrdering from Settings"
                                      delegate:nil
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil];
            [alertLocation show];
        }
    }
}

#pragma mark -Location Delegates

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if ([locations count] > 0) {
        [manager stopUpdatingLocation];
        self.currentLocation = [locations lastObject];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status != kCLAuthorizationStatusAuthorizedAlways) {
        [manager stopUpdatingLocation];
    } else
        [manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
}

@end
