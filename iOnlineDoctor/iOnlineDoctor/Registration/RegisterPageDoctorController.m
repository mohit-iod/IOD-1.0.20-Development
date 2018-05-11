//
//  RegisterPageDoctorController.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/27/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "RegisterPageDoctorController.h"
#import "IODUtils.h"
#import "Constants.h"
#import "pageViewControllerVC.h"
#import "CommonServiceHandler.h"
#import "UITextView+Placeholder.h"
#import "MBProgressHUD.h"
#import "DocumentPickerViewController.h"
#import "NTMonthYearPicker.h"
#import "RegistrationService.h"
#import "AFHTTPSessionManager.h"
#import "AppSettings.h"
#import "FileViewerVC.h"
#import "UIColor+HexString.h"
#import "MultiSelectTableView.h"


@interface RegisterPageDoctorController ()<UIPageViewControllerDataSource,UITextFieldDelegate,StringPickerViewDelegate,MultiSelectTableViewDelegate>{
    UIDatePicker *datePicker;
    NTMonthYearPicker *yearPicker;
    NSArray *arrCountryList;
    NSArray *arrStateList;
    NSArray *arrcityList;
    NSArray *arrspecializationList;
    NSString *selectedLicenceSates;
    int selectedCountryId;
    int selectedStateId;
    int selectedCityId;
}

@end

static int selectedGenderId;
static int specializationId;
static int uploadCounter;

@implementation RegisterPageDoctorController
{
    RegistrationService *regServCall;
}
-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    selectedLicenceSates  = @"";
    UITapGestureRecognizer *tapG=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(termsLogin)];
    [_lblTerms addGestureRecognizer:tapG];
    _lblTerms.userInteractionEnabled=YES;
    
    [super viewDidLoad];
    [self setYearPicker];
    self.txtgender.inputView = self.pickerView;
    self.txtState.inputView = self.pickerView;
    self.txtCity.inputView = self.pickerView;
    self.txtSpecialization.inputView = self.pickerView;
    self.txtViewAdress.placeholder = @"Address";
    self.title = @"Sign Up";
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    // Do any additional setup after loading the view.
}

