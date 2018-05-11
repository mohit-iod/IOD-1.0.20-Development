//
//  AppSettings.h
//  iOnlineDoctor
//
//  Created by Purva Bhureja on 8/22/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AppSettings : NSObject

// URL to IOD Web Service
+(NSString *) cmsUrl;

+(NSDictionary *) parametersForKey;

@end
