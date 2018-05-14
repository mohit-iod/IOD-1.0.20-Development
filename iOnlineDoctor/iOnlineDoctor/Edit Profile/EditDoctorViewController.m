//
//  EditDoctorViewController.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 10/3/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "EditDoctorViewController.h"
#import "CommonServiceHandler.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HexString.h"
#import "NTMonthYearPicker.h"

@interface EditDoctorViewController () <StringPickerViewDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,MultiSelectTableViewDelegate>
{
    UIDatePicker *datePicker;
    int selectedGenderId;
    NSArray *arrCountryList;
    NSArray *arrStateList;
    NSArray *arrcityList;
    
    int countryId;
    int stateId;
    int cityId;
    
    NSArray *arrLanguages;
    NSString * language;
    NSArray *arrspecializationList;
    NSString *specializationList;
    
    NSString *selectedLicenceSates;
    NTMonthYearPicker *yearPicker;
}

@end

static int selectedCountryId;
static int selectedStateId;
static int selectedCityId;

@implementation EditDoctorViewController

#pragma mark - View Controller Methods

- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    [super viewDidLoad];
    [self setYearPicker];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach.isReachable;
    if (reachable){
        [self getUserPrfile];
    }else {
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
    
    NSDictionary *dictData;
    NSString *strProfile;
    NSString *userType  = UDGet(@"usertype");
    
    if([userType isEqualToString:@"Patient"]){
        dictData=[NSKeyedUnarchiver unarchiveObjectWithData: UDGet(@"userinfo")];
        strProfile = [NSString stringWithFormat:@"%@",UDGet(@"profilePic")];
    }
    else{
        dictData=[NSKeyedUnarchiver unarchiveObjectWithData: UDGet(@"userinfodoc")];
        strProfile = [NSString stringWithFormat:@"%@",UDGet(@"docprofilePic")];
    }
    
    
    UITapGestureRecognizer *tapG=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editImgClicked:)];
    [_imgProfile setUserInteractionEnabled:YES];
    [_imgProfile addGestureRecognizer:tapG];
    [_imgProfile layoutIfNeeded];
    _imgProfile.layer.cornerRadius=_imgProfile.frame.size.height/2;
    [_imgProfile.layer setBorderWidth:2.0];
    _imgProfile.clipsToBounds = YES;
    [_imgProfile.layer setBorderColor:[UIColor whiteColor].CGColor];
    _txtCountry.enabled = false;
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.title =@"My Profile";
    // [_dea setHidden:YES];
    // [_state setHidden:YES];
}

-(void)setPlaceHolder{
    
}

#pragma mark - Void Methods

-(void)viewDidLayoutSubviews{
    _imgProfile.layer.cornerRadius=_imgProfile.frame.size.height/2;
    [_imgProfile.layer setBorderWidth:2.0];
    _imgProfile.clipsToBounds = YES;
    [_imgProfile.layer setBorderColor:[UIColor whiteColor].CGColor];
    _imgProfile.layer.masksToBounds=YES;
}

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) getUserPrfile{
    
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service getUserProfile:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]){
            //NSLog(@"Response code %@", responseCode);
            NSDictionary *dictdata = [responseCode valueForKey:@"data"];
            _txtFullName.text = [dictdata  valueForKey:@"name"];
            _txtDOB.text = [IODUtils formatDateForUIFromString:[dictdata valueForKey:@"dob"]];
            _txtgender.text = [dictdata valueForKey:@"gender"];
            arrLanguages = [dictdata valueForKey:@"languages"];
            if([arrLanguages isKindOfClass:[NSArray class]] ){
                language =[ [arrLanguages valueForKey:@"description"] componentsJoinedByString:@","];
            }
            else{
                language = [dictdata valueForKey:@"languages"];
            }
            _txtLanguageKnown.text = language;
            
            NSArray *licence = [[dictdata valueForKey:@"license_states"] valueForKey:@"name"];
            NSString * licenStates = [[licence valueForKey:@"description"] componentsJoinedByString:@","];
            
            _txtLicenseStates.text = licenStates;
            
            UIImage *imgPro=[NSKeyedUnarchiver unarchiveObjectWithData: UDGet(@"propic")];
            if (!imgPro) {
                imgPro=[UIImage imageNamed:@"P-calling-icon.png"] ;
            }
            [_imgProfile sd_setImageWithURL:[NSURL URLWithString:[dictdata valueForKey:@"profile_pic"]] placeholderImage:imgPro];
            _txtEmail.text = [dictdata valueForKey:@"email"];
            _txtPinCode.text = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"pincode"]];
            _txtAdditionalQualification.text = [dictdata valueForKey:@"additional_qualification"];
            _txtCountry.text = [dictdata valueForKey:@"country"];
            _txtState.text = [dictdata valueForKey:@"state"];
            _txtCity.text = [dictdata valueForKey:@"city"];
            _txtHighestQualificaion.text = [dictdata valueForKey:@"qualification"];
            _txtUnitversity.text = [dictdata valueForKey:@"university"];
            _txtDea.text = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"dea_no"]];
            _txtExperince.text = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"experience"]];
            _txtQualificationyear.text =[NSString stringWithFormat:@"%@",[dictdata valueForKey:@"qualification_year"]] ;
            _txtMobile.text = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"mobile"]];
            _txtregistration.text = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"registration_no_npi_no"]];
            _txtSpecialization.text = [dictdata valueForKey:@"specialization_name"];
            _txtLicenseStates.text= [dictdata valueForKey:@"license_states_name"];
            _txtViewAboutMe.text = [dictdata valueForKey:@"about_me"];
            _txtViewAdress.text =[dictdata valueForKey:@"address"];
            //  [_txtLanguageKnown setEnabled:NO];
            [_txtLicenseStates setEnabled:NO];
            // [_txtHighestQualificaion setEnabled:NO];
            
            specializationList = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"specialization_id"]];
            selectedLicenceSates =[NSString stringWithFormat:@"%@",[dictdata valueForKey:@"license_states_id"]] ;
            
            selectedCountryId = [[dictdata valueForKey:@"country_id"] intValue];
            selectedStateId = [[dictdata valueForKey:@"state_id"] intValue];
            selectedCityId = [[dictdata valueForKey:@"city_id"] intValue];
            
            
           
            [
             self getAllStatesWith:selectedCountryId];
            [self getAllCitieWith:selectedStateId];
            
            [_txtEmail setEnabled:NO];
            [_txtLicenseStates setEnabled:NO];
            [_txtSpecialization setEnabled:NO];
            
            if([_txtCountry.text isEqualToString:@"United States"]){
                
                [_state setHidden:NO];
                [_dea setHidden:NO];
                [_txtLicenseStates setEnabled:YES];
                
            }
            else {
                _txtState.placeholder = @"State";
                
                [_state setHidden:YES];
                [_dea setHidden:YES];
                [_txtLicenseStates setEnabled:NO];
            }
            
        }
    }];
}

