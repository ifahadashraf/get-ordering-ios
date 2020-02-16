//
//  Webservice.m
//  CricketJunoon
//
//  Created by shahbaz tariq on 12/17/17.
//  Copyright © 2017 Ali Apple. All rights reserved.
//

#import "Webservice.h"
#import <CommonCrypto/CommonHMAC.h>
#import <AFNetworking.h>

#define kBaseURL @"http://nuroworks.com/takki/nuro/api/"

static NSString * const secretKey = @"4789da2ced5e6b464683f70bf897c753d9b6d52ea913cb99a840ce2a67aa291d";
static int TIME_OUT_INTERVAL = 120;

@implementation Webservice

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)getRestaurants:(NSArray *)queries distance:(NSDictionary *)distance address:(NSArray *)address categories:(NSArray *)categories businessTypes:(NSArray *)businessTypes completionHandler:(void (^)(BOOL success,NSDictionary *response,NSString *searchString,NSError *error))handler
{
    NSString *query = [NSString stringWithFormat:@"%@searchRestaurants",kBaseURL];
    
    NSDictionary *params = @{
                             @"queries"     : queries,
                             @"distance"    : distance,
                             @"address"     : address,
                             @"categories"  : categories,
                             @"business_types" : businessTypes,
                             };
    
    NSString * searchInfoDict = [self strAppInfoWithActionExecuted:@"searchInfoDict" searchInfoDict:params];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:TIME_OUT_INTERVAL];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&error];
    
    NSString *string = [[NSString alloc] initWithData:[jsonData mutableCopy] encoding:NSUTF8StringEncoding];
    NSLog(@"Request JSON: %@", string);
    
    [manager POST:query parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        handler(YES,responseObject,searchInfoDict,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         handler(NO,nil,searchInfoDict,error);
     }];
}

- (NSString *)strAppInfoWithActionExecuted:(NSString *)actionExecuted searchInfoDict:(NSDictionary *)searchInfoDict  {
    NSMutableDictionary *appInfo = [NSMutableDictionary dictionary];
    appInfo[@"ActionExecuted"] = actionExecuted;
    appInfo[@"searchInfoDict"] = searchInfoDict;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:appInfo options:0 error:NULL];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [jsonString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)getNearByFacilities:(NSString *)zipCode completionHandler:(void (^)(BOOL success,NSDictionary *response,NSError *error))handler
{
    NSString *query = [NSString stringWithFormat:@"http://18.195.224.177/nearByFacilities"];
    
    NSDictionary *params = @{
                             @"zip": zipCode
                             };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:TIME_OUT_INTERVAL];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&error];
    
    NSString *string = [[NSString alloc] initWithData:[jsonData mutableCopy] encoding:NSUTF8StringEncoding];
    NSLog(@"Request JSON: %@", string);
    
    [manager POST:query parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        handler(YES,responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         handler(NO,nil,error);
     }];
}

