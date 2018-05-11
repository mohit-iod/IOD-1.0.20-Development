//
//  LoginService.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/31/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "BaseServiceHandler.h"
@class UserProfile;
typedef void (^userLoginBlock)(id response, NSError *error);



@interface LoginService : BaseServiceHandler
+ (id)sharedManager;

@property (nonatomic, retain) NSString  *accountType;
@property (nonatomic,retain) NSString *accountName;
@property (nonatomic,retain) NSString *address;
@property (nonatomic,retain) NSString *code;
@property (nonatomic,assign) NSString *bankName;
@property (nonatomic,retain) NSString *bankAddress;
@property (nonatomic,retain) NSString *bankAcNumber;
@property (nonatomic,retain) NSString *patient_name;


/*
 Login Api with Completion block handler
 Method : POST
 Parameters : Email / Password
 */
- (void) loginUserWithParameters:(NSDictionary *)parameters withCompletionBlock:(userLoginBlock)block;
@end
