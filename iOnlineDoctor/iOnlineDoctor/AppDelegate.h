//
//  AppDelegate.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/25/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@import Firebase;
@import UserNotifications;
@import FirebaseMessaging;
@import FirebaseInstanceID;


@interface AppDelegate : UIResponder <UIApplicationDelegate, FIRMessagingDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

-(void)updateStatus:(NSString *)slotid;

- (void)saveContext;

@end