- (void)saveFormData:(NSString *)name email:(NSString *)email phone:(NSString *)phone state:(NSString *)state country:(NSString *)country address:(NSString *)address zipCode:(NSString *)zipCode utilityId:(NSString *)utilityId utilityName:(NSString *)utilityName waterColor:(NSString *)waterColor waterSmell:(NSString *)waterSmell problemInfo:(NSString *)problemInfo photos:(NSMutableArray *)arrayPhotos completionHandler:(void (^)(BOOL success,NSDictionary *response,NSError *error))handler
{
    NSString *query = [NSString stringWithFormat:@"http://18.195.224.177/reportForm"];
    
    NSString *strURL = query;
    
    AFHTTPRequestOperationManager *manager     = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *serializerRequest = [AFJSONRequestSerializer serializer];
    [serializerRequest setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    AFJSONResponseSerializer *serializerResponse = [AFJSONResponseSerializer serializer];
    serializerResponse.readingOptions = NSJSONReadingAllowFragments;
    serializerResponse.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.requestSerializer = serializerRequest;
    manager.responseSerializer = serializerResponse;
   
    /*
    UIImage *image = [UIImage imageNamed:@"image.png"];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
     */
    
    [manager POST:strURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFormData:[name dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"name"];
        
        [formData appendPartWithFormData:[email dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"email"];
        
        [formData appendPartWithFormData:[phone dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"number"];
        
        [formData appendPartWithFormData:[state dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"state"];
        
        [formData appendPartWithFormData:[country dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"country"];
        
        [formData appendPartWithFormData:[address dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"address"];
        
        [formData appendPartWithFormData:[zipCode dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"zip"];
        
        [formData appendPartWithFormData:[utilityId dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"id"];
        
        [formData appendPartWithFormData:[utilityName dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"Locations"];
        
        [formData appendPartWithFormData:[waterColor dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"color"];
        
        [formData appendPartWithFormData:[waterSmell dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"smell"];
        
        [formData appendPartWithFormData:[problemInfo dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"problem info"];
        
        
        if (arrayPhotos.count) {
            
            for (NSMutableDictionary * dict in arrayPhotos) {
                
                NSString * mediaType = (NSString *)dict[UIImagePickerControllerMediaType];
                UIImage * choseImage = (UIImage *)dict[UIImagePickerControllerOriginalImage];
                
                NSData * imageData = UIImageJPEGRepresentation(choseImage, 0.5);
                NSString * type = [self contentTypeForImageData:imageData];
                
               // float fileSize = [self getFileSize:imageData];
               //  NSLog(@"file size is %f",fileSize);
                
                NSURL *referenceURL = (NSURL *)dict[UIImagePickerControllerReferenceURL]; //put your reference URL here
                NSString *fileExtension = [referenceURL.absoluteString componentsSeparatedByString:@"ext="][1];
                NSString * finalExtension = [fileExtension lowercaseString];
                
                if (!fileExtension || fileExtension.length==0) {
                    if ([mediaType isEqualToString:@"ALAssetTypePhoto"])
                    {
                        finalExtension = @"jpg";
                    }
                    else
                    {
                        type = @"mov";
                    }
                }
                
                if ([mediaType isEqualToString:@"ALAssetTypePhoto"])
                {
                    type = [NSString stringWithFormat:@"image/%@",finalExtension];
                }
                else
                {
                    type = [NSString stringWithFormat:@"video/%@",finalExtension];
                }
                NSString * fileName = [NSString stringWithFormat:@"%@.%@",[self randomStringOfLength:8],finalExtension];
                [formData appendPartWithFileData:imageData name:@"userData" fileName:fileName mimeType:type];
            }
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.responseString);
        handler(YES,responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
        handler(NO,nil,error);
    }];
    
    /*
    NSDictionary *params = @{
                             @"name": name,
                             @"email" : email,
                             @"number" : phone,
                             @"state": state,
                             @"country" : country,
                             @"address" : address,
                             @"zip": zipCode,
                             @"id" : utilityId,
                             @"Locations" : utilityName,
                             @"color" : waterColor,
                             @"smell" : waterSmell,
                             @"problem info" : problemInfo
                             };

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:TIME_OUT_INTERVAL];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&error];
    
    NSString *string = [[NSString alloc] initWithData:[jsonData mutableCopy] encoding:NSUTF8StringEncoding];
    NSLog(@"Request JSON: %@", string);
    
    [manager POST:query parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        handler(YES,responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         handler(NO,nil,error);
     }];
     */
}

- (void)searchLoc:(NSString *)address zipCode:(NSString *)zipCode city:(NSString *)city state:(NSString *)state country:(NSString *)country latitude:(NSString *)latitude longitude:(NSString *)longitude isAutomatic:(BOOL)isAutomatic completionHandler:(void (^)(BOOL success,NSDictionary *response,NSError *error))handler
{
    NSString *query = [NSString stringWithFormat:@"http://18.195.224.177/searchLoc"];
    
    NSDictionary * params;
    
    if (isAutomatic) {
        params = @{
                   @"lat" : latitude,
                   @"long" : longitude
                   };
    }
    else
    {
        params = @{
                   @"address" : address,
                   @"zip" : zipCode,
                   @"city" : city,
                   @"state" : state,
                   @"country" : country,
                   };
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:TIME_OUT_INTERVAL];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&error];
    
    NSString *string = [[NSString alloc] initWithData:[jsonData mutableCopy] encoding:NSUTF8StringEncoding];
    NSLog(@"Request JSON: %@", string);
    
    [manager POST:query parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        handler(YES,responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         handler(NO,nil,error);
     }];
}

- (void)getAllPins:(void (^)(BOOL success,NSDictionary *response,NSError *error))handler
{
    NSString *query = [NSString stringWithFormat:@"http://18.195.224.177/allPins"];
    
    NSDictionary *params = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:TIME_OUT_INTERVAL];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&error];
    
    NSString *string = [[NSString alloc] initWithData:[jsonData mutableCopy] encoding:NSUTF8StringEncoding];
    NSLog(@"Request JSON: %@", string);
    
    [manager GET:query parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        handler(YES,responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"error description is %@",error.localizedDescription);
         handler(NO,nil,error);
     }];
}

- (void)getSubscription:(void (^)(BOOL success,NSDictionary *response,NSError *error))handler
{
    NSString *query = [NSString stringWithFormat:@"http://softizo.org/cricket/api/payment.php"];
    
    NSDictionary *params = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:TIME_OUT_INTERVAL];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&error];
    
    NSString *string = [[NSString alloc] initWithData:[jsonData mutableCopy] encoding:NSUTF8StringEncoding];
    NSLog(@"Request JSON: %@", string);
    
    [manager POST:query parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        handler(YES,responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         handler(NO,nil,error);
     }];
}

- (NSString *)randomStringOfLength:(NSInteger)length {
    
    char str[length+1];
    
    for (int i=0; i<length; i++){
        
        char rand = randomChar();
        
        str[i]=rand;
    }
    
    str[length]='\0';
    
    return [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
}

- (NSString *)contentTypeForImageData:(NSData *)data{
    
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

-(float)getFileSize:(NSData *)data
{
    return (float)data.length/1024.0f/1024.0f;
}

char randomChar(){
    
    char randomLower = 'a' + arc4random_uniform(26);
    char randomUpper = 'A' + arc4random_uniform(6);
    char randomNumber = '0' + arc4random_uniform(9);
    
    int randomVal = arc4random_uniform(100);
    
    char randomAlpha = (randomVal % 2 == 0) ? randomLower : randomUpper;
    
    //If you don't want a numeric as part of the string, just
    //return randomAlpha
    
    return (randomVal % 3 == 0) ? randomNumber : randomAlpha;
}

@end
