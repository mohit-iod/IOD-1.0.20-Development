//
//  IODTextField
//  iOnlineDoctor
//
//  Created by Purva Bhureja on 8/21/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.


#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@class BaseServiceHandler;

typedef void (^ServiceSuccess)(id response, BaseServiceHandler *context);
typedef void (^ServiceFailure)(NSError *error, BaseServiceHandler *context);
typedef void(^responseBlock)(id response, NSData *data, NSError *connectionError);


@interface BaseServiceHandler : NSObject
    typedef enum _RequestType : NSUInteger {
    get,
    post
} RequestType;

@end

@interface BaseServiceHandler ()
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) NSDictionary *payloadValue;


/*
 * @brief Holds additional user defined context.
 */
@property (nonatomic, weak) id tag;

-(void)getDataWithUrl:(NSString *)requestUrl
          requestType:(RequestType)requestType
    requestParameters:(id)payload
       requestHeaders:(NSDictionary *)headers
         withDataType:(NSString *)dataType
              success:(ServiceSuccess) onSuccess
              failure:(ServiceFailure) onFailure;

-(void)getDataWithUrl1:(NSString *)requestUrl
           requestType:(RequestType)requestType
     requestParameters:(id)payload
        requestHeaders:(NSDictionary *)headers
          withDataType:(NSString *)dataType
               success:(ServiceSuccess) onSuccess
               failure:(ServiceFailure) onFailure;

-(void)PostDataWithUrl:(NSString *)requestUrl
           requestType:(RequestType)requestType
     requestParameters:(id)payload andUploadData:(NSArray *)arrData
        requestHeaders:(NSDictionary *)headers
          withDataType:(NSString *)dataType
               success:(ServiceSuccess) onSuccess
               failure:(ServiceFailure) onFailure;

-(void)PostDataWithSingleImage:(NSString *)requestUrl imageName:(NSArray *)imageName
                   requestType:(RequestType)requestType
             requestParameters:(id)payload andUploadData:(NSArray *)arrData
                requestHeaders:(NSDictionary *)headers
                  withDataType:(NSString *)dataType
                       success:(ServiceSuccess) onSuccess
                       failure:(ServiceFailure) onFailure;

-(void)PostDataWithImagePDF:(NSString *)requestUrl imageName:(NSArray *)imageName
                requestType:(RequestType)requestType
          requestParameters:(id)payload andUploadData:(NSArray *)arrData andDocType:(NSMutableArray*)arrDocType
             requestHeaders:(NSDictionary *)headers
               withDataType:(NSString *)dataType
                    success:(ServiceSuccess) onSuccess
                    failure:(ServiceFailure) onFailure;

@end
