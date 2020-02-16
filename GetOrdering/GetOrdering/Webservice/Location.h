//
//  Location.h
//  Water
//
//  Created by shahbaz tariq on 1/18/18.
//  Copyright © 2018 shahbaz tariq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define IS_OS_8_OR_LATER \
([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface Location : NSObject<CLLocationManagerDelegate>

+ (instancetype)sharedInstace;

@property(strong,nonatomic) CLLocationManager *locationManager;
@property(strong,nonatomic) CLLocation * currentLocation;

@end
