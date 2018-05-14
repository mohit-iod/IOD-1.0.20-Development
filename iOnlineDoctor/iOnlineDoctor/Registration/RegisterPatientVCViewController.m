//
//  RegisterPatientVCViewController.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/27/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "RegisterPatientVCViewController.h"
#import "IODUtils.h"
#import "UIColor+HexString.h"
#import "CommonServiceHandler.h"
#import "RegistrationService.h"
#import "AppSettings.h"
#import "MBProgressHUD.h"
#import "UITextView+Placeholder.h"
#import "FileViewerVC.h"

@interface RegisterPatientVCViewController () {
    NSArray *arrCountryList;
    NSArray *arrStateList;
    NSArray *arrcityList;
}

@end

static int selectedCountryId;
static int selectedStateId;
static int selectedCityId;
static int selectedGenderId;
@implementation RegisterPatientVCViewController

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if(reachable) {
        [self getCountryList];
    }
    else {
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
    
    [super viewDidLoad];
    self.title = @"Sign Up";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    
    [_state setHidden:YES];

    UITapGestureRecognizer *tapG=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(termsLogin)];
    [_lblTerms addGestureRecognizer:tapG];
    _lblTerms.userInteractionEnabled=YES;
    
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
    //  [self setPageViewController];
    self.txtGender.inputView = self.pickerView;
    self.txtState.inputView = self.pickerView;
    self.txtCity.inputView = self.pickerView;
    self.txtViewAddress.placeholder = @"Address";
    // Do any additional setup after loading the view.
}


//Get Country list.
- (void)getCountryList {
    CommonServiceHandler *commonService = [[CommonServiceHandler alloc] init];
    [commonService getAllCountriesWithCompletion:^(NSArray *array) {
    }];
}

-(void)termsLogin{
    // call link to terms
    FileViewerVC *fileViewMe  = [self.storyboard instantiateViewControllerWithIdentifier:@"FileViewerVC"];
    fileViewMe.strFilePath= @"http://www.ionlinedoctor.com/termsandconditionsm";
    fileViewMe.strTitle= @"Terms & Conditions, Privacy Policy";
    [self.navigationController pushViewController:fileViewMe animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnNext:(id)sender {
    
  //  [_btnSubmit setEnabled:NO];
  // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable)
    {
        if (![IODUtils getError:self.txtFullname minVlue:@"4" minVlue:@"50" onlyNumeric:NO onlyChars:YES canBeEmpty:NO checkEmail:NO minAge:nil maxAge:nil canBeSameDate:NO ]) {
        }
        else if(![IODUtils getError:self.txtEmail minVlue:@"0" minVlue:@"100" onlyNumeric:NO onlyChars:NO canBeEmpty:NO checkEmail:YES minAge:nil maxAge:nil canBeSameDate:NO ]){
        }
        else if(![IODUtils getError:self.txtPassword minVlue:@"6" minVlue:@"30" onlyNumeric:NO onlyChars:NO canBeEmpty:NO checkEmail:NO minAge:nil maxAge:nil canBeSameDate:NO ]){
        }
        else if(![IODUtils getError:self.txtDOB minVlue:nil minVlue:nil onlyNumeric:NO onlyChars:NO canBeEmpty:NO checkEmail:NO minAge:@"18" maxAge:@"110" canBeSameDate:NO ]){
        }
        else  if (![IODUtils getError:self.txtCountry minVlue:nil minVlue:nil onlyNumeric:NO onlyChars:NO canBeEmpty:NO checkEmail:NO minAge:nil maxAge:nil canBeSameDate:NO ]) {
        }
        else if(self.checkbox.checked == NO){
          //  [IODUtils showMessage:kAgreeTerms withTitle:@"Error"];
               [IODUtils showFCAlertMessage:kAgreeTerms withTitle:nil withViewController:self with:@"error" ];
        }
        else{
            if([_txtCountry.text isEqualToString:@"United States"]) {
                if(![IODUtils getError:self.txtState minVlue:@"1" minVlue:@"15" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:NO minAge:nil maxAge:nil canBeSameDate:NO
                     ]){
                    UILabel *lab=[IODUtils getErrorLabel:(UITextField *)self.txtState];
                    lab.text=@"State cannot be blank";
                  //  [IODUtils showMessage:@"State cannot be blank" withTitle:@""];
                    
                    [IODUtils showFCAlertMessage:@"State cannot be blank" withTitle:nil withViewController:self with:@"error" ];
                }
                else if (![IODUtils getError:self.txtMobile minVlue:@"10" minVlue:@"10" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:NO minAge:nil maxAge:nil canBeSameDate:NO ]) {
                }
                else if(self.checkbox.checked == NO){
                  //  [IODUtils showMessage:kAgreeTerms withTitle:@"Error"];
                       [IODUtils showFCAlertMessage:kAgreeTerms withTitle:nil withViewController:self with:@"error" ];
                    
                }
                else {
                    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
                    BOOL reachable = reach. isReachable;
                    if (reachable)
                    {
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [self verifyreferralCode];
                    }
                    else{
                        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
                    }
                }
            }else{
                
                    {
                    if (![IODUtils getError:self.txtMobile minVlue:@"10" minVlue:@"10" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]) {
                    }
                    else {
                        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
                        BOOL reachable = reach. isReachable;
                        if (reachable)
                        {
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self verifyreferralCode];
                        }
                        else{
                            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
                        }
                    }
                }
            }
        }
    }

    else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}
- (UILabel *)getErrorText:(UITextField *)useText{
    
    for(UIView *v in useText.superview.subviews ){
        if (v.tag == 10) {
            return (UILabel *)v;
        }
    }
    return [UILabel new];
}
#pragma mark - UITextFieldDelegate

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


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.txtGender) {
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
            [self.view.window addSubview:self.pickerView];;
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
            [self.view.window addSubview:self.pickerView];;
            return NO;
        }
        else {
        }
        return NO;
    }
    
    else if (textField == self.txtDOB){
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
    else if (textField == self.txtState) {
        if(_txtCountry.text.length >0) {
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
                [self.view.window addSubview:self.pickerView];;
                return NO;
            }
            else {
             //   [textField setEnabled:NO];
            }
        }
        else  {
          //  [IODUtils showMessage:@"Please select Country first" withTitle:@""];
            
            [IODUtils showFCAlertMessage:@"Please select Country first" withTitle:nil withViewController:self with:@"error" ];

            
        }
        return NO;
    }
    else if (textField == self.txtCity) {
        
        if(_txtState.text.length > 0){
            [textField resignFirstResponder];
            [self.view endEditing:YES];
            if(!self.pickerView) {
                CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
                CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
                self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
                self.pickerView.data = [arrcityList valueForKey:@"city_name"];
                self.pickerView.delegate = self;
                self.pickerView.preSelectedValue = textField.text;
                self.pickerView.refernceView = textField;
                [self.view.window addSubview:self.pickerView];;
                return NO;
            }
            else
            {
            }
            return NO;
        }
        }
        else {
         //   [IODUtils showMessage:@"Please select State first" withTitle:@""];
        }
    
    return YES;
}

