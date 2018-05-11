
//
//   NSString+Validation.h
//  iOnlineDoctor
//
//  Created by Purva Bhureja on 8/22/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//
#import <UIKit/UIKit.h>

//--------------------------------------------------------------
//--------------------------------------------------------------
@interface NSString (Validation)

- (BOOL)validateNotEmpty;
- (BOOL)validateMinimumLength:(NSInteger)length;
- (BOOL)validateMaximumLength:(NSInteger)length;

- (BOOL)validateMatchesConfirmation:(NSString *)confirmation;
- (BOOL)validateInCharacterSet:(NSMutableCharacterSet *)characterSet;

- (BOOL)validateAlpha;
- (BOOL)validateAlphanumeric;
- (BOOL)validateNumeric;
- (BOOL)validateAlphaSpace;
- (BOOL)validateAlphanumericSpace;
- (BOOL)isValidURL ;
- (BOOL)validateUsername;
- (BOOL)isValidEmail;
- (BOOL)validatePhoneNumber;
- (BOOL)validatePassword;

@end
