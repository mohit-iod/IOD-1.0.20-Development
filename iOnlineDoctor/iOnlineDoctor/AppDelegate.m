//
//  AppDelegate.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/25/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "AppDelegate.h"
#import "AppSettings.h"
#import "NSUserDefaults+AppDefaults.h"
#import "BaseServiceHandler.h"
#import "CommonServiceHandler.h"
#import "Constants.h"
#import <UserNotifications/UserNotifications.h>
#import "MBProgressHUD.h"
#import "DoctorAppointmentServiceHandler.h"
#import "DoctorVideoViewController.h"
#import "DashboardDoctor.h"
#import "LoginVC.h"
#import "DashboardVC.h"
#import "DEMONavigationController.h"
#import "DEMOMenuViewController.h"
#import "PatientVideoCallViewController.h"
#import "PatientAppointService.h"
#import "NoInternetVC.h"
#import "PatientCallAgailViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif


@interface AppDelegate () {
    Reachability *internetReachable;
    DoctorAppointmentServiceHandler *doctorService;
    DEMONavigationController *navigationController;
    DashboardVC *dashPatient ;
    PatientVideoCallViewController *docCall;
    PatientAppointService *patientService;
    // Mohit
    BOOL isInternetAvailable;
}

@end

@implementation AppDelegate
NSString *const kGCMMessageIDKey = @"gcm.message_id";

-(void)requestAccess{
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor,
      [UIFont boldSystemFontOfSize:16.0f], UITextAttributeFont,
      [UIColor darkGrayColor], UITextAttributeTextShadowColor,
      [NSValue valueWithCGSize:CGSizeMake(0.0, -1.0)], UITextAttributeTextShadowOffset,
      nil] forState:UIControlStateNormal];
    
    [[UITextField appearance] setTintColor:[UIColor lightGrayColor]];
    [[UITextView appearance] setTintColor:[UIColor lightGrayColor]];
    [[UITableView appearance] setShowsVerticalScrollIndicator:NO];
    [[UITableView appearance] setShowsHorizontalScrollIndicator:NO];
    
    //Notifications
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
            // For iOS 10 data message (sent via FCM)
            [FIRMessaging messaging].delegate = self;
