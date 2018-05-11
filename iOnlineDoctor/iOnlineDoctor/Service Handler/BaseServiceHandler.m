//
//  IODTextField
//  iOnlineDoctor
//
//  Created by Purva Bhureja on 8/21/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.


#import "BaseServiceHandler.h"
#import "AppSettings.h"
#import "AFHTTPSessionManager.h"
#import "IODUtils.h"
#define RequestTimeOUT 30


//#import "CryptoResponseSerializer.h"

@interface BaseServiceHandler ()

@end
static NSString *currentSessionID;
static NSString *currentUserID;

@implementation BaseServiceHandler
- (NSString *) currenttimeZone {
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSInteger seconds = [timeZone secondsFromGMT];
    int h = (int)seconds / 3600;
    int m = (int)seconds / 60 % 60;
    NSString *strGMT = @"";
    if (h>=0)
        strGMT = [NSString stringWithFormat:@"+%02d:%02d", h, m];
    else
        strGMT = [NSString stringWithFormat:@"%03d:%02d", h, m];
    return strGMT;
}
-(id)init
{
    self = [super init];
    if (self)
    {
        
        NSString *strTimeZone = [self currenttimeZone];
        
        self.manager = [AFHTTPRequestOperationManager manager];
        self.manager.requestSerializer.timeoutInterval=RequestTimeOUT;
        // For this implementation, we are using json/in and out
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //[self.manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
      //  self.manager.responseSerializer.acceptableContentTypes =
     //   [self.manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        self.manager.securityPolicy.allowInvalidCertificates= YES;
        self.manager.securityPolicy.validatesCertificateChain= NO;
        [self.manager.requestSerializer setValue:UDGet(@"auth") forHTTPHeaderField:@"Authorization"];
        [self.manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"Device"];
        [self.manager.requestSerializer setValue:strTimeZone forHTTPHeaderField:@"Timezone"];
        [self.manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"Version"];
        [self.manager.requestSerializer setHTTPShouldHandleCookies:NO];

        NSString *str = [NSString stringWithFormat:@"%@",self.manager.requestSerializer.HTTPRequestHeaders];
       // NSLog(@"str is %@", str);
        
      //  [IODUtils showMessage:str withTitle:@"INITIAL HEADER"];
        
    }
    return self;
}

