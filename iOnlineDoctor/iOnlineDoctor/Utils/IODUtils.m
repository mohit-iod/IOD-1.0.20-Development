//
//  IODUtils.m
//  iOnlineDoctor
//
//  Created by Purva Bhureja on 8/22/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "IODUtils.h"
#import "ValidMacros.h"
#import "NSString+Validation.h"
#import "FCAlertView.h"

#define kLastSeenVersionKey @"LastSeenVersion"

@implementation IODUtils

NSString *const DataProviderException = @"DataProviderException";


//Open link in safari.
+ (void)openLinkInSafari:(NSString *)url
               withTitle:(NSString *)title
        withErrorMessage:(NSString *)errorMessage;
{
    
}

//load path for file

+ (NSData *)loadDataFromPath:(NSString *)path
{
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:[path stringByDeletingPathExtension] ofType:[path pathExtension]];
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:resourcePath options:0 error:&error];
    if (error)
        [NSException raise:DataProviderException format:@"%@", error];
    return data;
}

+ (id)loadJsonDataFromPath:(NSString *)path
{
   // NSString *resourcePath = [[NSBundle mainBundle] pathForResource:[path stringByDeletingPathExtension] ofType:[path pathExtension]];
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    if (error)
        [NSException raise:DataProviderException format:@"%@", error];
    
    error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error)
        [NSException raise:DataProviderException format:@"%@", error];
    
    return json;
}

+ (NSString *)generateHashForString:(NSString *)paddedPassword
{
   return @"";
}