#endif
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // [END register_for_notifications]
    }
    [application registerForRemoteNotifications];
    [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
    BOOL remoteNotificationsEnabled = false, noneEnabled,alertsEnabled, badgesEnabled, soundsEnabled;
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // iOS8+
        remoteNotificationsEnabled = [UIApplication sharedApplication].isRegisteredForRemoteNotifications;
        
        UIUserNotificationSettings *userNotificationSettings = [UIApplication sharedApplication].currentUserNotificationSettings;
        
        noneEnabled = userNotificationSettings.types == UIUserNotificationTypeNone;
        alertsEnabled = userNotificationSettings.types & UIUserNotificationTypeAlert;
        badgesEnabled = userNotificationSettings.types & UIUserNotificationTypeBadge;
        soundsEnabled = userNotificationSettings.types & UIUserNotificationTypeSound;
    }
    
    if(!noneEnabled){
        // [IODUtils showMessage:@"Please enable notifications from Settings" withTitle:@""];
    }
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                          //    NSLog(@"Granted is %d",granted);
                          }];
    
    [FIRApp configure];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:) name:kFIRInstanceIDTokenRefreshNotification object:nil];
    

    NSString * currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *versionOfLastRun = @"1.0.18";
    
    if (versionOfLastRun == nil) {
        // First start after installing the app
    } else if (![@"1.0.18" isEqual:currentVersion]) {
        // App was updated since last run
        //Version 2
    //    [self logOut];
        #define AuthKey @"Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJhdXRoX3Rva2VuIjoiQkVjNXRIOVlCUTVLMnBCaXNmZk81MTFMIiwidXNlciI6IiIsInRva2VuIjoiYkZUSEFTc2RzZHNyNTRydHJ5Z2hERkRGZGZ3aThiWjciLCJhcGlfdmVyc2lvbiI6Mn0.dvWxw2OA_vD6a36ds99fDtrbMoGJ8nYh2xBml-t9w3IzXsWoJFz1ChZAbmWHxTIkGfl0gYm6vBQUAWFy6VxV4g"
        
    } else {
        // nothing changed
        #define AuthKey @"Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ0b2tlbiI6ImFUZmxCZGlURXJ0d3ZhVkRHR2ZIaU1tbzRDR3c4Ylo3IiwiYXBpX3ZlcnNpb24iOjF9.9Jw6WRIT8cW9zMnYfLZmQQ1xq9ACr1OgC-Z8Neen3T6f9P4ldC-Vm-ZGRiy22BIAp37yev70KGrH2g4L6DaAEA"
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]]; // this will change the back button tint
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60 ) forBarMetrics:UIBarMetricsDefault];
    doctorService = [DoctorAppointmentServiceHandler sharedManager];
    patientService = [PatientAppointService sharedManager];
    
   // doctorService.isEVisit = @"yes";
        [Fabric with:@[[Crashlytics class]]];
    // TODO: Move this to where you establish a user session
    [self logUser];

    // Check if the app is launched on click of
   
    //Check Camera Access.
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status == AVAuthorizationStatusAuthorized) { // authorized
    }
    else if(status == AVAuthorizationStatusDenied){ // denied
    }
    else if(status == AVAuthorizationStatusRestricted){ // restricted
    }
    else if(status == AVAuthorizationStatusNotDetermined){ // not determined
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){ // Access has been granted ..do something
            } else {
                
                // Access denied ..do something
                
            }
        }];
    }
    
    // check for microphone permission.
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
        }
        else {
            
        }
    }];
    
    //Check for internet Reachability
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
        
        [self checkAPIVersion];
        
        //Save the latest App version
        [IODUtils saveLastSeenVersion];
    }
    else {
        [IODUtils  showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
    
    //Check if the user is logged.
    /*
     If the user is logged in open  check for user type : if user is doctor open doctor dashboard. If the user is Patient open patient dashboard.
     if the user is not logged in open login view.
     */
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        // Your app has been awoken by a notification...
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if(userInfo) {
            NSDictionary* uinfo = userInfo;
            NSString *jsonString = [userInfo valueForKey:@"form-data"];
            NSError *jsonError;
            doctorService = [DoctorAppointmentServiceHandler sharedManager];
            doctorService.isFromVideo = 1;
            
            NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:objectData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&jsonError];
            NSString *strAppointmentTime = [NSString stringWithFormat:@"%@ %@",[userInfo objectForKey:@"appoitment_date"],[userInfo objectForKey:@"start_time"]];
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *appointmentTime =[dateFormatter dateFromString:strAppointmentTime];
            appointmentTime = [IODUtils toLocalTime:appointmentTime];
            
            
            NSDate *myCurrentdateWith2Minutes = [[NSDate date] dateByAddingTimeInterval:60];
            NSDate *currentDate = [NSDate date];
            currentDate = [IODUtils toLocalTime:currentDate];
            myCurrentdateWith2Minutes = [IODUtils toLocalTime:myCurrentdateWith2Minutes];
            
            appointmentTime = [self truncateSecondsForDate: appointmentTime];
            myCurrentdateWith2Minutes = [self truncateSecondsForDate:myCurrentdateWith2Minutes];
            currentDate = [self truncateSecondsForDate:currentDate];
            
            BOOL isDateBetween = [self date:appointmentTime isBetweenDate:currentDate andDate:myCurrentdateWith2Minutes];
            
            NSString *isBetween = [NSString stringWithFormat:@"appoint time: %@ \n Current Date: %@ My currenttime plus 2 mins:%@  isDateBetween : %d",appointmentTime,currentDate,myCurrentdateWith2Minutes,isDateBetween];
            
            
            if([jsonString containsString:@"Logout"]){
                [self logOut];
                
            }
            else {
                if([[uinfo objectForKey:@"type"] isEqualToString:@"E-visit"]){
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    doctorService.isEVisit = @"yes";
                    DEMONavigationController *navigationController;
                    
                    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
                        
                        navigationController= [[DEMONavigationController alloc] initWithRootViewController: [sb instantiateViewControllerWithIdentifier:@"DashboardVC"]];
                        
                    }else{
                        navigationController =  [[DEMONavigationController alloc] initWithRootViewController: [sb instantiateViewControllerWithIdentifier:@"DashboardVCiphone"]];
                    }
                    [navigationController.navigationBar setTitleTextAttributes:
                     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                    DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
                    // Create frosted view controller
                    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
                    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
                    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
                    frostedViewController.liveBlur = YES;
                    frostedViewController.delegate = self;
                    // Make it a root controller
                    [[[UIApplication sharedApplication] delegate] window].rootViewController = frostedViewController;
                    [[[UIApplication sharedApplication] delegate] window].backgroundColor = [UIColor whiteColor];
                    [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
                }
                else if([[uinfo objectForKey:@"type"] isEqualToString:@"doctor-call"]) {
                    doctorService.isEVisit = @"no";
                    doctorService.appoitment_date = [userInfo objectForKey:@"appoitment_date"];
                    doctorService.from = [userInfo objectForKey:@"from"];
                    doctorService.strStartTime = [userInfo objectForKey:@"start_time"];
                    doctorService.patient_address  =[userInfo objectForKey:@"patient_address"];
                    NSString *dob =[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"patient_dob"]];
                    doctorService.patient_dob  = dob;
                    
                    doctorService.patient_gender  =[userInfo objectForKey:@"patient_gender"];
                    doctorService.patient_id  =[userInfo objectForKey:@"patient_id"];
                    doctorService.patient_name  =[userInfo objectForKey:@"patient_name"];
                    doctorService.patient_id = [userInfo objectForKey:@"patient_id"];
                    doctorService.profile_pic  =[userInfo objectForKey:@"profile_pic"];
                    doctorService.session_id  =[userInfo objectForKey:@"session_id"];
                    doctorService.session_token  =[userInfo objectForKey:@"session_token"];
                    doctorService.type  =[userInfo objectForKey:@"type"];
                    doctorService.visit_id  =[userInfo objectForKey:@"visit_id"];
                    doctorService.visit_type  =[userInfo objectForKey:@"visit_type"];
                    doctorService.call_duration = [userInfo objectForKey:@"call_duration"];
                    doctorService.isCallInterrupted = @"yes";
                    doctorService.doctorSpecialization = [userInfo objectForKey:@"specialization"];
                    
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
                        
                        navigationController= [[DEMONavigationController alloc] initWithRootViewController: [sb instantiateViewControllerWithIdentifier:@"DashboardVC"]];
                        
                    }else{
                        navigationController =  [[DEMONavigationController alloc] initWithRootViewController: [sb instantiateViewControllerWithIdentifier:@"DashboardVCiphone"]];
                    }
                    
                    [navigationController.navigationBar setTitleTextAttributes:
                     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                    DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
                    // Create frosted view controller
                    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
                    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
                    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
                    frostedViewController.liveBlur = YES;
                    frostedViewController.delegate = self;
                    
                    PatientCallAgailViewController *callAgain = [sb instantiateViewControllerWithIdentifier:@"PatientCallAgailViewController"];
                    [[[UIApplication sharedApplication] delegate] window].rootViewController = frostedViewController;
                    [navigationController pushViewController:callAgain animated:NO];
                    [[[UIApplication sharedApplication] delegate] window].backgroundColor = [UIColor whiteColor];
                    [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
                    
                }
                else if([[uinfo objectForKey:@"type"] isEqualToString:@"Live call notification"]){
                    
                    doctorService.isEVisit = @"no";
                    doctorService.isCallInterrupted = @"no";
                    doctorService = [DoctorAppointmentServiceHandler sharedManager];
                    doctorService.appoitment_date = [userInfo objectForKey:@"appoitment_date"];
                    doctorService.from = [userInfo objectForKey:@"from"];
                    doctorService.patient_address  =[userInfo objectForKey:@"patient_address"];
                    NSString *dob = [IODUtils formateStringToDateForUI:[userInfo objectForKey:@"patient_dob"]];
                    doctorService.patient_dob = dob;
                    doctorService.patient_gender  =[userInfo objectForKey:@"patient_gender"];
                    doctorService.patient_id  =[userInfo objectForKey:@"patient_id"];
                    doctorService.patient_name  =[userInfo objectForKey:@"patient_name"];
                    doctorService.patient_id = [userInfo objectForKey:@"patient_id"];
                    doctorService.profile_pic  =[userInfo objectForKey:@"profile_pic"];
                    doctorService.session_id  =[userInfo objectForKey:@"session_id"];
                    doctorService.session_token  =[userInfo objectForKey:@"session_token"];
                    doctorService.type  =[userInfo objectForKey:@"type"];
                    doctorService.visit_id  =[userInfo objectForKey:@"visit_id"];
                    doctorService.visit_type  =[userInfo objectForKey:@"visit_type"];
                    doctorService.call_duration = [userInfo objectForKey:@"call_duration"];
                    doctorService.doctorSpecialization = [userInfo objectForKey:@"specialization"];            NSString *StrDateTime = [NSString stringWithFormat:@"%@ %@",[userInfo objectForKey:@"appoitment_date"],[userInfo objectForKey:@"start_time"]];
                    NSDate *dt = [IODUtils formatDateAndTimeForBusinessSlots:StrDateTime];
                    dt = [IODUtils toLocalTime:dt];
                    
                    doctorService.dob = [userInfo objectForKey:@"patient_dob"];
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"StoryboardDoctor" bundle:nil];
                    DoctorVideoViewController *docCall = [sb instantiateViewControllerWithIdentifier:@"DoctorVideoViewController"];
                    
                    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
                        navigationController = [[DEMONavigationController alloc] initWithRootViewController: [sb instantiateViewControllerWithIdentifier:@"DashboardDoctor"]];
                    }
                    else{
                        navigationController = [[DEMONavigationController alloc] initWithRootViewController: [sb instantiateViewControllerWithIdentifier:@"DashboardDoctoriphone"]];
                    }
                    
                    [navigationController.navigationBar setTitleTextAttributes:
                     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                    navigationController.navigationBar.tintColor = [UIColor whiteColor];
                    DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
                    // Create frosted view controller
                    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
                    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
                    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
                    frostedViewController.liveBlur = YES;
                    frostedViewController.delegate = self;
                    [[[UIApplication sharedApplication] delegate] window].rootViewController = frostedViewController;
                    [navigationController pushViewController:docCall animated:NO];
                }
                else {
                    //  NSLog(@"received");
                }
            }
        }
        return YES;
    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"]) {
        NSString *utype = [[NSUserDefaults standardUserDefaults] valueForKey:@"usertype"];
        if([utype isEqualToString:@"patient"]) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DEMONavigationController *navigationController;
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
                navigationController= [[DEMONavigationController alloc] initWithRootViewController: [sb instantiateViewControllerWithIdentifier:@"DashboardVC"]];
            }else{
                navigationController =  [[DEMONavigationController alloc] initWithRootViewController: [sb instantiateViewControllerWithIdentifier:@"DashboardVCiphone"]];
            }
            [navigationController.navigationBar setTitleTextAttributes:
             @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
            // Create frosted view controller
            REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
            frostedViewController.direction = REFrostedViewControllerDirectionLeft;
            frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
            frostedViewController.liveBlur = YES;
            frostedViewController.delegate = self;
            // Make it a root controller
            [[[UIApplication sharedApplication] delegate] window].rootViewController = frostedViewController;
            [[[UIApplication sharedApplication] delegate] window].backgroundColor = [UIColor whiteColor];
            [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
        }
        else{
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"StoryboardDoctor" bundle:nil];
            DEMONavigationController *navigationController;
            
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
                navigationController = [[DEMONavigationController alloc] initWithRootViewController: [sb instantiateViewControllerWithIdentifier:@"DashboardDoctor"]];
            }
            else{
                navigationController = [[DEMONavigationController alloc] initWithRootViewController: [sb instantiateViewControllerWithIdentifier:@"DashboardDoctoriphone"]];
            }
            
            [navigationController.navigationBar setTitleTextAttributes:
             @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            
            navigationController.navigationBar.tintColor = [UIColor whiteColor];
            
            DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
            // Create frosted view controller
            REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
            frostedViewController.direction = REFrostedViewControllerDirectionLeft;
            frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
            frostedViewController.liveBlur = YES;
            frostedViewController.delegate = self;
            
            // Make it a root controller
            [[[UIApplication sharedApplication] delegate] window].rootViewController = frostedViewController;
            [[[UIApplication sharedApplication] delegate] window].backgroundColor = [UIColor whiteColor];
            [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
        }
    }
    else{
        
        UINavigationController *navController = [[UINavigationController alloc] init];
        LoginVC *dashDoc;
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
            dashDoc = [sb instantiateViewControllerWithIdentifier:@"LoginVCiPad"];
        }else{
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            dashDoc = [sb instantiateViewControllerWithIdentifier:@"LoginVC"];
        }
        
        [navController addChildViewController:dashDoc];
        [[[UIApplication sharedApplication] delegate] window].rootViewController = navController;
        [[[UIApplication sharedApplication] delegate] window].backgroundColor = [UIColor whiteColor];
        [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
    }

    //dsfasdffdasf
    //sanjay

    //set Notififier for check internet connection
    internetReachable = [Reachability reachabilityWithHostname:kreachability];
    [internetReachable connectionRequired];
    [internetReachable startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CheckInternet:) name:kReachabilityChangedNotification object:nil];
    return YES;
}