-(void)saveImage{
    NSData *imageData = UIImageJPEGRepresentation(_imgProfile.image, 0.2);
    // UDSet(@"propic", [NSKeyedArchiver archivedDataWithRootObject:_imgProfile.image]);
    NSArray *arrimage = [[NSArray alloc] initWithObjects:imageData, nil];
    NSArray *arrimageNames = [[NSArray alloc] initWithObjects:@"profile_pic", nil];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service editProfilePicture:nil andImageName:arrimage andImages:arrimageNames WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        //   NSLog(@"Response");
    }];
}

- (void)updateLabel {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy"];
    NSString *dateStr = [df stringFromDate:yearPicker.date];
    _txtQualificationyear.text = [NSString stringWithFormat:@"%@", dateStr];
}

- (void)takePhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)selectPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark -- API Calls
-(void)getAllStatesWith:(int)countryId {
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
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

-(void)editProfile{
    NSData *imageData = UIImageJPEGRepresentation(_imgProfile.image, 0.2);
    NSArray *arrimage = [[NSArray alloc] initWithObjects:imageData, nil];
    NSArray *arrimageNames = [[NSArray alloc] initWithObjects:@"profile_pic", nil];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *orignalDate   =  [dateFormatter dateFromString:_txtDOB.text];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDob = [dateFormatter stringFromDate:orignalDate];
    
    NSMutableDictionary *parameter =[[NSMutableDictionary alloc] init];
    int gender = [IODUtils getGenderId:_txtgender.text];
    if(_txtgender.text.length >0){
        [parameter setObject:[NSNumber numberWithInt:gender] forKey:@"gender"];
    }
    else{
    }
    [parameter setObject:_txtFullName.text forKey:@"name"];
    // [parameter setObject:[NSNumber numberWithInt:gender] forKey:@"gender"];
    [parameter setObject:_txtEmail.text forKey:@"email"];
    [parameter setObject:_txtMobile.text forKey:@"mobile"];
    [parameter setObject:_txtPinCode.text forKey:@"pincode"];
    [parameter setObject:_txtViewAdress.text forKey:@"address"];
    [parameter setObject:strDob forKey:@"dob"];
    [parameter setObject:_txtQualificationyear.text forKey:@"qualification_year"];
    [parameter setObject:_txtDea.text forKey:@"dea_no"];
    [parameter setObject:_txtExperince.text forKey:@"experience"];
    [parameter setObject:_txtUnitversity.text forKey:@"university"];
    [parameter setObject:specializationList forKey:@"specialization_id"];
    [parameter setObject:_txtHighestQualificaion.text forKey:@"qualification"];
    [parameter setObject:_txtregistration.text forKey:@"registration_no_npi_no"];
    [parameter setObject:_txtLanguageKnown.text forKey:@"language"];
    [parameter setObject:_txtAdditionalQualification.text forKey:@"additional_qualification"];
    [parameter setObject:[NSNumber numberWithInt:selectedCountryId] forKey:@"country"];
    [parameter setObject:[NSNumber numberWithInt:selectedStateId] forKey:@"state"];
    
    if(_txtCity.text.length > 0){
        [parameter setObject:[NSNumber numberWithInt:selectedCityId] forKey:@"city"];
    }
    
    [parameter setObject:strDob forKey:@"dob"];
    [parameter setObject:_txtViewAboutMe.text forKey:@"about_me"];
    
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service editDoctorProfile:parameter andImageName:arrimageNames andImages:arrimage WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        
        //NSLog(@"response code");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        // if([[responseCode valueForKey:@"status"] isEqualToString:@"success"])
        
        {
            [self.navigationController popViewControllerAnimated:YES];
            //
            [IODUtils showFCAlertMessage:[responseCode valueForKey:@"message"] withTitle:@"" withViewController:self with:@"error"];
            
            UDSet(@"propicdoc", [NSKeyedArchiver archivedDataWithRootObject:_imgProfile.image]);
            
            NSString *strname = _txtFullName.text;
            NSString *strCountry = _txtCountry.text;
            NSString *strState = [NSString stringWithFormat:@"%@,", _txtState.text ];
            NSString *strCity =_txtCity.text;
            
            if([strCity isEqualToString:@""]){
                strCity = @"";
            }
            else{
                strCity = [NSString stringWithFormat:@"%@, ", strCity];
            }
            
            if([strState isEqualToString:@""]){
                strState = @"";
            }
            else{
                strState = [NSString stringWithFormat:@"%@, ", strState];
            }
            
            NSString *strAddress = [NSString stringWithFormat:@"%@%@%@",strCity,strState,strCountry];
            strAddress = [strAddress stringByReplacingOccurrencesOfString:@",," withString:@","];
            UDSet(@"userinfodoc", ([NSKeyedArchiver archivedDataWithRootObject:@{@"name":strname,@"address":strAddress}]));
            
        }
    }];
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

