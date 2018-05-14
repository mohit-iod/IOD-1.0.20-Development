//
//  LoginVC.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/25/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "LoginVC.h"
#import "NSString+Validation.h"
#import "MBProgressHud.h"
#import "LoginService.h"
#import "DashboardVC.h"
#import "DashboardDoctor.h"
#import "pageViewControllerVC.h"
#import "REFrostedViewController.h"
#import "DEMOMenuViewController.h"
#import "DEMONavigationController.h"
#import "DEMOHomeViewController.h"
#import "IODUtils.h"
#import "CommonServiceHandler.h"
#import "RegistrationService.h"
#import "BankAccountVC.h"
#import "FileViewerVC.h"
#import "UIColor+HexString.h"
#import "AppDelegate.h"
#import "RegisterPageDoctorController.h"

#import <AVFoundation/AVFoundation.h>
@import UserNotifications;


@interface LoginVC ()
{
    NSDictionary *dict;
    RegistrationService *regisService;
}

@end

@implementation LoginVC

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View Controller Methods

- (void)viewDidLoad {
    
    regisService = [RegistrationService sharedManager];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    [super viewDidLoad];
    self.checkbox.checked = FALSE;
    [[NSUserDefaults standardUserDefaults] setValue:AuthKey forKey:@"auth"];
    
    UITapGestureRecognizer *tapG=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(termsLogin)];
    [_lblTerms addGestureRecognizer:tapG];
    _lblTerms.userInteractionEnabled=YES;
    
    _txtPassword.delegate = self;
    _txtUserName.delegate = self;
    
    [self.navigationController.navigationBar setAlpha:0.5];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];

}

-(void)viewWillAppear:(BOOL)animated{
    
    self.title=@"Login";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
    
    [self.navigationController.navigationBar setAlpha:0.5];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if(reachable) {
        [self getCountryList];
        [self getAllSpecialization];
    }
    else {
           }
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self checkReachability];
}

- (void)viewDidDisappear:(BOOL)animated{
    // Called after the view was dismissed, covered
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - Void Methods

-(void)checkReachability{
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if(!reachable) {
    }
}

-(void) getAllSpecialization {
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service getSpecializationDataWith:nil WithCompletionBlock:^(NSArray *array) {
        
    }];
}

//Click event for Terms and Conditin page. Redirected to webview.
-(void)termsLogin{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FileViewerVC *fileViewMe  = [sb instantiateViewControllerWithIdentifier:@"FileViewerVC"];
    fileViewMe.strFilePath=@"http://www.ionlinedoctor.com/termsandconditionsm";
    fileViewMe.strTitle= kTermsConditions;
    fileViewMe.hideMenu = YES;
    [self.navigationController pushViewController:fileViewMe animated:YES];
}

-(void)checkPermissions{
    __block BOOL isCameraAccess = YES;
    __block BOOL isMicrophoneAccess = YES;
    __block BOOL isNotificationAccess = YES;
    __block  BOOL isAllPermissionGranted = YES;
    
    //Check Camera Access.
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusDenied) // denied
    {
        isCameraAccess = NO;
    }
    else if(status == AVAuthorizationStatusRestricted){ // restricted
        isCameraAccess = NO;
    }
    else if(status == AVAuthorizationStatusNotDetermined){ // not determined
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){ // Access has been granted ..do something
                isCameraAccess = NO;
            }
        }];
    }
    
    //Check for Microphone permission.
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (!granted) {
            isMicrophoneAccess = NO;
        }
    }];
    
    
    // Push notification permissions
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings){
        
        
        if(isMicrophoneAccess == YES && isCameraAccess == YES){
            [self performSelectorOnMainThread:@selector(login) withObject:nil waitUntilDone:NO];
        }
        else{
            [self performSelectorOnMainThread:@selector(gotoAppSettings) withObject:nil waitUntilDone:NO];
        }
    }];
}