+ (NSString*)encryptKey:(NSString *)agentCode
{
    return [IODUtils generateRandomkey];
}
+ (NSString *)getRandomKey
{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789/=+";
    NSMutableString *s = [NSMutableString stringWithCapacity:16];
    for (NSUInteger i = 0; i < 16; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    //NSLog(@"%@", s);
    NSString *key = s;
    return key;
}
+ (NSString *)generateRandomkey
{
    //get a key from JNKeyChain, if key is not present, then generate new random key and store it in jnkeychain
    NSString *randomKey = @"";
    return randomKey;
}

- (void)convertJSONTODictionary
{
    
}

+ (void)showAlertView:(NSString *)message
{
    
}

+ (void)showAlertView:(NSString *)message WithTitle:(NSString *)title
{

}

//Validations
+(BOOL)getErrorLabelWith:(UITextField *)txtValid minVlue:(id )minV minVlue:(id )maxV  onlyNumeric:(BOOL)onlyNum onlyChars:(BOOL)onlychar canBeEmpty:(BOOL )sEmpty checkEmail:(BOOL )emailv minAge:(id)MinAg  maxAge:(id)MaxAg canBeSameDate:(BOOL )sameDate{
    NSString *errMessage=@"";
    if (minV && maxV) {
        
        if(minV == maxV) {
            int min = [minV intValue];
            int max = [maxV intValue];
            if (([minV integerValue]<txtValid.text.length ) || (txtValid.text.length > [maxV integerValue])) {
                int min = [minV intValue];
                
                errMessage=[NSString stringWithFormat:@"%@ %d characters",EQUAL_LENGTH_ERR,min];
                errMessage = [NSString stringWithFormat:@"Enter %@ digit %@",minV,txtValid.placeholder];
                UILabel *labErr=[[self class] getErrorLabel:txtValid];
                labErr.text=errMessage;
                return false;
            }
        }
        else if (!([minV integerValue]<=txtValid.text.length ) || !(txtValid.text.length <=[maxV integerValue])) {
            int min = [minV intValue];
            int max = [maxV intValue];
            errMessage=[NSString stringWithFormat:@"%@ %ld",LENGTH_ERR,(long) min];
            UILabel *labErr=[[self class] getErrorLabel:txtValid];
            labErr.text=errMessage;
            return false;
        }
    }
    return true;
}


+(void)setPlaceHolderLabelforTextfield:(UITextField *)txtfield{

        NSString *placeholder  = txtfield.placeholder;
        UILabel *labErr=[[self class] getPlaceholderLabel:txtfield];
        labErr.text = placeholder;
        labErr.textColor =[UIColor lightGrayColor];
    
}

+(BOOL )getError:(UITextField *)txtValid minVlue:(id )minV minVlue:(id )maxV  onlyNumeric:(BOOL)onlyNum onlyChars:(BOOL)onlychar canBeEmpty:(BOOL )sEmpty checkEmail:(BOOL )emailv minAge:(id)MinAg  maxAge:(id)MaxAg canBeSameDate:(BOOL )sameDate
{
        NSString *errMessage=@"";
    if (!sEmpty) {
        if (![txtValid.text validateNotEmpty]) {
            errMessage=[NSString stringWithFormat:@"%@ %@",EMPTY_ERR,txtValid.placeholder ];
            UILabel *labErr=[[self class] getErrorLabel:txtValid];
            labErr.text=errMessage;
            return false;
        }
    }
    if (onlyNum) {
        if (![txtValid.text validateNumeric]) {
            errMessage=NUMBERONLY_ERR ;
            UILabel *labErr=[[self class] getErrorLabel:txtValid];
            labErr.text=errMessage;
            return false;
        }
    }
    if (onlychar) {
        if (![txtValid.text validateAlpha]) {
            errMessage=CHARSONLY_ERR ;
            UILabel *labErr=[[self class] getErrorLabel:txtValid];
            labErr.text=errMessage;
            return false;
        }
    }
    
    if (emailv) {
        
        if (![txtValid.text isValidEmail]) {
            errMessage=EMAIL_ERR ;
            UILabel *labErr=[[self class] getErrorLabel:txtValid];
            
            labErr.text=errMessage;
            
            return false;
        }
    }
    if (sameDate) {
        if (!sameDate) {
            NSCalendar *cal = [NSCalendar currentCalendar];
            NSDateComponents *components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
            NSDate *today = [cal dateFromComponents:components];
            //   SString *finalDate = @"02-09-2011 20:5@"4":18";
            // Prepare an NSDateFormatter to convert to and from the string representation
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // ...using a date format corresponding to your date
            [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
            // Parse the string representation of the date
            NSDate *date = [dateFormatter dateFromString:txtValid.text];
            components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
            NSDate *otherDate = [cal dateFromComponents:components];
            
            if(![today isEqualToDate:otherDate]) {
                //do stuff
                errMessage=SAMEDATE_ERR ;
                UILabel *labErr=[[self class] getErrorLabel:txtValid];
                
                labErr.text=errMessage;
                return false;
            }
        }
    }
    
    if (minV && maxV) {
        
        int min = [minV intValue];
        int max = [maxV intValue];
        
        NSString *strtext = txtValid.text;
        
        if(strtext.length>0){
            
            if(minV == maxV) {
                
                if ((min > strtext.length ) || (strtext.length < max)) {
                    
                    errMessage = [NSString stringWithFormat:@"Enter %@ digit %@",minV,txtValid.placeholder];
                    UILabel *labErr=[[self class] getErrorLabel:txtValid];
                    labErr.text=errMessage;
                    return false;
                }
            }
            
            else if (!(min <= strtext.length ) || !(strtext.length <= max)) {
                int min = [minV intValue];
                int max = [maxV intValue];
                errMessage=[NSString stringWithFormat:@"%@ %ld to %ld",LENGTH_ERR,(long) min,(long) max];
                
                UILabel *labErr=[[self class] getErrorLabel:txtValid];
                labErr.text=errMessage;
                return false;
            }
        }
    }
    if (MinAg && MaxAg) {
        int minimumAge = [MinAg intValue];
        int maximumAge = [MaxAg intValue];
        NSString *dateString = txtValid.text;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDate *dateFromString = [dateFormatter dateFromString:dateString];
        NSDate* now = [NSDate date];
        
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                           components:NSCalendarUnitYear
                                           fromDate:dateFromString
                                           toDate:now
                                           options:0];
        NSInteger age = [ageComponents year];
        if((age < minimumAge) ||  (age> maximumAge)){
            errMessage=[NSString stringWithFormat:@"%@ %ld +",AGE_ERR,(long)[MinAg integerValue]];
            UILabel *labErr=[[self class] getErrorLabel:txtValid];
            labErr.text=errMessage;
            return false;
        }
    }
    UILabel *labErr=[[self class] getErrorLabel:txtValid];
    labErr.text=@"";
    return true;
}

//Calculate age from Date of birth
+(NSInteger)calculateAge:(NSString*)dob{
    NSString *dateString = dob;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateFromString
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
    return age;
}


//Error labele after textfield
+(UILabel *)getErrorLabel:(UITextField *)useText{
    @try {
        for(UIView *v in useText.superview.subviews ){
            if (v.tag == 10) {
                return (UILabel *)v;
            }
        }
    } @catch (NSException *exception) {
    }
    return [UILabel new];
}


+(UILabel *)getPlaceholderLabel:(UITextField *)useText{
    @try {
        for(UIView *v in useText.superview.subviews ){
            if (v.tag == 11) {
                return (UILabel *)v;
            }
        }
    } @catch (NSException *exception) {
    }
    return [UILabel new];
}


//Get gender Id based on text
+(int)getGenderId: (NSString *)gender {
    if ([gender isEqualToString:@"Male"])
        return 1;
    if ([gender isEqualToString:@"Female"])
        return 2;
    if([gender isEqualToString:@"Other"])
        return 3;
   return 3;
}


+(NSString *)getGender: (NSString *)gender {
    if ([gender isEqualToString:@"1"])
        return @"Male";
    if ([gender isEqualToString:@"2"])
        return @"Female";
    if([gender isEqualToString:@"3"])
        return @"Other";
    return @"Male";
}

+ (NSString *)lastSeenAppVersion
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kLastSeenVersionKey];
}

