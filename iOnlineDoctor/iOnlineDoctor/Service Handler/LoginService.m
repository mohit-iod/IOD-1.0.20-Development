//
//  LoginService.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/31/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "LoginService.h"
#import "NSUserDefaults+AppDefaults.h"
#import "AppDelegate.h"
#import "AppSettings.h"

@implementation LoginService



- (void) loginUserWithParameters:(NSDictionary *)parameters withCompletionBlock:(userLoginBlock)block{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kLogin];
    //NSLog(@"Parameters %@",parameters);
    [self getDataWithUrl:url requestType:post requestParameters:parameters requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        block(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        block(nil,error);
    }];
}
@end