-(void)getDataWithUrl:(NSString *)requestUrl
          requestType:(RequestType)requestType
    requestParameters:(id)payload
       requestHeaders:(NSDictionary *)headers
         withDataType:(NSString *)dataType
              success:(ServiceSuccess) onSuccess
              failure:(ServiceFailure) onFailure
{
    if (headers)
    {
        NSArray *keys = [headers allKeys];
        for (NSInteger i = 0; i < keys.count; i++)
        {
            [self.manager.requestSerializer setValue:headers[keys[i]] forHTTPHeaderField:headers[keys[i]]];
        }
    }
    NSURL *baseURL = [NSURL URLWithString:requestUrl];
    if (requestType == post)
    {
        @try {
            AFHTTPSessionManager *qmanager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
         //  [qmanager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            NSString *strTimeZone = [self currenttimeZone];
            [qmanager.requestSerializer setValue:UDGet(@"auth") forHTTPHeaderField:@"Authorization"];
            [qmanager.requestSerializer setValue:@"1" forHTTPHeaderField:@"Device"];
            
            [qmanager.requestSerializer setValue:strTimeZone forHTTPHeaderField:@"Timezone"];
            [qmanager.requestSerializer setValue:@"1" forHTTPHeaderField:@"Version"];
            qmanager.requestSerializer.timeoutInterval = RequestTimeOUT;
            [qmanager.requestSerializer setHTTPShouldHandleCookies:NO];

            if ([dataType isEqualToString:@"json"]) {
                qmanager.responseSerializer = [AFJSONResponseSerializer serializer];
                qmanager.responseSerializer.acceptableContentTypes = [qmanager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
            } else {
                qmanager.responseSerializer = [AFCompoundResponseSerializer serializer];
                qmanager.responseSerializer.acceptableContentTypes = [qmanager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
            }
            
            qmanager.securityPolicy.allowInvalidCertificates = YES;
          
           // NSString *str = [NSString stringWithFormat:@"%@",qmanager.requestSerializer.HTTPRequestHeaders];
            
           // [IODUtils showMessage:str withTitle:@"INITIAL HEADER"];
          //  [IODUtils showMessage:payload withTitle:@"PARAMETER"];


            [qmanager POST:requestUrl parameters:payload success:^(NSURLSessionDataTask *task, id responseObject) {
                //NSLog(@"response: %@", responseObject);
                self.payloadValue = payload;
                onSuccess(responseObject, self);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                // NSString *errorString = [NSString stringWithFormat:@"Request:[%@] failed with code:[%ld] error:[%@]", requestUrl, (long)error.code, [error localizedFailureReason]];
                //NSLog(@"Request:[%@] failed with code:[%ld] error:[%@]", requestUrl, (long)error.code, [error localizedFailureReason]);
                onFailure(error, self);
            }];
            //NSLog(@"Post Request: URL: %@ With Params: %@", requestUrl, payload);
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
        
    } else if (requestType == get) {
        NSString *str = [NSString stringWithFormat:@"%@",self.manager.requestSerializer.HTTPRequestHeaders];
    
        [self.manager GET:requestUrl
               parameters:payload
                  success:^(AFHTTPRequestOperation *operation, id responseObject){
             if (responseObject){
                 onSuccess(responseObject, self);
             } else {
                 // Did not receieve valid data back
                 NSError *error;
                 error = [NSError errorWithDomain:@"servicecallmanager" code:404 userInfo:nil];
                 onFailure(error, self);
             }
         }
        failure:^(AFHTTPRequestOperation *operation, NSError *error){
             onFailure(error, self);
         }];
    }
}

-(void)getDataWithUrl1:(NSString *)requestUrl
           requestType:(RequestType)requestType
     requestParameters:(id)payload
        requestHeaders:(NSDictionary *)headers
          withDataType:(NSString *)dataType
               success:(ServiceSuccess) onSuccess
               failure:(ServiceFailure) onFailure
{
    if (headers)
    {
        NSArray *keys = [headers allKeys];
        for (NSInteger i = 0; i < keys.count; i++){
            [self.manager.requestSerializer setValue:headers[keys[i]] forHTTPHeaderField:headers[keys[i]]];
        }
        NSString *strTimeZone = [self currenttimeZone];
        [self.manager.requestSerializer setValue:UDGet(@"auth") forHTTPHeaderField:@"Authorization"];
        [self.manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"Device"];
        [self.manager.requestSerializer setValue:strTimeZone forHTTPHeaderField:@"Timezone"];
        [self.manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"Version"];
        [self.manager.requestSerializer setHTTPShouldHandleCookies:NO];
    }
    
    NSURL *baseURL = [NSURL URLWithString:requestUrl];
    if (requestType == post)
    {
        @try {
            AFHTTPSessionManager *qmanager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
            [qmanager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            qmanager.requestSerializer.timeoutInterval = 150;
            
            if ([dataType isEqualToString:@"json"]) {
                qmanager.responseSerializer = [AFJSONResponseSerializer serializer];
                qmanager.responseSerializer.acceptableContentTypes = [qmanager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
            } else {
                [qmanager.requestSerializer  setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
                qmanager.responseSerializer = [AFCompoundResponseSerializer serializer];
                qmanager.responseSerializer.acceptableContentTypes = [qmanager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
            }
            qmanager.securityPolicy.allowInvalidCertificates = YES;
            [qmanager POST:requestUrl parameters:payload success:^(NSURLSessionDataTask *task, id responseObject) {
                //                //NSLog(@"response: %@", responseObject);
                self.payloadValue = payload;
                onSuccess(responseObject, self);
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                //                NSString *errorString = [NSString stringWithFormat:@"Request:[%@] failed with code:[%ld] error:[%@]", requestUrl, (long)error.code, [error localizedFailureReason]];
                
                //NSLog(@"Request:[%@] failed with code:[%ld] error:[%@]", requestUrl, (long)error.code, [error localizedFailureReason]);
                onFailure(error, self);
            }];
            //NSLog(@"Post Request: URL: %@ With Params: %@", requestUrl, payload);
        }
        @catch (NSException *exception) {
            
        }
        @finally {
        }
        
    } else if (requestType == get) {
        //        //NSLog(@"Get Request: URL: %@", requestUrl);
        
        [self.manager GET:requestUrl parameters:payload success:^(AFHTTPRequestOperation *operation, id responseObject){
            if (responseObject)
            {
                ////NSLog(@"Response object is %@",responseObject);
                
                onSuccess(responseObject, self);
            } else {
                // Did not receieve valid data back
                NSError *error;
                error = [NSError errorWithDomain:@"servicecallmanager" code:404 userInfo:nil];
                onFailure(error, self);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            onFailure(error, self);
        }];
    }
}

-(void)PostDataWithUrl:(NSString *)requestUrl
           requestType:(RequestType)requestType
     requestParameters:(id)payload andUploadData:(NSArray *)arrData
        requestHeaders:(NSDictionary *)headers
          withDataType:(NSString *)dataType
               success:(ServiceSuccess) onSuccess
               failure:(ServiceFailure) onFailure{
    if (headers)
    {
        NSArray *keys = [headers allKeys];
        for (NSInteger i = 0; i < keys.count; i++)
        {
            [self.manager.requestSerializer setValue:headers[keys[i]] forHTTPHeaderField:headers[keys[i]]];
        }
    }
    NSURL *baseURL = [NSURL URLWithString:requestUrl];
    if (requestType == post)
    {
        @try {
            AFHTTPSessionManager *qmanager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
            [self.manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            NSString *strTimeZone = [self currenttimeZone];
            
            [self.manager.requestSerializer setValue:UDGet(@"auth") forHTTPHeaderField:@"Authorization"];
            [self.manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"Device"];
            [self.manager.requestSerializer setValue:strTimeZone forHTTPHeaderField:@"Timezone"];
            [self.manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"Version"];
            self.manager.requestSerializer.timeoutInterval = RequestTimeOUT;
            [self.manager.requestSerializer setHTTPShouldHandleCookies:NO];

            if ([dataType isEqualToString:@"json"]) {
                qmanager.responseSerializer = [AFJSONResponseSerializer serializer];
                qmanager.responseSerializer.acceptableContentTypes = [qmanager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
            } else {
                self.manager.responseSerializer = [AFCompoundResponseSerializer serializer];
                self.manager.responseSerializer.acceptableContentTypes = [qmanager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
            }
            [self.manager POST:requestUrl parameters:payload constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                for (int i = 0 ; i < arrData.count ; i ++) {
                    NSString *FileName = [NSString stringWithFormat:@"FileName%d.png",i+1];
                    
                    [formData appendPartWithFileData:[arrData objectAtIndex:i]
                                                name:@"documents[]" fileName:FileName mimeType:@"image/png"];
                }
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //NSLog(@"Success");
                onSuccess(responseObject, self);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Failure",error.description);
                
                onFailure(error, self);
                
            }];
            self.manager.securityPolicy.allowInvalidCertificates                                                                                                                                                                                                                                                                                                                              = YES;
            //NSLog(@"Post Request: URL: %@ With Params: %@", requestUrl, payload);
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
}

-(void)PostDataWithSingleImage:(NSString *)requestUrl imageName:(NSArray *)imageName
                   requestType:(RequestType)requestType
             requestParameters:(id)payload andUploadData:(NSArray *)arrData
                requestHeaders:(NSDictionary *)headers
                  withDataType:(NSString *)dataType
                       success:(ServiceSuccess) onSuccess
                       failure:(ServiceFailure) onFailure{
    if (headers)
    {
        NSArray *keys = [headers allKeys];
        for (NSInteger i = 0; i < keys.count; i++)
        {
            [self.manager.requestSerializer setValue:headers[keys[i]] forHTTPHeaderField:headers[keys[i]]];
        }
    }

    NSURL *baseURL = [NSURL URLWithString:requestUrl];
    if (requestType == post)
    {
        @try {
            AFHTTPSessionManager *qmanager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
            [self.manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            NSString *strTimeZone = [self currenttimeZone];
            
            [self.manager.requestSerializer setValue:UDGet(@"auth") forHTTPHeaderField:@"Authorization"];
            [self.manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"Device"];
            [self.manager.requestSerializer setValue:strTimeZone forHTTPHeaderField:@"Timezone"];
            [self.manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"Version"];
            self.manager.requestSerializer.timeoutInterval = RequestTimeOUT;
            [self.manager.requestSerializer setHTTPShouldHandleCookies:NO];

            if ([dataType isEqualToString:@"json"]) {
                qmanager.responseSerializer = [AFJSONResponseSerializer serializer];
                qmanager.responseSerializer.acceptableContentTypes = [qmanager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
            } else {
                self.manager.responseSerializer = [AFCompoundResponseSerializer serializer];
                self.manager.responseSerializer.acceptableContentTypes = [qmanager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
            }
            [self.manager POST:requestUrl parameters:payload constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                for (int i = 0 ; i < arrData.count ; i ++) {
                        NSString *FileName = [NSString stringWithFormat:@"FileName%d.png",i+1];
                        [formData appendPartWithFileData:[arrData objectAtIndex:i]
                                                    name:[imageName objectAtIndex:i] fileName:FileName mimeType:@"image/png"];
                }
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                onSuccess(responseObject, self);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                onFailure(error, self);
            }];
            self.manager.securityPolicy.allowInvalidCertificates                                                                                                                                                                                                                                                                                                                              = YES;
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
}

-(void)PostDataWithImagePDF:(NSString *)requestUrl imageName:(NSArray *)imageName
                   requestType:(RequestType)requestType
             requestParameters:(id)payload andUploadData:(NSArray *)arrData andDocType:(NSMutableArray*)arrDocType
                requestHeaders:(NSDictionary *)headers
                  withDataType:(NSString *)dataType
                       success:(ServiceSuccess) onSuccess
                       failure:(ServiceFailure) onFailure{
    if (headers)
    {
        NSArray *keys = [headers allKeys];
        for (NSInteger i = 0; i < keys.count; i++)
        {
            [self.manager.requestSerializer setValue:headers[keys[i]] forHTTPHeaderField:headers[keys[i]]];
        }
    }

    NSURL *baseURL = [NSURL URLWithString:requestUrl];
    if (requestType == post)
    {
        @try {
            AFHTTPSessionManager *qmanager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
            [self.manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            NSString *strTimeZone = [self currenttimeZone];
            
            [self.manager.requestSerializer setValue:UDGet(@"auth") forHTTPHeaderField:@"Authorization"];
            [self.manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"Device"];
            [self.manager.requestSerializer setValue:strTimeZone forHTTPHeaderField:@"Timezone"];
            [self.manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"Version"];
            self.manager.requestSerializer.timeoutInterval = RequestTimeOUT;
            [self.manager.requestSerializer setHTTPShouldHandleCookies:NO];
            
            if ([dataType isEqualToString:@"json"]) {
                qmanager.responseSerializer = [AFJSONResponseSerializer serializer];
                qmanager.responseSerializer.acceptableContentTypes = [qmanager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
            }
            else {
                self.manager.responseSerializer = [AFCompoundResponseSerializer serializer];
                self.manager.responseSerializer.acceptableContentTypes = [qmanager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
            }
            
            [self.manager POST:requestUrl parameters:payload constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                for (int i = 0 ; i < arrData.count ; i ++) {
                    
                    NSString * strType = [arrDocType objectAtIndex:i];
                    if([strType isEqualToString:@"pdf"]){
                        NSString *FileName = [NSString stringWithFormat:@"FileName%d.pdf",i+1];
                        [formData appendPartWithFileData:[arrData objectAtIndex:i]
                                                    name:[imageName objectAtIndex:i] fileName:FileName mimeType:@"application/pdf"];
                    }
                    else if([strType isEqualToString:@"doc"] || [strType isEqualToString:@"docx"]){
                        NSString *FileName = [NSString stringWithFormat:@"FileName%d.%@",i+1,strType];
                        [formData appendPartWithFileData:[arrData objectAtIndex:i]
                                                    name:[imageName objectAtIndex:i] fileName:FileName mimeType:@"application/msword"];
                    }
                    else{
                        NSString *FileName = [NSString stringWithFormat:@"FileName%d.png",i+1];
                        [formData appendPartWithFileData:[arrData objectAtIndex:i]
                                                    name:[imageName objectAtIndex:i] fileName:FileName mimeType:@"image/png"];
                    }
                }
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                onSuccess(responseObject, self);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                onFailure(error, self);
            }];
            self.manager.securityPolicy.allowInvalidCertificates                                                                                                                                                                                                                                                                                                                 = YES;
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
}

-(void)saveData {
    
}

@end