+ (void)saveLastSeenVersion
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self appVersion] forKey:kLastSeenVersionKey];
}

+ (NSString *)appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}


+(void)showMessage:(NSString*)message withTitle:(NSString *)title
{
    

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //do something when click button
        
        
    }];
    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//        //do something when click button
//    }];
    
    [alert addAction:okAction];
   // [alert addAction:cancelAction];
    
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [MBProgressHUD hideHUDForView:vc.view animated:YES];
    [vc presentViewController:alert animated:YES completion:nil];
}


+(void)showFCAlertMessage:(NSString*)message withTitle:(NSString *)title withViewController:(UIViewController *)vc with:(NSString *)type{
    FCAlertView *alert = [[FCAlertView alloc] init]; // 2) Add This Where you Want to Create an FCAlertView
    [MBProgressHUD hideHUDForView:vc.view animated:YES];
    
    if([type isEqualToString:@"error"]){
        [alert makeAlertTypeCaution];
    }
    else if([type isEqualToString:@"success"]){
        [alert makeAlertTypeSuccess];
    }
    else if ([type isEqualToString:@"caution"]){
        [alert makeAlertTypeWarning];
    }
    else{
    }
    
    UIImage  *alertImage = [UIImage imageNamed:@""];
    alert.bounceAnimations = 1;
    alert.colorScheme = [self checkFlatColors:@"Turquoise"];
    alert.titleColor = [self checkFlatColors:@"Turquoise"];
    [alert showAlertInView:vc
                 withTitle:title
              withSubtitle:message
           withCustomImage:alertImage
       withDoneButtonTitle:@"OK"
                andButtons:nil];
    
}


#pragma mark - FCAlertViewExample Helper Methods

+ (UIColor *) checkFlatColors:(NSString *)selectedColor {
    
    FCAlertView *alert = [[FCAlertView alloc] init]; // Ignore This FCAlertView, simply initalized for colors here
    
    UIColor *color;
    
    if ([selectedColor isEqual:@"Turquoise"])
        color = alert.flatTurquoise;
    if ([selectedColor isEqual:@"Green"])
        color = alert.flatGreen;
    return color;
    
}


//Alertview
+(void)showMessagewithOption:(NSString*)message withTitle:(NSString *)title
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //do something when click button
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //do something when click button
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}


+(NSString *)formatDateForServer:(NSDate *)date {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *formattedDate =[NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    return formattedDate;
}

+(NSDate *)formatDateAndTimeForServer:(NSDate *)date {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *formattedDate =[NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    NSDate *date1 = [formatter dateFromString:formattedDate];
    return date1;
}

//Date and time for business slots
+(NSDate *)formatDateAndTimeForBusinessSlots:(NSString *)date {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *orignalDate   =  [formatter dateFromString:date];
    orignalDate =  [self toLocalTime: orignalDate];
    return orignalDate;
}


+ (NSDate *) toLocalTime :(NSDate *)date
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: date];
    return [NSDate dateWithTimeInterval: seconds sinceDate: date];
}