// Mohit
- (void)CheckInternet:(NSNotification *)notification{
    
    if ([internetReachable isReachable]) {
        //if Internet is available dismiss No Internet View
        if(!isInternetAvailable){
            NSLog(@"Reachable");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshView" object:nil];
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:nil];
            isInternetAvailable = YES;
        }
    }
    else {
        //if there is no internet present No Internet View
        NSLog(@"Unreachable");
        isInternetAvailable = NO;
        UIStoryboard * sBoard = [UIStoryboard storyboardWithName:@"NoInternet" bundle:nil];
        NoInternetVC * noNetVC = [sBoard instantiateViewControllerWithIdentifier:@"NoInternetVC"];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController]  presentViewController:noNetVC animated:YES completion:nil];
    }
}

- (void) logUser {
 
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [[FIRMessaging messaging]setAPNSToken:deviceToken];
    [[FIRMessaging messaging] setAPNSToken:deviceToken type:FIRMessagingAPNSTokenTypeUnknown];
    [self connectToFcm];
}


- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    // TODO: If necessary send token to application server.
}

- (void)connectToFcm {
    // Won't connect since there is no token
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    // Disconnect previous FCM connection if it exists.
    // [[FIRMessaging messaging] disconnect];
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
        } else {
            
            [[NSUserDefaults standardUserDefaults] setObject: [[FIRInstanceID instanceID] token] forKey:@"FCMToken"];
            CommonServiceHandler *service =[[CommonServiceHandler alloc] init];
            NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
            [parameter setObject:[[FIRInstanceID instanceID] token] forKey:@"device_token"];
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while pyour app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
}

