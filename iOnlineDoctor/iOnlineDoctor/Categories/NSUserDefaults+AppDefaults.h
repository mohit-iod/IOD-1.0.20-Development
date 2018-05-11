//
//  NSUserDefaults+AppDefaults.h
//  iOnlineDoctor
//
//  Created by Purva Bhureja on 8/21/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.


#import <Foundation/Foundation.h>

@interface NSUserDefaults (AppDefaults)
- (void)setAppActivated:(BOOL)isactivated;
- (BOOL)appActivated;
- (void)setLoggedIn:(BOOL)isLoggedIn;
- (BOOL)loggedIn;
- (void)setPassword:(NSString *)password forUserID:(NSString *)userID;

@end
