//
//  RegistrationService.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/31/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "BaseServiceHandler.h"
typedef void (^CheckEmailidBlock)(BOOL success, NSError *error);
typedef void (^userRegistrationBlock)(id response, NSError *error);
typedef void (^callBackBlock)(NSDictionary *responseCode, NSError *error);


@interface RegistrationService : BaseServiceHandler
- (void) CheckEmailid:(NSDictionary  *)parameter WithCompletionBlock:(CheckEmailidBlock)block;
- (void) doRegistrationWithParameters:(NSDictionary *)parameters withCompletionBlock:(userRegistrationBlock)block;

- (void) doDoctorRegistrationWithParameters:(NSDictionary *)parameters andImageName:(NSArray *)image andArraray:(NSArray *)mageArray dataType:(NSMutableArray*)type withCompletionBlock:(userRegistrationBlock)block;

-(void) validateEmail:(NSDictionary *)parameters withCompletionBlock:(userRegistrationBlock)block;

-(void) validateReferalCode:(NSDictionary *)parameters withCompletionBlock:(userRegistrationBlock)block;

- (void)AdditionalDoctorDetailWithParameters:(NSDictionary *)parameters withCompletionBlock:(userRegistrationBlock)block;

- (void) doLoginWithParameters:(NSDictionary *)parameters withCompletionBlock:(userRegistrationBlock)block;

-(void)editBankingDetails:(NSDictionary*)parameter andImageName:(NSArray *)image andImages:(NSArray *)imageData WithCompletionBlock:(callBackBlock)completionBlock;


-(void)bankingDetails:(NSDictionary*)parameter andImageName:(NSArray *)image andImages:(NSArray *)imageData WithCompletionBlock:(callBackBlock)completionBlock;


-(void)postSecondOpinionDocuments:(NSDictionary*)parameter andImageName:(NSArray *)image andImages:(NSArray *)imageData dataType:(NSMutableArray*)type WithCompletionBlock:(callBackBlock)completionBlock;


+ (id)sharedManager;
//Register Variables
@property (nonatomic, retain) NSString  *strFullname;
@property (nonatomic, retain) NSString  *strDOB;
@property (nonatomic, retain) NSString  *strEmail;
@property (nonatomic, retain) NSString  *strPassword;
@property (nonatomic, retain) NSString  *strGender;
@property (nonatomic, retain) NSString  *strViewAddress;
@property (nonatomic, retain) NSString  *strCity;
@property (nonatomic, retain) NSString  *strState;
@property (nonatomic, retain) NSString  *strCountry;
@property (nonatomic, retain) NSString  *strPinCode;
@property (nonatomic, retain) NSString  *strMobile;
@property (nonatomic, retain) NSString  *language;
@property (nonatomic, retain) NSString  *additionalQualification;
@property (nonatomic, retain) NSString  *RegistrationNumber;
@property (nonatomic, retain) NSString  *dea;
@property (nonatomic, retain) NSString  *highestQualification;
@property (nonatomic, retain) NSString  *highestQualificationYear;
@property (nonatomic, retain) NSString  *university;
@property (nonatomic, retain) NSString  *deaNumber;
@property (nonatomic, retain) NSString *specialization;
@property (nonatomic, retain) NSString  *experience;
@property (nonatomic, retain) NSString *licence;
@property (nonatomic, retain) NSString *token;


@property (nonatomic, retain) NSString *strAcNumber;
@property (nonatomic, retain) NSString *strAcName;
@property (nonatomic, retain) NSString *strAcHolderNumber;
@property (nonatomic, assign) int strIban;
@property (nonatomic, retain) NSString *strBankName;
@property (nonatomic, retain) NSString *strBankAdress;
@property (nonatomic, retain) NSString *strBankAcNumber;
@property (nonatomic, retain) NSArray *arrSignature;


@property (nonnull, retain) NSMutableArray *imageData;
@property (nonnull, retain) NSMutableArray * arrDocType;
@property (nonnull, retain) NSMutableArray * nameArray;


@end
