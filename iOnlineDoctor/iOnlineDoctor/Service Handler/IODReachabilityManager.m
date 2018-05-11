//
//  IODReachabilityManager.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/28/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "IODReachabilityManager.h"
#import "AFHTTPRequestOperationManager.h"

@interface IODReachabilityManager()

@property(strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

static IODReachabilityManager *iodManager;

@implementation IODReachabilityManager

/*
 * Initializer monitoring access to the imo domain.
 */
-(void) startMonitor
{
  //Later we will replace it with our web URL
    NSURL *baseURL = [NSURL URLWithString:@""];
    self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = self.manager.operationQueue;
    [self.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                
            default:
                [operationQueue setSuspended:YES];
                break;
        }
        //NSLog(@"Network reachable %@", ([IODReachabilityManager imoReachable] ? @"TRUE" : @"FALSE"));
    }];
    
    [self.manager.reachabilityManager startMonitoring];
}

+(bool) imoReachable
{
    return [iodManager.manager.operationQueue isSuspended] == false;
}

+(void) initialize
{
    if (iodManager == nil) {
        iodManager = [[IODReachabilityManager alloc]init];
        [iodManager startMonitor];
    }
}
@end