#pragma mark -  Year Picker
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

#pragma mark - UITextfield Delegate Methods

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
            [self.view.window addSubview:self.pickerView];
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
                [self.view.window addSubview:self.pickerView];;
                return NO;
            }
            else {
                //  [textField setEnabled:NO];
                //[IODUtils showMessage:@"Plese select Country first" withTitle:@""];
               // return NO;

            }
        }
        else{
            
            [IODUtils showFCAlertMessage:@"Please select Country first" withTitle:@"" withViewController:self with:@"error"];


            return NO;

        }
        
        return NO;
    }
    else if (textField == self.txtLicenseStates) {
        if(_txtCountry.text.length) {
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
                //  [textField setEnabled:NO];
            }
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
            [self.view.window addSubview:self.multiSelect];;
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
            [self.view.window addSubview:self.pickerView];;
        }
        return NO;
    }
    else if (textField == self.txtCity) {
        [textField resignFirstResponder];
        if(self.txtState.text.length > 0){
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
            return NO;
        }
        else{
          
            [IODUtils showFCAlertMessage:@"Please select State first" withTitle:@"" withViewController:self with:@"error"];

            
        }
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

#pragma mark - IBAction Methods

-(IBAction)changeImage:(id)sender {
    [self editImgClicked:sender];
}

-(IBAction)editImgClicked:(id)sender{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Select Gallery",
                                nil];
        popup.tag = 1;
        [popup showInView:self.view];
    }
    else {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Select Gallery",
                                @"Select Camera",
                                nil];
        popup.tag = 1;
        [popup showInView:self.view];
    }
}