- (NSDate *)truncateSecondsForDate:(NSDate *)fromDate;
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *fromDateComponents = [gregorian components:unitFlags fromDate:fromDate ];
    return [gregorian dateFromComponents:fromDateComponents];
}

- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    return YES;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if(userInfo) {
        NSDictionary* uinfo = userInfo;
        NSString *jsonString = [userInfo valueForKey:@"form-data"];
        NSError *jsonError;
        doctorService = [DoctorAppointmentServiceHandler sharedManager];
        doctorService.isFromVideo = 1;
        
        NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
        NSString *strAppointmentTime = [NSString stringWithFormat:@"%@ %@",[userInfo objectForKey:@"appoitment_date"],[userInfo objectForKey:@"start_time"]];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *appointmentTime =[dateFormatter dateFromString:strAppointmentTime];
        appointmentTime = [IODUtils toLocalTime:appointmentTime];
        
        NSDate *myCurrentdateWith2Minutes = [[NSDate date] dateByAddingTimeInterval:60];
        NSDate *currentDate = [NSDate date];
        currentDate = [IODUtils toLocalTime:currentDate];
        myCurrentdateWith2Minutes = [IODUtils toLocalTime:myCurrentdateWith2Minutes];
        
        appointmentTime = [self truncateSecondsForDate: appointmentTime];
        myCurrentdateWith2Minutes = [self truncateSecondsForDate:myCurrentdateWith2Minutes];
        currentDate = [self truncateSecondsForDate:currentDate];
        
        BOOL isDateBetween = [self date:appointmentTime isBetweenDate:currentDate andDate:myCurrentdateWith2Minutes];
        
        NSString *isBetween = [NSString stringWithFormat:@"appoint time: %@ \n Current Date: %@ My currenttime plus 2 mins:%@  isDateBetween : %d",appointmentTime,currentDate,myCurrentdateWith2Minutes,isDateBetween];
        
        if([jsonString containsString:@"Logout"]){
            [self logOut];
        }
        else {
            
            if([[uinfo objectForKey:@"type"] isEqualToString:@"E-visit"]){
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                doctorService.isEVisit = @"yes";
                DEMONavigationController *navigationController;
                {
                    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
                    
                    navigationController= [[DEMONavigationController alloc] initWithRootViewController: [sb instantiateViewControllerWithIdentifier:@"DashboardVC"]];
                    
                }else{
                    navigationController =  [[DEMONavigationController alloc] initWithRootViewController: [sb instantiateViewControllerWithIdentifier:@"DashboardVCiphone"]];
                }
                [navigationController.navigationBar setTitleTextAttributes:
                 @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
                // Create frosted view controller
                REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
                frostedViewController.direction = REFrostedViewControllerDirectionLeft;
                frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
                frostedViewController.liveBlur = YES;
                frostedViewController.delegate = self;
                // Make it a root controller
                [[[UIApplication sharedApplication] delegate] window].rootViewController = frostedViewController;
                [[[UIApplication sharedApplication] delegate] window].backgroundColor = [UIColor whiteColor];
                [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
            
                }
                
            }
            else if([[uinfo objectForKey:@"type"] isEqualToString:@"doctor-call"]) {
                doctorService.isEVisit = @"no";
                doctorService.appoitment_date = [userInfo objectForKey:@"appoitment_date"];
                doctorService.from = [userInfo objectForKey:@"from"];
                doctorService.strStartTime = [userInfo objectForKey:@"start_time"];
                doctorService.patient_address  =[userInfo objectForKey:@"patient_address"];
                NSString *dob =[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"patient_dob"]];
                doctorService.patient_dob  = dob;
                
                doctorService.patient_gender  =[userInfo objectForKey:@"patient_gender"];
                doctorService.patient_id  =[userInfo objectForKey:@"patient_id"];
                doctorService.patient_name  =[userInfo objectForKey:@"patient_name"];
                doctorService.patient_id = [userInfo objectForKey:@"patient_id"];
                doctorService.profile_pic  =[userInfo objectForKey:@"profile_pic"];
                doctorService.session_id  =[userInfo objectForKey:@"session_id"];
                doctorService.session_token  =[userInfo objectForKey:@"session_token"];
                doctorService.type  =[userInfo objectForKey:@"type"];
                doctorService.visit_id  =[userInfo objectForKey:@"visit_id"];
                doctorService.visit_type  =[userInfo objectForKey:@"visit_type"];
                doctorService.call_duration = [userInfo objectForKey:@"call_duration"];
                doctorService.isCallInterrupted = @"yes";
                doctorService.doctorSpecialization = [userInfo objectForKey:@"specialization"];
                
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
               // DEMONavigationController *navigationController;
                
                if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
                    
                    navigationController= [[DEMONavigationController alloc] initWithRootViewController: [sb instantiateViewControllerWithIdentifier:@"DashboardVC"]];
                    
                }else{
                    navigationController =  [[DEMONavigationController alloc] initWithRootViewController: [sb instantiateViewControllerWithIdentifier:@"DashboardVCiphone"]];
                }
                
                [navigationController.navigationBar setTitleTextAttributes:
                 @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
                // Create frosted view controller
                REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
                frostedViewController.direction = REFrostedViewControllerDirectionLeft;
                frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
                frostedViewController.liveBlur = YES;
                frostedViewController.delegate = self;
                
                PatientCallAgailViewController *callAgain = [sb instantiateViewControllerWithIdentifier:@"PatientCallAgailViewController"];
                [[[UIApplication sharedApplication] delegate] window].rootViewController = frostedViewController;
                [navigationController pushViewController:callAgain animated:NO];
                [[[UIApplication sharedApplication] delegate] window].backgroundColor = [UIColor whiteColor];
                [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
                
            }
            else if([[uinfo objectForKey:@"type"] isEqualToString:@"Live call notification"]){
                
                doctorService.isEVisit = @"no";
                doctorService.isCallInterrupted = @"no";
                doctorService = [DoctorAppointmentServiceHandler sharedManager];
                doctorService.appoitment_date = [userInfo objectForKey:@"appoitment_date"];
                doctorService.from = [userInfo objectForKey:@"from"];
                doctorService.patient_address  =[userInfo objectForKey:@"patient_address"];
                NSString *dob = [IODUtils formateStringToDateForUI:[userInfo objectForKey:@"patient_dob"]];
                doctorService.patient_dob = dob;
                doctorService.patient_gender  =[userInfo objectForKey:@"patient_gender"];
                doctorService.patient_id  =[userInfo objectForKey:@"patient_id"];
                doctorService.patient_name  =[userInfo objectForKey:@"patient_name"];
                doctorService.patient_id = [userInfo objectForKey:@"patient_id"];
                doctorService.profile_pic  =[userInfo objectForKey:@"profile_pic"];
                doctorService.session_id  =[userInfo objectForKey:@"session_id"];
                doctorService.session_token  =[userInfo objectForKey:@"session_token"];
                doctorService.type  =[userInfo objectForKey:@"type"];
                doctorService.visit_id  =[userInfo objectForKey:@"visit_id"];
                doctorService.visit_type  =[userInfo objectForKey:@"visit_type"];
                doctorService.call_duration = [userInfo objectForKey:@"call_duration"];
                doctorService.doctorSpecialization = [userInfo objectForKey:@"specialization"];            NSString *StrDateTime = [NSString stringWithFormat:@"%@ %@",[userInfo objectForKey:@"appoitment_date"],[userInfo objectForKey:@"start_time"]];
                NSDate *dt = [IODUtils formatDateAndTimeForBusinessSlots:StrDateTime];
                dt = [IODUtils toLocalTime:dt];
                
                doctorService.dob = [userInfo objectForKey:@"patient_dob"];
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"StoryboardDoctor" bundle:nil];
                DoctorVideoViewController *docCall = [sb instantiateViewControllerWithIdentifier:@"DoctorVideoViewController"];
            
                if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
                    navigationController = [[DEMONavigationController alloc] initWithRootViewController: [sb instantiateViewControllerWithIdentifier:@"DashboardDoctor"]];
                }
                else{
                    navigationController = [[DEMONavigationController alloc] initWithRootViewController: [sb instantiateViewControllerWithIdentifier:@"DashboardDoctoriphone"]];
                }
                
                [navigationController.navigationBar setTitleTextAttributes:
                 @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                navigationController.navigationBar.tintColor = [UIColor whiteColor];
                DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
                // Create frosted view controller
                REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
                frostedViewController.direction = REFrostedViewControllerDirectionLeft;
                frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
                frostedViewController.liveBlur = YES;
                frostedViewController.delegate = self;
                [[[UIApplication sharedApplication] delegate] window].rootViewController = frostedViewController;
              [navigationController pushViewController:docCall animated:NO];
            }
            else {
            }
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
    //}
}

// [START // [END connect_to_fcm]
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self connectToFcm];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  //  NSLog(@"Enter Backround");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    //NSLog(@"Enter foreGround");
}

