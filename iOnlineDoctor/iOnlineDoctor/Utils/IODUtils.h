//
//  IODUtils.h
//  iOnlineDoctor
//
//  Created by Purva Bhureja on 8/22/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IODUtils : NSObject
{
    
    
}

@property UIColor *redColor;
@property UIColor *greenColor;

+ (id)loadJsonDataFromPath:(NSString *)path;
+ (NSData *)loadDataFromPath:(NSString *)path;
+ (NSString *)generateRandomkey;
+ (NSString*)encryptKey:(NSString *)agentCode;
+ (void)openLinkInSafari:(NSString *)url
               withTitle:(NSString *)title
        withErrorMessage:(NSString *)errorMessage;
+(NSInteger)calculateAge:(NSString*)dob;

+ (void)showAlertView:(NSString *)message;

+ (void)showAlertView:(NSString *)message WithTitle:(NSString *)title;

+(void)showFCAlertMessage:(NSString*)message withTitle:(NSString *)title withViewController:(UIViewController *)vc with:(NSString *)type;


+ (NSString *)generateHashForString:(NSString *)paddedPassword;

+ (NSString *)lastSeenAppVersion;

+ (void)saveLastSeenVersion;

+ (NSString *)appVersion;

+(int)getGenderId:(NSString *)gender;


+(UILabel *)getErrorLabel:(UITextField *)useText;

+(BOOL)getErrorLabelWith:(UITextField *)txtValid minVlue:(id )minV minVlue:(id )maxV  onlyNumeric:(BOOL)onlyNum onlyChars:(BOOL)onlychar canBeEmpty:(BOOL )sEmpty checkEmail:(BOOL )emailv minAge:(id)MinAg  maxAge:(id)MaxAg canBeSameDate:(BOOL )sameDate;



+(BOOL)getError:(UITextField *)txtValid minVlue:(id )minV minVlue:(id )maxV  onlyNumeric:(BOOL)onlyNum onlyChars:(BOOL)onlychar canBeEmpty:(BOOL )sEmpty checkEmail:(BOOL )emailv minAge:(id)MinAg  maxAge:(id)MaxAg canBeSameDate:(BOOL )sameDate;


+(void)showMessage:(NSString*)message withTitle:(NSString *)title;

+(void)showMessagewithOption:(NSString*)message withTitle:(NSString *)title;

+(NSString *)formatDateForServer:(NSDate *)date;

+(NSString *)formatDateForUI:(NSDate *)date;

+(NSString *)formatDateForUIFromString:(NSString *)date;

+(NSDate *)str2date:(NSString*)dateStr;

+(NSDate *)formatDateAndTimeForServer:(NSDate *)date;

+(NSDate *)formatDateAndTimeForBusinessSlots:(NSString *)date;

+ (NSString *) formateStringToDateForUI:(NSString *)date ;

+ (NSString *) formateStringToDateForServer:(NSString *)date;

+ (NSString *)substringVisitTime:(NSString *)time;

+ (NSDate *) toLocalTime :(NSDate *)date;

+(NSString *) DisplayCallbutton: (NSString *)toDate : (NSString *)status;

+ (NSString *)setStatusColor:(NSString *)status;

+ (NSString *)subStringFromIndex:(NSString *)substring;

+(NSString *)getGender: (NSString *)gender;

+ (NSString *) ChangeDateFormat : (NSString *) toDate;

+(void)setConstantsBasedOnSelectedCurrencyId:(long)currencyId;


+(void)setPlaceHolderLabelforTextfield:(UITextField *)txtfield;


+(NSString*) changeFullDateToString:(NSString*)date;


@end
