//  AppSettings.m
//  iOnlineDoctor
//  Created by Purva Bhureja on 8/22/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.

#import "AppSettings.h"
@implementation AppSettings

+(NSString *) cmsUrl
{
    NSString *versionOfLastRun = @"1.0.18";
    NSString * currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
   // return @"http://ec2-13-59-208-167.us-east-2.compute.amazonaws.com/iod-web/public/v1";
    BOOL isNewer = ([currentVersion compare:versionOfLastRun options:NSNumericSearch] == NSOrderedDescending);
    if (isNewer == NO) {
        // First start after installing the app
       //   return @"https://www.ionlinedoctor.com/v1";
        return @"http://ec2-13-59-208-167.us-east-2.compute.amazonaws.com/iod-web/public/v1";
    } else  {
        // App was updated since last run
    //  return @"https://www.ionlinedoctor.com/v2";
        return @"http://ec2-13-59-208-167.us-east-2.compute.amazonaws.com/iod-web/public/v2";
    }
}

+(NSDictionary *) parametersForKey{
    return  nil;
}

@end
