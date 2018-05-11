//
// NSString+Validation.m
//  iOnlineDoctor
//
//  Created by Purva Bhureja on 8/22/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//
#import "NSString+Validation.h"

//--------------------------------------------------------------
//--------------------------------------------------------------
@implementation NSString (Validation)

//--------------------------------------------------------------
- (BOOL)validateNotEmpty
{
    return ([self length] != 0);
}

//--------------------------------------------------------------
- (BOOL)validateMinimumLength:(NSInteger)length
{
    return ([self length] >= length);
}

//--------------------------------------------------------------
- (BOOL)validateMaximumLength:(NSInteger)length
{
    return ([self length] <= length);
}

//--------------------------------------------------------------
- (BOOL)validateMatchesConfirmation:(NSString *)confirmation 
{
    return [self isEqualToString:confirmation];
}

//--------------------------------------------------------------
- (BOOL)validateInCharacterSet:(NSMutableCharacterSet *)characterSet
{
    return ([self rangeOfCharacterFromSet:[characterSet invertedSet]].location == NSNotFound);
}

//--------------------------------------------------------------
- (BOOL)validateAlpha{
    NSMutableCharacterSet *charSetWithSpace=[NSMutableCharacterSet letterCharacterSet];
    
    [charSetWithSpace addCharactersInString:@" "];
    
    return [self validateInCharacterSet:charSetWithSpace.copy];
    
}

//--------------------------------------------------------------
- (BOOL)validateAlphanumeric{
    return [self validateInCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
}

//--------------------------------------------------------------
- (BOOL)validateNumeric{
    return [self validateInCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
}

//--------------------------------------------------------------
- (BOOL)validateAlphaSpace{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet letterCharacterSet];
    [characterSet addCharactersInString:@" "];
    return [self validateInCharacterSet:characterSet];
}

//--------------------------------------------------------------
- (BOOL)validateAlphanumericSpace{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet addCharactersInString:@" "];
    return [self validateInCharacterSet:characterSet];
}


//--------------------------------------------------------------
// Alphanumeric characters, underscore (_), and period (.)
- (BOOL)validateUsername {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet addCharactersInString:@"'_."];
    return [self validateInCharacterSet:characterSet];
}

- (BOOL)validatePassword {
    
    NSString *stricterFilterString = @"((?=.*\\d)(?=.*[a-z][A-Z][@#$%]).{6,30})";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [passwordTest evaluateWithObject:self];
}


- (BOOL)isValidURL {
    NSUInteger length = [self length];
    // Empty strings should return NO
    if (length > 0) {
        NSError *error = nil;
        NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
        if (dataDetector && !error) {
            NSRange range = NSMakeRange(0, length);
            NSRange notFoundRange = (NSRange){NSNotFound, 0};
            NSRange linkRange = [dataDetector rangeOfFirstMatchInString:self options:0 range:range];
            if (!NSEqualRanges(notFoundRange, linkRange) && NSEqualRanges(range, linkRange)) {
                return YES;
            }
        }
        else {
            NSLog(@"Could not create link data detector: %@ %@", [error localizedDescription], [error userInfo]);
        }
    }
    return NO;
}


-(BOOL)isValidEmail
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}


//--------------------------------------------------------------
- (BOOL)validatePhoneNumber{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    [characterSet addCharactersInString:@"'-*+#,;. "];
    return [self validateInCharacterSet:characterSet];
}

@end