-(void)gotoAppSettings{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@""
                                  message:kMicrophonePermission
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"app-settings:"]];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //do something when click button
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}

- (void)_queryNotificationsStatus
{
    
}

//Check if the doctor is disable fot first time

- (void)redirectDoctorFirstTime {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BankAccountVC *bank = [sb instantiateViewControllerWithIdentifier:@"BankAccountVC"];
    
    bank.country_id = _country_id;
    [self.navigationController pushViewController:bank animated:YES];
}

// If login is successfull and user is doctor then redirect it to Doctor storyboard.
-(void)redirectDoctor {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"StoryboardDoctor" bundle:nil];
    DashboardDoctor *dashDoc;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        dashDoc =  [sb instantiateViewControllerWithIdentifier:@"DashboardDoctor"];
    }
    else{
        dashDoc =  [sb instantiateViewControllerWithIdentifier:@"DashboardDoctoriphone"];
    }
    
    DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:dashDoc];
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

// If login is successfull and user is patient then redirect it to patient storyboard.
- (void)redirectPatient:(NSString *)userName profilePic:(NSString *)profileimage isFirstLogin:(int) isFirstLogin {
    
    DashboardVC *dashPatient;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
        dashPatient = [sb instantiateViewControllerWithIdentifier:@"DashboardVC"];
    
    else
        dashPatient = [sb                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        instantiateViewControllerWithIdentifier:@"DashboardVCiphone"];
    
    
    dashPatient.isFirstLogin = isFirstLogin;
    dashPatient.strCouponCode = [dict valueForKey:@"coupon_code"];
    dashPatient.strPrice = [NSString stringWithFormat:@"%@",[dict valueForKey:@"coupon_price"]];
    dashPatient.strExpireDate = [NSString stringWithFormat:@"%@",[dict valueForKey:@"expiry_date"]];
    
    DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:dashPatient];
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