-(void)termsLogin{
    // call link to terms
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FileViewerVC *fileViewMe  = [sb instantiateViewControllerWithIdentifier:@"FileViewerVC"];
    fileViewMe.strFilePath=@"http://www.ionlinedoctor.com/termsandconditionsm";
    fileViewMe.strTitle=@"Terms & Conditions, Privacy Policy";
    fileViewMe.hideMenu=true;
    [self.navigationController pushViewController:fileViewMe animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    regServCall=[RegistrationService sharedManager];
    NSUInteger cid = [regServCall.strCountry  intValue];
    int selectedid  = (int) cid;
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable){
        if(selectedid >0 )
            [self getAllStatesWith:selectedid];
    }else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextPage1:(id)sender {
    
    if (![IODUtils getError:self.txtFullName minVlue:@"4" minVlue:@"50" onlyNumeric:nil onlyChars:YES canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]) {
    }
    else if(![IODUtils getError:self.txtEmail minVlue:@"0" minVlue:@"100" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:YES minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    else if(![IODUtils getError:self.txtPassword minVlue:@"6" minVlue:@"30" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    else if(![IODUtils getError:self.txtDOB minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:@"18" maxAge:@"110" canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtgender minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtspecial minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    
    else if(![IODUtils getError:self.txtExperince minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    else if(![IODUtils getError:self.txtLanguageKnown minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtHighestQualificaion minVlue:@"1" minVlue:@"15" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    
    else{
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        if (reachable)
            [self validateEmail];
        
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}

- (IBAction)btnNextPage2:(id)sender {
    
    
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable){
        
        if(![IODUtils getError:self.txtMobile minVlue:@"10" minVlue:@"10" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
        }
        else if (![IODUtils getError:self.txtCountry minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]) {
        }
        
        else if([_txtCountry.text isEqualToString:@"United States"]) {
            if(![IODUtils getError:self.txtDea minVlue:@"1" minVlue:@"15" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil
                 ]){
            }else if(![IODUtils getError:self.txtLicenseStates minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
            }
            else if(![IODUtils getError:self.txtregistration minVlue:@"1" minVlue:@"15" onlyNumeric:NO onlyChars:NO canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
            }
            else if(![IODUtils getError:self.txtState minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
            }
            
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ForceUpdateLocation" object:self userInfo:@{@"pnumb":@"1",@"direction":kNext}];
                
            }
        }
        else if(![IODUtils getError:self.txtregistration minVlue:@"1" minVlue:@"15" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
        }
        else {
            
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
                [self NextPageCall];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ForceUpdateLocation" object:self userInfo:@{@"pnumb":@"1",@"direction":kNext}];
            }
        }
        
    }
    else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}

-(IBAction)termsLogin:(id)sender{
    // call link to terms
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FileViewerVC *fileViewMe  = [sb instantiateViewControllerWithIdentifier:@"FileViewerVC"];
    fileViewMe.strFilePath= @"http://www.ionlinedoctor.com/termsandconditionsm";
    fileViewMe.strTitle=@"Terms & Conditions, Privacy Policy";
    fileViewMe.hideMenu=YES;
    [self.navigationController pushViewController:fileViewMe animated:YES];
}

-(void)NextPageCall{
    
    
    regServCall.strCountry = [NSString stringWithFormat:@"%d",selectedCountryId];
    regServCall.strState = [NSString stringWithFormat:@"%d",selectedStateId];
    regServCall.strMobile = _txtMobile.text;
    regServCall.RegistrationNumber = self.txtregistration.text;
    regServCall.deaNumber = self.txtDea.text;
    if (regServCall.imageData.count == 0){
        [IODUtils showMessage:@"Please upload atleast one Document" withTitle:@"Error"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    else{
        
        if(_checkbox.checked == YES){
            //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if(![_txtCountry.text isEqualToString:@"United States"]){
                selectedLicenceSates = @"";
            }
            regServCall.licence = selectedLicenceSates;
            Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
            BOOL reachable = reach. isReachable;
            if (reachable){
                RegistrationService *service = [[RegistrationService alloc] init];
                NSMutableDictionary *userdata = [[NSMutableDictionary alloc] init];
                [userdata setObject:_txtReferalCode.text forKey:@"reffral_code"];
                [userdata setObject:@"doctor" forKey:@"user_type"];
                if(_txtReferalCode.text.length > 0 ){
                    
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [service validateReferalCode:userdata withCompletionBlock:^(id response, NSError *error) {
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        // NSLog(@"Response");
                        if(error){
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [IODUtils showMessage:[error valueForKey:@"message"] withTitle:@"Error"];
                        }
                        else if([[response  valueForKey:@"status"] isEqualToString:@"success"]) {
                            //[self regiserDoctor];
                            if([[response valueForKey:@"message"] isEqualToString:@"This reffral code is not valid."]){
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                
                                [IODUtils showMessage:[response valueForKey:@"message"] withTitle:@"Error"];
                            }
                            else{
                                [self regiserDoctor];
                            }
                        }
                    }];
                }
                else {
                    [self regiserDoctor];
                }
            }
            else
            {
                //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
            }
        }
        else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [IODUtils showMessage:@"Please agree to terms and conditions" withTitle:@"Error"];
            
        }
        
    }
}

- (IBAction)btnBackPage2:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ForceUpdateLocation" object:self userInfo:@{@"pnumb":@"0",@"direction":@"back"}];
}

-(void)verifyReferralCode {
    
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    
}
- (IBAction)btnSubmit:(id)sender {
    
}


- (IBAction)btnBackPage3:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ForceUpdateLocation" object:self userInfo:@{@"pnumb":@"1",@"direction":@"back"}];
}

- (IBAction)btniPadSubmitBtnClick:(id)sender {
    if (![IODUtils getError:self.txtFullName minVlue:@"4" minVlue:@"50" onlyNumeric:nil onlyChars:YES canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]) {
    }
    else if(![IODUtils getError:self.txtEmail minVlue:@"0" minVlue:@"100" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:YES minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    else if(![IODUtils getError:self.txtPassword minVlue:@"6" minVlue:@"30" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    else if(![IODUtils getError:self.txtDOB minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:@"18" maxAge:@"110" canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtgender minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtspecial minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    
    else if(![IODUtils getError:self.txtExperince minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    else if(![IODUtils getError:self.txtLanguageKnown minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtHighestQualificaion minVlue:@"1" minVlue:@"15" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    else if(![IODUtils getError:self.txtMobile minVlue:@"10" minVlue:@"10" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    else if (![IODUtils getError:self.txtCountry minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]) {
    }
    else if(![IODUtils getError:self.txtregistration minVlue:@"1" minVlue:@"15" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }else if([_txtCountry.text isEqualToString:@"United States"]) {
        if(![IODUtils getError:self.txtDea minVlue:@"1" minVlue:@"15" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil
             ]){
        }else if(![IODUtils getError:self.txtLicenseStates minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
        }
        else if(![IODUtils getError:self.txtregistration minVlue:@"1" minVlue:@"15" onlyNumeric:NO onlyChars:NO canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
        }
        else if(![IODUtils getError:self.txtState minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
        }else{
            Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
            BOOL reachable = reach. isReachable;
            if (reachable)
                [self validateEmail];
        }
        
    }
    else{
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        if (reachable)
            [self validateEmail];
        
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}

#pragma mark Text Field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.txtgender) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
            NSDictionary *dictgender = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"iodGender" ofType:@"json"]];
            NSArray *gender= [dictgender valueForKey:@"Gender"];
            self.pickerView.data = gender;
            self.pickerView.delegate = self;
            self.pickerView.preSelectedValue = textField.text;
            self.pickerView.refernceView = textField;
            [self.view addSubview:self.pickerView];
            return NO;
        }
        return NO;
    }
    else if (textField == self.txtExperince) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
            NSDictionary *dictgender = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"Experience" ofType:@"json"]];
            NSArray *gender= [dictgender valueForKey:@"Experience"];
            self.pickerView.data = gender;
            self.pickerView.delegate = self;
            self.pickerView.preSelectedValue = textField.text;
            self.pickerView.refernceView = textField;
            [self.view addSubview:self.pickerView];
            return NO;
        }
        return NO;
    }
    else if (textField == self.txtCountry) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *path = [docDir stringByAppendingPathComponent:@"countries.json"];
            NSDictionary *dictcountries= (NSDictionary *)[IODUtils loadJsonDataFromPath:path];
            arrCountryList = [dictcountries valueForKey:@"data"] ;
            self.pickerView.data = [arrCountryList valueForKey:@"country_name"];
            self.pickerView.delegate = self;
            self.pickerView.preSelectedValue = textField.text;
            self.pickerView.refernceView = textField;
            [self.view addSubview:self.pickerView];
            return NO;
        }
        return NO;
    }
    else if (textField == self.txtDOB){
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
        CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
        NSDate *date =[NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:-110];
        NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
        [comps setYear:-110];
        _datePickerView = [[UIView alloc] initWithFrame:pickerFrame];
        //time interval in seconds
        CGSize buttonSize = CGSizeMake(SCREEN_WIDTH/2, 44);
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame = CGRectMake(0, 0, buttonSize.width, 50);
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(onDoneButton)
             forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(CGRectGetMaxX(doneButton.frame), 0, buttonSize.width, 50);
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(onCancelButton)
               forControlEvents:UIControlEventTouchUpInside];
        doneButton.titleLabel.textColor = cancelButton.titleLabel.textColor = [UIColor whiteColor];
        [doneButton setBackgroundColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
        [cancelButton setBackgroundColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
        
        [_datePickerView addSubview:doneButton];
        [_datePickerView addSubview:cancelButton];
        datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 250)];
        [datePicker setMaximumDate:date];
        [datePicker setMinimumDate:minDate];
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.datePickerMode=UIDatePickerModeDate;
        [_datePickerView addSubview:datePicker];
        [textField setInputView:_datePickerView];
    }
    
    else if (textField == self.txtQualificationyear){
        
        CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
        CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
        _datePickerView = [[UIView alloc] initWithFrame:pickerFrame];
        //time interval in seconds
        CGSize buttonSize = CGSizeMake(SCREEN_WIDTH/2, 44);
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame = CGRectMake(0, 0, buttonSize.width, 50);
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(onDoneButtonYearPicker)
             forControlEvents:UIControlEventTouchUpInside];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(CGRectGetMaxX(doneButton.frame), 0, buttonSize.width, 50);
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(onCancelButtonYearPicker)
               forControlEvents:UIControlEventTouchUpInside];
        doneButton.titleLabel.textColor = cancelButton.titleLabel.textColor = [UIColor whiteColor];
        [doneButton setBackgroundColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
        [cancelButton setBackgroundColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
        
        [_datePickerView addSubview:doneButton];
        [_datePickerView addSubview:cancelButton];
        [yearPicker setFrame:CGRectMake(0, 50, SCREEN_WIDTH, 250)];
        yearPicker.backgroundColor = [UIColor whiteColor];
        [_datePickerView addSubview:yearPicker];
        [textField setInputView:_datePickerView];
    }
    else if (textField == self.txtState) {
        if(_txtCountry.text.length > 0) {
            [textField setEnabled:YES];
            [textField resignFirstResponder];
            [self.view endEditing:YES];
            if(!self.pickerView) {
                CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
                CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
                self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
                self.pickerView.data = [arrStateList valueForKey:@"state_name"];
                self.pickerView.delegate = self;
                self.pickerView.preSelectedValue = textField.text;
                self.pickerView.refernceView = textField;
                [self.view addSubview:self.pickerView];
                return NO;
            }
            else {
                //  [textField setEnabled:NO];
            }
        }
        else{
            [IODUtils showMessage:@"Please select Country first" withTitle:@""];
        }
        return NO;
    }
    else if(textField == self.txtLicenseStates) {
        
        [textField setEnabled:YES];
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
            self.pickerView.data = [arrStateList valueForKey:@"state_name"];
            self.pickerView.delegate = self;
            self.pickerView.preSelectedValue = textField.text;
            self.pickerView.refernceView = textField;
            [self.view addSubview:self.pickerView];
            return NO;
        }
        return NO;
    }
    else if (textField == self.txtLanguageKnown) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.multiSelect = [[MultiSelectTableView alloc] initWithFrame:pickerFrame];
            NSDictionary *dictgender = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"language" ofType:@"json"]];
            NSArray *gender= [dictgender valueForKey:@"Language"];
            self.multiSelect.dataArray = gender;
            self.multiSelect.delegate = self;
            self.multiSelect.preSelectedValue = self.txtLanguageKnown.text;
            [self.multiSelect setPreSelectData];
            [self.view addSubview:self.multiSelect];
            return NO;
        }
        return NO;
    }
    else if (textField == self.txtspecial) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *path = [docDir stringByAppendingPathComponent:@"specialization.json"];
            NSDictionary *dictcountries= (NSDictionary *)[IODUtils loadJsonDataFromPath:path];
            arrspecializationList = [dictcountries valueForKey:@"data"];
            self.pickerView.data = [arrspecializationList valueForKey:@"name"];
            self.pickerView.delegate = self;
            self.pickerView.preSelectedValue = textField.text;
            self.pickerView.refernceView = textField;
            [self.view addSubview:self.pickerView];
        }
        return NO;
    }
    else if (textField == self.txtCity) {
        
        
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(_txtState.text.length > 0 ){
            if(!self.pickerView) {
                CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
                CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
                self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
                self.pickerView.data = [arrcityList valueForKey:@"city_name"];
                self.pickerView.delegate = self;
                self.pickerView.preSelectedValue = textField.text;
                self.pickerView.refernceView = textField;
                [self.view addSubview:self.pickerView];
                return NO;
            }
        }
        else{
            [IODUtils showMessage:@"Please select State first" withTitle:@""];
        }
        
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField==_txtMobile)
    {
        const char *_char = [string cStringUsingEncoding:NSUTF8StringEncoding];
        int isBackSpace = strcmp(_char, "\b");
        if (isBackSpace == -8) {
            return YES;
        }
        // If it's not a backspace, allow it if we're still under 30 chars.
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 10) ? NO : YES;
    }
    
    if(textField == _txtReferalCode)
    {
        const char *_char = [string cStringUsingEncoding:NSUTF8StringEncoding];
        int isBackSpace = strcmp(_char, "\b");
        if (isBackSpace == -8) {
            return YES;
        }
        // If it's not a backspace, allow it if we're still under 30 chars.
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 6) ? NO : YES;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Date Picker
-(void)onDoneButton
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY"];
    self.txtDOB.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.txtDOB resignFirstResponder];
}


-(void)onCancelButton {
    [self.txtDOB resignFirstResponder];
    [_datePickerView removeFromSuperview];
}

#pragma mark - Date Picker
-(void)onDoneButtonYearPicker
{
    [self updateLabel];
    [self.txtQualificationyear resignFirstResponder];
}
-(void)onCancelButtonYearPicker {
    [self.txtQualificationyear resignFirstResponder];
    [_datePickerView removeFromSuperview];
}
#pragma mark Year Picker
// Initialize the picker
- (void) setYearPicker {
    yearPicker = [[NTMonthYearPicker alloc] init];
    [yearPicker addTarget:self action:@selector(onDatePicked:) forControlEvents:UIControlEventValueChanged];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *cal = [NSCalendar currentCalendar];
    // Set mode to month + year
    // This is optional; default is month + year
    yearPicker.datePickerMode = NTMonthYearPickerModeYear;
    // Set minimum date to January 2000
    // This is optional; default is no min date
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:1907];
    yearPicker.minimumDate = [cal dateFromComponents:comps];
    
    // Set maximum date to next month
    // This is optional; default is no max date
    [comps setDay:0];
    [comps setMonth:1];
    [comps setYear:0];
    yearPicker.maximumDate = [cal dateByAddingComponents:comps toDate:[NSDate date] options:0];
    
    // Set initial date to last month
    // This is optional; default is current month/year
    [comps setDay:0];
    [comps setMonth:-1];
    [comps setYear:0];
    yearPicker.date = [cal dateByAddingComponents:comps toDate:[NSDate date] options:0];
    // Initialize UI label and mode selector
    [self updateLabel];
}

- (void)onDatePicked:(UITapGestureRecognizer *)gestureRecognizer {
    [self updateLabel];
}
- (void)updateLabel {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy"];
    NSString *dateStr = [df stringFromDate:yearPicker.date];
    _txtQualificationyear.text = [NSString stringWithFormat:@"%@", dateStr];
}


#pragma mark - StringPickerViewDelegate
- (void)stringPickerViewDidSelectDone:(StringPickerView *)view
{
    if( [self.pickerView.refernceView isKindOfClass:[UITextField class]] )
    {
        UITextField *textField = (UITextField*)view.refernceView;
        if(textField == _txtCountry){
            _txtState.text = @"";
            _txtCity.text = @"";
            _txtDea.text = @"";
            textField.text = self.pickerView.value;
            int a = self.pickerView.selectedId;
            NSString *strselectedCntry = [[arrCountryList objectAtIndex:a] valueForKey:@"country_id"] ;
            selectedCountryId = 0;
            selectedCountryId = [strselectedCntry intValue];
            
            [self  getAllStatesWith:selectedCountryId];
            // [[NSUserDefaults standardUserDefaults] setInteger:selectedCountryId forKey:@"countryid"];
            if([_txtCountry.text isEqualToString:@"United States"]){
                [_licenseState setHidden:NO];
                [_dea setHidden:NO];
                [_txtState setPlaceholder:@"*State"];
            }
            else {
                _txtLicenseStates.text = @"";
                [_txtState setPlaceholder:@"State"];
                [_licenseState setHidden:YES];
                [_dea setHidden:YES];
            }
        }
        
        else if(textField == _txtState){
            textField.text = self.pickerView.value;
            _txtCity.text = @"";
            selectedStateId = [[[arrStateList objectAtIndex:self.pickerView.selectedId] valueForKey:@"state_id"] intValue];
            _txtCity.text = @"";
            
            //  [self  getAllCitieWith:selectedStateId];
        }
        else if(textField == _txtCity){
            if (arrcityList.count > 0 ) {
                textField.text = self.pickerView.value;
                selectedCityId =[[[arrcityList objectAtIndex:self.pickerView.selectedId ] valueForKey:@"city_id"] intValue];
            }
        }
        else if(textField == _txtgender){
            textField.text = self.pickerView.value;
            selectedGenderId = self.pickerView.selectedId+1;
        }
        else if(textField == _txtExperince){
            textField.text = self.pickerView.value;
        }
        else if(textField == _txtLanguageKnown){
            if(![textField.text containsString:self.pickerView.value]){
                NSString *strLanguage = [NSString stringWithFormat:@"%@,%@",textField.text,self.pickerView.value];
                if ([strLanguage hasPrefix:@","]) {
                    strLanguage = [strLanguage substringFromIndex:1];
                }
                textField.text = strLanguage;
            }
        }
        else if(textField == _txtLicenseStates){
            
            NSString *strLicense = [NSString stringWithFormat:@"%@,%@",textField.text,self.pickerView.value];
            
            NSString *str = [NSString stringWithFormat:@"%@",[[arrStateList objectAtIndex:self.pickerView.selectedId] valueForKey:@"state_id"]];
            selectedLicenceSates =[NSString stringWithFormat:@"%@,%@",selectedLicenceSates,str];
            
            
            if ([strLicense hasPrefix:@","]) {
                strLicense = [strLicense substringFromIndex:1];
                selectedLicenceSates = [selectedLicenceSates substringFromIndex:1];
            }
            
            
            textField.text = strLicense;
            if(![_txtCountry.text isEqualToString:@"United States"]){
                selectedLicenceSates = @"";
            }
        }
        else if(textField == _txtspecial){
            if(![textField.text containsString:self.pickerView.value]){
                textField.text = self.pickerView.value;
                specializationId = [[[arrspecializationList objectAtIndex:self.pickerView.selectedId] valueForKey:@"id"] intValue];
            }
        }
    }
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}

- (void)stringPickerViewDidSelectCancel:(StringPickerView *)view
{
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}

#pragma mark - MultiSelect Table Delegate

-(void)multiSelectTableviewDoneClick
{
    self.txtLanguageKnown.text = self.multiSelect.returnValue;
    [self.multiSelect removeFromSuperview];
}

-(void)multiSelectTableviewCancelClick
{
    [self.multiSelect removeFromSuperview];
}

#pragma mark -- API Calls
-(void)getAllStatesWith:(int)countryId {
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable){
        if (countryId > 0) {
            CommonServiceHandler *service = [[CommonServiceHandler alloc]init];
            NSDictionary *parameter = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:countryId] ,@"country_id", nil];
            // selectedCountryId = countryId;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service getAllStatesgetDataWith:parameter WithCompletionBlock:^(NSArray *state, NSError *error) {
                arrStateList = state;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }
    }
    else {
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        _txtCountry.text =@"";
        _txtState.text = @"";
        _txtCity.text = @"";
    }
}

-(void)getAllCitieWith:(int)stateId {
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable){
        CommonServiceHandler *service = [[CommonServiceHandler alloc]init];
        NSDictionary *parameter = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:stateId] ,@"state_id", nil];
        selectedStateId = stateId;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service getAllCityDataWith:parameter WithCompletionBlock:^(NSArray *state, NSError *error) {
            //NSLog(@"States %@",state.class);
            arrcityList = state;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    else {
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        _txtCountry.text = @"";
        _txtCity.text = @"";
        _txtState.text = @"";
    }
}


- (void) regiserDoctor {
    
    int country = [regServCall.strCountry intValue];
    int state = [regServCall.strState intValue];
    int city = [regServCall.strCity intValue];
    int pincode = [regServCall.strPinCode intValue];
    int mobile = [regServCall.strMobile intValue];
    int gender = [regServCall.strGender intValue];
    int experience = [regServCall.experience intValue];
    int specialization = [regServCall.specialization intValue];
    NSString *strReferal = _txtReferalCode.text;
    
    NSMutableDictionary *userdata = [[NSMutableDictionary alloc] init];
    [userdata setObject:regServCall.strEmail forKey:@"email"];
    [userdata setObject:regServCall.strPassword  forKey:@"password"];
    [userdata setObject:regServCall.strFullname forKey:@"name"];
    [userdata setObject:[NSNumber numberWithInt:gender] forKey:@"gender"];
    [userdata setObject:regServCall.strDOB forKey:@"dob"];
    [userdata setObject:[NSNumber numberWithInt:country] forKey:@"country"];
    [userdata setObject:[NSNumber numberWithInt:state] forKey:@"state"];
    [userdata setObject:[NSNumber numberWithInt:mobile] forKey:@"mobile"];
    [userdata setObject:strReferal forKey:@"tier_code"];
    
    
    [userdata setObject:regServCall.highestQualification forKey:@"qualification"];
    [userdata setObject:regServCall.RegistrationNumber forKey:@"registration_no_npi_no"];
    [userdata setObject:regServCall.deaNumber forKey:@"dea_no"];
    [userdata setObject:[NSNumber numberWithInt:experience] forKey:@"experience"];
    [userdata setObject:[NSNumber numberWithInt:specialization] forKey:@"specialization_id"];
    [userdata setObject:regServCall.licence forKey:@"license_state_list"];
    [userdata setObject:regServCall.language forKey:@"language"];
    [userdata setObject:regServCall.imageData forKey:@"documents[]"];
    RegistrationService *service = [[RegistrationService alloc] init];
    
    if(regServCall.imageData >0){
        if (self.checkbox.checked == YES) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service doDoctorRegistrationWithParameters:userdata andImageName:regServCall.nameArray andArraray:regServCall.imageData dataType:regServCall.arrDocType withCompletionBlock:^(id response, NSError *error) {
                //NSLog(@"respinse %@", response);
                if(response) {
                    NSString *status = [response objectForKey:@"status"];
                    if([status isEqualToString:@"success"]) {
                        //Registration Successful
                        [self.navigationController popViewControllerAnimated:YES];
                        [IODUtils showMessage:[response valueForKey:@"message"] withTitle:@"Verify Email"];
                        regServCall.imageData = [[NSMutableArray alloc]init];
                    }
                    if(error)
                        [IODUtils showMessage:@"Please enter valid data" withTitle:@"Error"];
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }
        else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [IODUtils showMessage:@"Please agree to terms and conditions" withTitle:@"Error"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            return;
            
            
        }
    }
    else{
        [IODUtils showMessage:@"Please select document" withTitle:@"Error"];
    }
    
}

-(void)validateEmail {
    NSMutableDictionary *mparameters = [[NSMutableDictionary alloc] init];
    [mparameters setObject:_txtEmail.text forKey:@"email"];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDob =[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    regServCall.strEmail = self.txtEmail.text;
    regServCall.strFullname = self.txtFullName.text;
    regServCall.strPassword = self.txtPassword.text;
    regServCall.strDOB = strDob;
    regServCall.strGender = [NSString stringWithFormat:@"%d",selectedGenderId];
    regServCall.strGender = [NSString stringWithFormat:@"%d",[IODUtils getGenderId:_txtgender.text]];
    regServCall.highestQualification = self.txtHighestQualificaion.text;
    regServCall.language = self.txtLanguageKnown.text;
    regServCall.specialization = [NSString stringWithFormat:@"%d",specializationId ];
    regServCall.experience = _txtExperince.text;
    
    RegistrationService *service = [[RegistrationService alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service validateEmail:mparameters withCompletionBlock:^(id response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(response){
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
                [self NextPageCall];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ForceUpdateLocation" object:self userInfo:@{@"pnumb":@"1",@"direction":kNext}];
            }
        }
        if(error)
            //[IODUtils showAlertView:@"Email id already exists" WithTitle:@"Error"];
            // [IODUtils showMessage:[error valueForKey:@"message"] withTitle:@"Error"];
            [IODUtils showMessage:[error valueForKey:@"message"] withTitle:@"Error"];
    }];
}

@end