//Format server date to UI Date
+ (NSString *) formateStringToDateForUI:(NSString *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *orignalDate   =  [dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"dd/MMM/YYYY"];
    NSString *strFormattedDate = [dateFormatter stringFromDate:orignalDate];
    return strFormattedDate;
}


//Fomate string to Date
+ (NSString *) formateStringToDateForServer:(NSString *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MMM/YYYY"];
    NSDate *orignalDate   =  [dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strFormattedDate = [dateFormatter stringFromDate:orignalDate];
    return strFormattedDate;
}


//Format date for user interface
+(NSString *)formatDateForUIFromString:(NSString *)date {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY"];
    NSDate *dat = [self str2date:date];
    NSString *formattedDate  = [self formatDateForUI:dat];
    return formattedDate;
}


//String to date
+(NSDate *)str2date:(NSString*)dateStr {
    if ([dateStr isKindOfClass:[NSDate class]]) {
        return (NSDate*)dateStr;
     }    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    return date;
}

+(NSString *)formatDateForUI:(NSDate *)date {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY"];
    NSString *formattedDate =[NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    return formattedDate;
}

+(NSString *) DisplayCallbutton: (NSString *)toDate : (NSString *)status
{
    NSString *typeofstatus;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *todatetime = [dateFormatter dateFromString:toDate];
    NSDate *appointmentTime = [self toLocalTime:todatetime];
    
    NSDate *cappointmentDatePlusThreeMinutes = appointmentTime;
    cappointmentDatePlusThreeMinutes = [cappointmentDatePlusThreeMinutes dateByAddingTimeInterval:180];
    
    NSDate *appointmentDateMinusOneMinutes = appointmentTime;
    appointmentDateMinusOneMinutes = [appointmentDateMinusOneMinutes dateByAddingTimeInterval:60*-1];
    
    NSDate *currentdate = [NSDate date];
    currentdate = [self toLocalTime:currentdate];
    
    if ([status isEqualToString:@"Pending"]) {
    BOOL checkDate = [self date:currentdate isBetweenDate:appointmentDateMinusOneMinutes andDate:cappointmentDatePlusThreeMinutes];
    if(checkDate)
          typeofstatus = @"CALL NOW";
    else
         typeofstatus = @"cancel";
    }
    else {
         typeofstatus = @"nandisplay";
    }
    return typeofstatus;
}

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    return YES;
}

+ (NSString *)substringVisitTime:(NSString *)time {
    NSString *visit_time = [time substringToIndex:5];
    return visit_time;
}

+ (NSString *)subStringFromIndex:(NSString *)substring
{
    NSString *str = [substring substringWithRange:NSMakeRange(11, 5)];
    return str;
}

+ (NSString *)setStatusColor:(NSString *)status{
    if([status isEqualToString:@"Pending"])
        return @"#d7c223";
    else if([status isEqualToString:@"Cancelled"])
        return @"#646564";
    else if([status isEqualToString:@"Call drop"])
        return @"#df1b1d";
    else if([status isEqualToString:@"Disconnected"])
        return @"#df1b1d";
    else if ([status isEqualToString:@"Call interrupted"] || [status isEqualToString:@"Interrupted"])
        return @"#bed661";
    else if ([status isEqualToString:@"Missed"])
        return @"#1FBDE4";
    else
        return @"#51a53d";
}


+ (NSString *) ChangeDateFormat : (NSString *) toDate
{
    NSString *toDateCheck;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString: toDate]; // here you can fetch date from string with define format
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MMM/yyyy"];// here set format which you want...
    
    toDateCheck = [dateFormatter stringFromDate:date]; //here convert date in NSString
    
    return toDateCheck;
}

//Mohit
+(NSString*) changeFullDateToString:(NSString*)date
{
    NSString *newDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *tempDate = [dateFormatter dateFromString: date];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MMM/YYYY HH:mm"];
    
    newDate = [dateFormatter stringFromDate:tempDate];
    
    return newDate;
}


@end
