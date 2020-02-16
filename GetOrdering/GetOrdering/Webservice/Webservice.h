//
//  Webservice.h
//  CricketJunoon
//
//  Created by shahbaz tariq on 12/17/17.
//  Copyright © 2017 Ali Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Webservice : NSObject

+ (instancetype)sharedInstance;

-(void)getRestaurants:(NSArray *)queries distance:(NSDictionary *)distance address:(NSArray *)address categories:(NSArray *)categories businessTypes:(NSArray *)businessTypes completionHandler:(void (^)(BOOL success,NSDictionary *response,NSString *searchString,NSError *error))handler;

- (void)getNearByFacilities:(NSString *)zipCode completionHandler:(void (^)(BOOL success,NSDictionary *response,NSError *error))handler;

- (void)saveFormData:(NSString *)name email:(NSString *)email phone:(NSString *)phone state:(NSString *)state country:(NSString *)country address:(NSString *)address zipCode:(NSString *)zipCode utilityId:(NSString *)utilityId utilityName:(NSString *)utilityName waterColor:(NSString *)waterColor waterSmell:(NSString *)waterSmell problemInfo:(NSString *)problemInfo photos:(NSMutableArray *)arrayPhotos completionHandler:(void (^)(BOOL success,NSDictionary *response,NSError *error))handler;

- (void)searchLoc:(NSString *)address zipCode:(NSString *)zipCode city:(NSString *)city state:(NSString *)state country:(NSString *)country latitude:(NSString *)latitude longitude:(NSString *)longitude isAutomatic:(BOOL)isAutomatic completionHandler:(void (^)(BOOL success,NSDictionary *response,NSError *error))handler;

- (void)getAllPins:(void (^)(BOOL success,NSDictionary *response,NSError *error))handler;

- (void)getSubscription:(void (^)(BOOL success,NSDictionary *response,NSError *error))handler;

@end