#pragma mark Fire base Push Notifications
// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionNone);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
#if defined(__IPHONE_11_0)
         withCompletionHandler:(void(^)(void))completionHandler {
#else
withCompletionHandler:(void(^)())completionHandler {
#endif
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    // Print full message.
    //NSLog(@"%@", userInfo);
    
    completionHandler();
}
#endif
    
    // [START refresh_token]
- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
        // Note that this callback will be fired everytime a new token is generated, including the first
        // time. So if you need to retrieve the token as soon as it is available this is where that
        // should be done.
        // TODO: If necessary send token to application server.
}
    // [END refresh_token]
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set [Messaging messaging].shouldEstablishDirectChannel to YES.
- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
}
    
    // [END ios_10_data_message]
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
        
}
    
    
- (void)applicationWillResignActive:(UIApplication *)application {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}
    
    // [START disconnect_from_fcm]

    
    
- (void)applicationWillTerminate:(UIApplication *)application {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        [self updateStatus:@""];
        sleep(10);
        [self saveContext];
}
    
    
#pragma mark - Core Data stack
    
    @synthesize persistentContainer = _persistentContainer;
    
    - (NSPersistentContainer *)persistentContainer {
        // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
        @synchronized (self) {
            if (_persistentContainer == nil) {
                _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"iOnlineDoctor"];
                [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                    if (error != nil) {
                        abort();
                    }
                }];
            }
        }
        return _persistentContainer;
    }
    