-(void) login {
// Login validation and API call.
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // username validation
    if(![IODUtils getError:self.txtUserName minVlue:@"0" minVlue:@"100" onlyNumeric:NO onlyChars:NO canBeEmpty:NO checkEmail:YES minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtPassword minVlue:@"4" minVlue:@"30" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(self.checkbox.checked == 0) {
        [IODUtils showFCAlertMessage:TERMS_CONDITIONS_ERR  withTitle:@"" withViewController:self with:@"error"];
    }
    else {
        NSString *email = _txtUserName.text;
        NSString *password = _txtPassword.text;
        
        NSString *fcmToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"FCMToken"];
        if(fcmToken == nil)
        {
            fcmToken = @"testtoken";
        }
        regisService.strEmail = email;
        regisService.strPassword = password;
        regisService.token = fcmToken;
        NSMutableDictionary *mparameters = [[NSMutableDictionary alloc] init];
        [mparameters setObject:email forKey:@"email"];
        [mparameters setObject:password forKey:@"password"];
        [mparameters setObject:@"fcmToken" forKey:@"device_token"];
        
        //[mparameters setObject:fcmToken forKey:@"device_token"];
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        //API call when internet is reachable.
        if (reachable) {
            RegistrationService *service = [[RegistrationService alloc] init];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service doLoginWithParameters:mparameters withCompletionBlock:^(id response, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if([[response objectForKey:@"status"] isEqualToString:@"success"]) {
                    
                    dict = [response valueForKey:@"data"];
                    NSString *token = [NSString stringWithFormat:@"Bearer %@",[dict valueForKey:@"token"]];
                    UDSet(@"auth", token);
                    UDSet(@"uid",[dict valueForKey:@"user_id"]);
                    UDSet(@"uname",[dict valueForKey:@"name"]);
                    UDSet(@"uemail",[dict valueForKey:@"email"]);
                    _country_id =[dict valueForKey:@"country_id"];
                    int countryId = [[dict valueForKey:@"country_id"] intValue];
                    UDSetInt(@"cid", countryId);
                    NSString *user_type = [dict valueForKey:@"user_type"];
                    
                    NSString *strname =[dict valueForKey:@"name"];
                    NSString *strCountry =[NSString stringWithFormat:@"%@",[dict valueForKey:@"country"]];
                    UDSet(@"country", strCountry);
                    NSString *strState =[NSString stringWithFormat:@"%@, ",[dict valueForKey:@"state"]];
                    if([strState isEqualToString:@", "]){
                        strState = @"";
                    }
                    
                    if([strState isEqualToString:@"<null>"]){
                        strState = @"";
                    }
                    if([strCountry isEqualToString:@""]){
                        strCountry = @"";
                    }
                    NSString *strAddress = [NSString stringWithFormat:@"%@%@",strState,strCountry];
                    
                    NSString *firstLetter = [strAddress substringToIndex:1];
                    if([firstLetter isEqualToString:@","]){
                        strAddress = [strAddress substringFromIndex:1];
                    }
                    UDSet(@"userinfodoc", ([NSKeyedArchiver archivedDataWithRootObject:@{@"name":strname,@"address":strAddress}]));
                    UDSet(@"userinfo", ([NSKeyedArchiver archivedDataWithRootObject:@{@"name":strname,@"address":strAddress}]));
                    
                    if([user_type isEqualToString:@"Patient"]){
                        [[NSUserDefaults standardUserDefaults] setValue:@"patient" forKey:@"usertype"];
                        UDSetBool(@"isdoctor", NO);
                        int isFirstLogin = [[dict valueForKey:@"is_first_login"] intValue];
                        NSString *referalCode = [NSString stringWithFormat:@"%@",[dict valueForKey:@"referral_code"]];
                        UDSet(@"referalcode", referalCode);
                        
                        [self redirectPatient:@"ssd" profilePic:@"dfds" isFirstLogin:isFirstLogin];
                    }
                    if([user_type isEqualToString:@"Doctor"]) {
                        [[NSUserDefaults standardUserDefaults] setValue:@"doctor" forKey:@"usertype"];
                        UDSetBool(@"isdoctor", YES);
                        NSString *referalCode = [NSString stringWithFormat:@"%@",[dict valueForKey:@"referral_code"]];
                        UDSet(@"referalcode", referalCode);
                        int bankInfoInserted = [[dict valueForKey:@"is_bank_info_inserted"] intValue];
                        if(bankInfoInserted == 1) {
                            [self redirectDoctor];
                        }
                        else{
                            [self redirectDoctorFirstTime];
                        }
                    }
                }
                else  if([[response objectForKey:@"status"] isEqualToString:@"fail"]) {
                    [IODUtils showFCAlertMessage:[response objectForKey:@"message"]  withTitle:@"" withViewController:self with:@"error"];
                    
                }
                else if (error) {
                    if([[error  valueForKey:@"message"] isEqualToString:kAccountVerfied]) {
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kResendEmail message:@"" preferredStyle:UIAlertControllerStyleAlert];
                        //We add buttons to the alert controller by creating UIAlertActions:
                        UIAlertAction *yesPressed = [UIAlertAction actionWithTitle:@"Resend" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
                            BOOL reachable = reach. isReachable;
                            if (reachable) {
                                [self resendEmail];
                            }
                            else{
                            }
                        }];
                        
                        UIAlertAction *noPressed = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [alertController addAction:yesPressed];
                        [alertController addAction:noPressed];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                        
                    }
                    else if([[error  valueForKey:@"status"] isEqualToString:@"fail"])
                        
                        [IODUtils showFCAlertMessage:[error  valueForKey:@"message"]  withTitle:@"" withViewController:self with:@"error"];
                }
            }]  ;
        }
        else {
            [IODUtils  showMessage:INTERNET_ERROR withTitle:@"Error"];
        }
    }
}