#pragma mark - StringPickerViewDelegate
- (void)stringPickerViewDidSelectDone:(StringPickerView *)view
{
    if( [self.pickerView.refernceView isKindOfClass:[UITextField class]] )
    {
        UITextField *textField = (UITextField*)view.refernceView;
        if(textField == _txtCountry){
            _txtState.text = @"";
            textField.text = self.pickerView.value;
            int a = self.pickerView.selectedId;
            selectedCountryId =[[[arrCountryList objectAtIndex:a]valueForKey:@"country_id"] intValue];
            
            if([textField.text isEqualToString:@"United States"]){
                [self  getAllStatesWith:selectedCountryId];
                _txtState.placeholder = @"State*";

                [_state setHidden:NO];

            }
            else{
                [_state setHidden:YES];
                _txtState.placeholder = @"State";
            }
        }
        
        else if(textField == _txtState){
            textField.text = self.pickerView.value;
            _txtCity.text = @"";
            selectedStateId = [[[arrStateList objectAtIndex:self.pickerView.selectedId] valueForKey:@"state_id"] intValue];
            _txtCity.text = @"";

            //[self  getAllCitieWith:selectedStateId];
        }
        else if(textField == _txtCity){
            
            if (arrcityList.count > 0 ) {
                textField.text = self.pickerView.value;
                selectedCityId =[[[arrcityList objectAtIndex:self.pickerView.selectedId ] valueForKey:@"city_id"] intValue];
            }
        }
        else if(textField == _txtGender){
            textField.text = self.pickerView.value;
            selectedGenderId = self.pickerView.selectedId+1;
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

- (IBAction)btnActionSubmit:(id)sender {
    
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable){
        if (![IODUtils getError:self.txtCountry minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]) {
            UILabel *lab=[IODUtils getErrorLabel:(UITextField *)self.txtState];
            lab.text=@"State cannot be blank";
        }
        else if(![IODUtils getError:self.txtState minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
            UILabel *lab=[IODUtils getErrorLabel:(UITextField *)self.txtDOB];
            lab.text=@"State cannot be blank";
            
        }
        else if(![IODUtils getErrorLabelWith:self.txtPinCode minVlue:@"5" minVlue:@"6" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
        }
        else if(![IODUtils getErrorLabelWith:self.txtMobile minVlue:@"10" minVlue:@"10" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
        }
        
        else if(![IODUtils getErrorLabelWith:self.txtMobile minVlue:@"10" minVlue:@"10" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
        }
        
        else if([_txtCountry.text isEqualToString:@"United States"]){
            if(![IODUtils getErrorLabelWith:self.txtState minVlue:nil minVlue:nil
                                onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
                
                UILabel *lab=[IODUtils getErrorLabel:(UITextField *)self.txtState];
                lab.text=@"State cannot be blank";
            }
            else{
                Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
                BOOL reachable = reach. isReachable;
                if (reachable)
                    [self registerPatient];
                else
                    [IODUtils showMessage:INTERNET_ERROR withTitle:@"Errror"];
            }
        }
        
        else{
            Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
            BOOL reachable = reach. isReachable;
            if (reachable)
                [self registerPatient];
            else
                [IODUtils showMessage:INTERNET_ERROR withTitle:@"Errror"];
        }
    }
    else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}

-(IBAction)termsLogin:(id)sender{
    // call link to terms
    //https://www.ionlinedoctor.com/terms-and-conditions.html
    FileViewerVC *fileViewMe  = [self.storyboard instantiateViewControllerWithIdentifier:@"FileViewerVC"];
    fileViewMe.strFilePath=@"http://www.ionlinedoctor.com/termsandconditionsm";
    fileViewMe.strTitle=@"Terms & Conditions, Privacy Policy";
    fileViewMe.hideMenu=YES;
    [self.navigationController pushViewController:fileViewMe animated:YES];
}

- (IBAction)btnPrevious:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ForceUpdateLocation" object:self userInfo:@{@"pnumb":@"0",@"direction":@"back"}];
}

#pragma mark -- API Calls

#pragma mark -- API Calls
-(void)getAllStatesWith:(int)countryId {
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable){
        if (countryId > 0) {
            CommonServiceHandler *service = [[CommonServiceHandler alloc]init];
            NSDictionary *parameter = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:countryId] ,@"country_id", nil];
            selectedCountryId = countryId;
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

-(IBAction)testChecking {
    self.checkbox.checked = !self.checkbox.checked;
}


-(void)validateEmail {
    
    NSMutableDictionary *mparameters = [[NSMutableDictionary alloc] init];
    [mparameters setObject:_txtEmail.text forKey:@"email"];
    RegistrationService *service = [[RegistrationService alloc] init];
 //   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.checkbox.checked == YES){
      
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        if (reachable)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service validateEmail:mparameters withCompletionBlock:^(id response, NSError *error) {
            
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if([[response objectForKey:@"status"] isEqualToString:@"success"]){
                    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *strDob =[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
                    int gender = [IODUtils getGenderId:_txtGender.text];
                    NSMutableDictionary *mparameters = [[NSMutableDictionary alloc] init];
                    [mparameters setObject:_txtEmail.text forKey:@"email"];
                    [mparameters setObject:_txtPassword.text forKey:@"password"];
                    [mparameters setObject:_txtMobile.text forKey:@"mobile"];
                    
                    
                    [mparameters setObject:_txtFullname.text forKey:@"name"];
                    [mparameters setObject:strDob forKey:@"dob"];
                    [mparameters setObject: [NSNumber numberWithInt:selectedCountryId]forKey:@"country"];
                    [mparameters setObject:[NSNumber numberWithInt:selectedStateId] forKey:@"state"];
                    [mparameters setObject:_txtReferalCode.text forKey:@"tier_code"];
                    RegistrationService *service = [[RegistrationService alloc] init];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    
                    [service doRegistrationWithParameters:mparameters withCompletionBlock:^(id response, NSError *error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        NSString *status = [response valueForKey:@"status"];
                        
                        if([status isEqualToString:@"success"]) {
                            //Registration Successful
                            [self.navigationController popViewControllerAnimated:YES];
                            
                            [IODUtils showFCAlertMessage:[response valueForKey:@"message"] withTitle:nil withViewController:self with:@"succedd" ];

                           // [IODUtils showMessage:[response valueForKey:@"message"] withTitle:@"Verify Email"];
                        }
                        else if([[response objectForKey:@"status"] isEqualToString:@"fail"]){
                            NSString* message = [NSString stringWithFormat:@"%@",[response objectForKey:@"message"]];
                           // [IODUtils showMessage:message withTitle:@""];
                            [IODUtils showFCAlertMessage:message withTitle:nil withViewController:self with:@"error" ];

                        }
                        else if(error){
                           // [IODUtils showMessage:[error valueForKey:@"data"] withTitle:@""];
                          //  [IODUtils showMessage:[error valueForKey:@"message"] withTitle:@"Error"];

                            [IODUtils showFCAlertMessage:[error valueForKey:@"message"] withTitle:nil withViewController:self with:@"error" ];

                        }
                        else {
                            
                            [UIApplication sharedApplication].idleTimerDisabled = YES;
                           // [IODUtils showMessage:@"Please enter valid data" withTitle:@"Error"];
                            
                            [IODUtils showFCAlertMessage:@"Please enter valid data" withTitle:nil withViewController:self with:@"error" ];
                        }
                    }];
                }
                else if([[response objectForKey:@"status"] isEqualToString:@"fail"]){
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                    NSString* message = [NSString stringWithFormat:@"%@",[response objectForKey:@"message"]];
                    //[IODUtils showMessage:message withTitle:@""];
                    [IODUtils showFCAlertMessage:message withTitle:nil withViewController:self with:@"error" ];
                }
                else if(error){
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                   // [IODUtils showMessage:[[error valueForKey:@"data"] valueForKey:@"email"]  withTitle:@"Error"];
                    
                    [IODUtils showFCAlertMessage:error.description withTitle:nil withViewController:self with:@"error" ];
                }
                else {
                    [UIApplication sharedApplication].idleTimerDisabled = YES;
                    
                    [IODUtils showFCAlertMessage:@"Please enter valid data" withTitle:nil withViewController:self with:@"error" ];

                }
            }];
        }
        else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
 
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];

      
    }
    else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
       // [IODUtils showMessage:kAgreeTerms withTitle:@"Error"];
         [IODUtils showFCAlertMessage:kAgreeTerms withTitle:nil withViewController:self with:@"error" ];
    }
}
-(void)registerPatient {

}

-(void)verifyreferralCode{
    if(_txtReferalCode.text.length > 0){
            RegistrationService *service = [[RegistrationService alloc] init];
            NSMutableDictionary *userdata = [[NSMutableDictionary alloc] init];
            [userdata setObject:_txtReferalCode.text forKey:@"reffral_code"];
            [userdata setObject:@"patient" forKey:@"user_type"];
           
            Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
            BOOL reachable = reach. isReachable;
            if (reachable)
            {
                if(_txtReferalCode.text.length > 0 ){
                    [service validateReferalCode:userdata withCompletionBlock:^(id response, NSError *error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if(error){
                           // [IODUtils showMessage:[error valueForKey:@"message"] withTitle:@"Error"];
                            
                            [IODUtils showFCAlertMessage:[error valueForKey:@"message"] withTitle:nil withViewController:self with:@"error" ];

                            
                        }
                        else if([[response  valueForKey:@"status"] isEqualToString:@"success"]) {
                            //[self regiserDoctor];
                            if([[response valueForKey:@"message"] isEqualToString:@"This reffral code is not valid."]){
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                               //
                              //  [IODUtils showMessage:[response valueForKey:@"message"] withTitle:@"Error"];
                                
                                     [IODUtils showFCAlertMessage:[response valueForKey:@"message"] withTitle:nil withViewController:self with:@"error" ];
                            }
                            else{
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                
                                [self validateEmail];
                               // [MBProgressHUD hideHUDForView:self.view animated:YES];
                            }
                        }
                        else if([[response  valueForKey:@"status"] isEqualToString:@"fail"]){
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            
                            [IODUtils showFCAlertMessage:[[response valueForKey:@"date"]valueForKey:@"tier_code" ] withTitle:nil withViewController:self with:@"error" ];
                        }
                    }];
                }
                else{
                    [self validateEmail];
                }
            }
            else{
                //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
            }
            
        }
    else{
    [self validateEmail];
    }
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}

-(void)refreshView:(NSNotification*)notification{
    [self getCountryList];
}

@end
