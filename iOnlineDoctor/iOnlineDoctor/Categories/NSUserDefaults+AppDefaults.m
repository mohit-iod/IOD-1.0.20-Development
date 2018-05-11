//
//  NSUserDefaults+AppDefaults.m
//  iOnlineDoctor
//
//  Created by Purva Bhureja on 8/21/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.


#import "NSUserDefaults+AppDefaults.h"
#import "IODUtils.h"
#import "CommonServiceHandler.h"
#import "RegistrationService.h"


@implementation NSUserDefaults (AppDefaults)

- (void)setAppActivated:(BOOL)isactivated {
    [self setBool:isactivated forKey:kUserDefaultsUserActivated];
}

- (BOOL)appActivated {
    return [self boolForKey:kUserDefaultsUserActivated];
}

- (void)setLoggedIn:(BOOL)isLoggedIn {
    [self setBool:isLoggedIn forKey:kUserDefaultsLoggedIn];
}

- (BOOL)loggedIn {
    return [self boolForKey:kUserDefaultsLoggedIn];
}

- (void)setPassword:(NSString *)password forUserID:(NSString *)userID
{
    
}



@end