- (void) resendEmail{
    // Resend email if email is not resent.
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    //postResendEmail/
    
    NSMutableDictionary *parameter  = [[NSMutableDictionary alloc] init];
    [parameter setObject:_txtUserName.text forKey:@"email"];
    
    [service postResendEmail:parameter withCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [IODUtils showFCAlertMessage:@"Verification email is resent"  withTitle:@"" withViewController:self with:@"error"];
        
    }];
}

# pragma mark Redirection

-(void) redirectToPatientRegistration {
    //Action sheet event when regiter patient is clicked.
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
        RegisterPageDoctorController *registerPageDoctorController = [sb instantiateViewControllerWithIdentifier:@"RegisterPatientVCViewControlleriPad"];
        registerPageDoctorController.title=@"Sign up";
        
        [self.navigationController pushViewController:registerPageDoctorController animated:YES];
    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        pageViewControllerVC *pageVC=[sb instantiateViewControllerWithIdentifier:@"pageViewControllerVC"];
        pageVC.title=@"Sign up";
        pageVC.arrPageController=@[[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterPatientVCViewController"]].mutableCopy;
        [self.navigationController pushViewController:pageVC animated:YES];
    }
}

-(void) redirectToDoctorRegistration {
//Actionsheet event when register doctor is clicked.
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
        RegisterPageDoctorController *registerPageDoctorController = [sb instantiateViewControllerWithIdentifier:@"RegisterPageDoctorControlleriPad"];
        registerPageDoctorController.title=@"Sign up";
        
        [self.navigationController pushViewController:registerPageDoctorController animated:YES];
    }else{
        pageViewControllerVC *pageVC=[self.storyboard instantiateViewControllerWithIdentifier:@"pageViewControllerVC"];
        pageVC.title=@"Sign up";
        pageVC.arrPageController=@[[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterPageDoctorController"],[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterPageDoctorController2"]].mutableCopy;
        [self.navigationController pushViewController:pageVC animated:YES];
    }

}

- (void) prepareError:(NSError *)error withProgressHud:(MBProgressHUD *)hud {
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    }
}

//Get Country list.
- (void)getCountryList {
    CommonServiceHandler *commonService = [[CommonServiceHandler alloc] init];
    [commonService getAllCountriesWithCompletion:^(NSArray *array) {
    }];
}


#pragma mark - IBAction Methods

- (IBAction)btnForgotPassword:(id)sender {
    //Forgot password method
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self.navigationController pushViewController:[sb instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"] animated:YES];
}

- (IBAction)btnGetStarted:(id)sender {
    // Login button method.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self checkPermissions];
}

-(IBAction)testChecking {
    self.checkbox.checked = !self.checkbox.checked;
}

-(IBAction)testDisabling {
    self.checkbox.disabled = !self.checkbox.disabled;
}

- (IBAction)registerPressed:(UIButton *)sender {
    //Click on Regisgter event.
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"Select Registration option" preferredStyle:UIAlertControllerStyleActionSheet];
    UIPopoverPresentationController *popover = actionSheet.popoverPresentationController;
    if (popover)
    {
        popover.sourceView = sender;
        UIButton * button = (UIButton *)sender;
        CGRect frame = button.frame;
        frame.origin.x = frame.origin.x-150;
        popover.sourceRect = frame;
        popover.permittedArrowDirections = UIPopoverArrowDirectionDown;
    }
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Register as Patient" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self redirectToPatientRegistration];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Register as Doctor" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self redirectToDoctorRegistration];
    }]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

//// Action sheet delegate to give option for registration.
//# pragma mark Delegates for Action sheet.
//- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//    switch (popup.tag) {
//        case 1: {
//            switch (buttonIndex) {
//                case 0:
//                    [self redirectToPatientRegistration];
//                    break;
//                case 1:
//                    [self redirectToDoctorRegistration];
//                    break;
//                    
//                default:
//                    break;
//            }
//            break;
//        }
//        default:
//            break;
//    }
//}

#pragma mark - UITextfield Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [IODUtils setPlaceHolderLabelforTextfield:textField];
    return true;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return ![view isKindOfClass:[UIButton class]];
}

@end