- (IBAction)btnSubmitPressed:(id)sender{
    
    if (![IODUtils getError:self.txtFullName minVlue:@"4" minVlue:@"50" onlyNumeric:nil
                  onlyChars:YES canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]) {
    }
    if (![IODUtils getError:self.txtEmail minVlue:@"4" minVlue:@"50" onlyNumeric:nil
                  onlyChars:NO canBeEmpty:NO checkEmail:YES minAge:nil maxAge:nil canBeSameDate:nil ]) {
    }
    else if(![IODUtils getError:self.txtgender minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtDOB minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:@"18" maxAge:@"110" canBeSameDate:NO ]){
    }
    
    else if(![IODUtils getError:self.txtMobile minVlue:@"10" minVlue:@"10" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    else if (![IODUtils getError:self.txtCountry minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]) {
    }
    
    else if(![IODUtils getError:self.txtPinCode minVlue:@"5" minVlue:@"6" onlyNumeric:nil onlyChars:nil canBeEmpty:YES checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    else if(![IODUtils getError:self.txtExperince minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    else if(![IODUtils getError:self.txtLanguageKnown minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtHighestQualificaion minVlue:@"1" minVlue:@"15" onlyNumeric:NO onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    else if(![IODUtils getError:self.txtregistration minVlue:@"15" minVlue:nil onlyNumeric:NO onlyChars:NO canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    else if(![IODUtils getError:self.txtUnitversity minVlue:@"15" minVlue:nil onlyNumeric:NO onlyChars:NO canBeEmpty:YES checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    
    else if(self.txtViewAboutMe.text.length ==0){
        UILabel *lab=[IODUtils getErrorLabel:(UITextField *)self.txtViewAboutMe];
        lab.text=@"About Me cannot be blank";
        [IODUtils showFCAlertMessage:@"About Me cannot be blank" withTitle:@"" withViewController:self with:@"error"];
        
        
    }
    else if(self.txtViewAboutMe.text.length > 500){
        UILabel *lab=[IODUtils getErrorLabel:(UITextField *)self.txtViewAboutMe];
        lab.text= VALID_ABOUTME;
        
    }
    else if([_txtCountry.text isEqualToString:@"United States"]) {
        if(![IODUtils getError:self.txtDea minVlue:@"1" minVlue:@"15" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil
             ]){
        }else if(![IODUtils getError:self.txtLicenseStates minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
        }
        else if(![IODUtils getError:self.txtState minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
        }
        else {
            Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
            BOOL reachable = reach. isReachable;
            if (reachable) {
                
                if(_txtUnitversity.text.length > 0) {
                    if(![IODUtils getError:self.txtregistration minVlue:nil minVlue:nil onlyNumeric:NO onlyChars:NO canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
                    }
                    else{
                        [self editProfile];
                    }
                }
                else {
                    [self editProfile];
                }
            }
            else{
                //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
            }
        }
    }
    else{
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        if (reachable) {
            if(![IODUtils getError:self.txtDOB minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:@"18" maxAge:@"110" canBeSameDate:NO ]){
            }
            else if(_txtUnitversity.text.length > 0) {
                if(![IODUtils getError:self.txtregistration minVlue:nil minVlue:nil onlyNumeric:NO onlyChars:NO canBeEmpty:YES checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
                }
                else{
                    [self editProfile];
                }
            }
            else {
                [self editProfile];
            }
        }
        else{
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        }
    }
}

# pragma mark -  ActionSheet Deleagte.
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self selectPhoto];
                    break;
                case 1:
                    [self takePhoto];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}


#pragma mark - ImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    _imgProfile.image = chosenImage;
    _imgProfile.image = chosenImage;
    _imgProfile.contentMode = UIViewContentModeScaleAspectFill;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self saveImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - StringPickerView Delegate
- (void)stringPickerViewDidSelectDone:(StringPickerView *)view
{
    if( [self.pickerView.refernceView isKindOfClass:[UITextField class]] )
    {
        UITextField *textField = (UITextField*)view.refernceView;
        if(textField == _txtgender){
            textField.text = self.pickerView.value;
            selectedGenderId = self.pickerView.selectedId+1;
        }
        else if(textField == _txtState){
            textField.text = self.pickerView.value;
            _txtCity.text = @"";
            selectedStateId = [[[arrStateList objectAtIndex:self.pickerView.selectedId] valueForKey:@"state_id"] intValue];
            _txtCity.text = @"";
            
            [self  getAllCitieWith:selectedStateId];
        }
        else if(textField == _txtCity){
            if (arrcityList.count > 0 ) {
                textField.text = self.pickerView.value;
                selectedCityId =[[[arrcityList objectAtIndex:self.pickerView.selectedId ] valueForKey:@"city_id"] intValue];
            }
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
        if(textField == _txtCountry){
            _txtState.text = @"";
            _txtCity.text = @"";
            _txtDea.text = @"";
            textField.text = self.pickerView.value;
            int a = self.pickerView.selectedId;
            selectedCountryId = [[[arrCountryList objectAtIndex:a] valueForKey:@"country_id"] intValue];
            [self  getAllStatesWith:selectedCountryId];
            [[NSUserDefaults standardUserDefaults] setInteger:selectedCountryId forKey:@"countryid"];
            if([_txtCountry.text isEqualToString:@"United States"]){
                [_state setHidden:NO];
                [_dea setHidden:NO];
                [_txtLicenseStates setEnabled:YES];
            }
            else {
                _txtState.placeholder = @"State";
                [_state setHidden:YES];
                [_dea setHidden:YES];
                [_txtLicenseStates setEnabled:NO];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshView Methods If Internet Connection Lost

-(void)refreshView:(NSNotification*)notification{
    [self getUserPrfile];
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}

@end