#pragma mark - Core Data Saving support
    - (void)saveContext {
        NSManagedObjectContext *context = self.persistentContainer.viewContext;
        NSError *error = nil;
        if ([context hasChanges] && ![context save:&error]) {
            
            abort();
        }
    }
    
    
#pragma Check App version
    - (NSString *)AppVersionFromAPI{
        return @"1.0";
    }
    
    - (BOOL)checkForUpgrade
    {
        NSString *lastSeenVersion = [IODUtils lastSeenAppVersion];
        if(!lastSeenVersion && [[IODUtils appVersion] isEqualToString:@"1.0"]) {
            return YES;
        }
        return NO;
    }
    
#pragma mark --- API CALLS
    - (void) checkAPIVersion {
     CommonServiceHandler *commonService =  [[CommonServiceHandler alloc] init];
        [commonService getDataWith:nil WithCompletionBlock:^(NSDictionary * responseCode, NSError *error) {
            if (responseCode) {
                [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

                NSString *oldVersion = [responseCode valueForKey:@"ios_version"];
                NSString * currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                
                BOOL isNewer = ([currentVersion compare:oldVersion options:NSNumericSearch] == NSOrderedDescending);
                if(isNewer == NO){
                    int isComplulsory=[[responseCode valueForKey:@"is_ios_compulsory"] intValue];
                    if(isComplulsory == 1){
                        
                        NSString *messageForUpgrade = [responseCode valueForKey:@"message"];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:messageForUpgrade preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *yesPressed = [UIAlertAction actionWithTitle:@"Upgrade" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            UIApplication *application = [UIApplication sharedApplication];
                            NSURL *URL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/i-online-doc/id1299763701?ls=1&mt=8"];
                            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                                if (success) {
                                    
                                    //  NSLog(@"Opened url");
                                }
                            }];
                        }];
                        [alertController addAction:yesPressed];
                        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];

                    }
                    else {
                    }
                }
            }
        }];
}
    
    
-(void)updateStatus:(NSString *)slotid{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    NSString  *visitType = patientService.visit_type_id;
    if([visitType isEqualToString:@"1"]){
    }
    else {
        [parameter setObject:patientService.slot_id forKey:ktime_slot_id];
    }
    [parameter setObject:patientService.doctor_id forKey:kdoctor_id];
    [parameter setObject:patientService.visit_type_id forKey:kvisit_type_id];
    [parameter setObject:@"0" forKey:@"status"];
    [parameter setObject:[NSNumber numberWithInt:8] forKey:kpayment_mode_id];
    
    [service updateStatus:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        patientService.slot_id  = @"";
        patientService.doctor_id = @"";
    }];
}
    
    
-(void)logOut{
    
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
    
    [service logoutWithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        if (responseCode){
            UDSet(@"userinfodoc",nil);
            UDSet(@"propicdoc",nil);
            UDSet(@"propic", nil);
            
            if([[responseCode objectForKey:@"status"] isEqualToString:@"success"]){
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedIn"];
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *navController = [[UINavigationController alloc] init];
                UDSet(@"auth", AuthKey);
                UDSet(@"userinfodoc", nil);
                
                
                LoginVC *dashDoc;
                if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
                    dashDoc = [sb instantiateViewControllerWithIdentifier:@"LoginVCiPad"];
                }else{
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    dashDoc = [sb instantiateViewControllerWithIdentifier:@"LoginVC"];
                }
                
                [navController addChildViewController:dashDoc];
                [[[UIApplication sharedApplication] delegate] window].rootViewController = navController;
                [[[UIApplication sharedApplication] delegate] window].backgroundColor = [UIColor whiteColor];
            }
        }
    }];
  
}
    

#define Usernotifications
    @end
