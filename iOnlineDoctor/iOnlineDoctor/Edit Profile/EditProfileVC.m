//
//  profileVC.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 8/31/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "EditProfileVC.h"
#import "IODUtils.h"
#import "CommonServiceHandler.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HexString.h"
#import "StringPickerView.h"

@interface EditProfileVC ()< UITextFieldDelegate,StringPickerViewDelegate,HeightPickeerViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

{
    UIDatePicker *datePicker;
    int selectedGenderId;
    int countryId;
    int stateId;
    int cityId;
    
    NSArray *arrCountryList;
    NSArray *arrStateList;
    NSArray *arrcityList;
}
@end

static int selectedCountryId;
static int selectedStateId;
static int selectedCityId;
static int selectedGenderId;

@implementation EditProfileVC


-(void)viewDidLayoutSubviews{
    [_imgProfile.layer setCornerRadius:_imgProfile.bounds.size.width / 2];
    _imgProfile.clipsToBounds = YES;
    [_imgProfile.layer setBorderWidth:2.0];
    [_imgProfile.layer setBorderColor:[UIColor whiteColor].CGColor];
}
-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [_imgProfile.layer setCornerRadius:_imgProfile.bounds.size.width / 2];
        _imgProfile.clipsToBounds = YES;
        [_imgProfile.layer setBorderWidth:2.0];
        [_imgProfile.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.view setNeedsLayout];
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.title =@"My Profile";
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    self.txtGender.inputView = self.pickerView;
    self.txtWeight.inputView = self.pickerView;
    self.txtBloodGroup.inputView = self.pickerView;
    self.txtHeight.inputView = self.heightPickerView;
    
    UITapGestureRecognizer *tapG=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editImgClicked)];
    [_imgProfile setUserInteractionEnabled:YES];
    [_imgProfile addGestureRecognizer:tapG];
    CGFloat radius = _imgProfile.bounds.size.width / 2;
    [_imgProfile.layer setCornerRadius:radius];
    _imgProfile.clipsToBounds = YES;
    [_imgProfile.layer setBorderWidth:3.0];
    [_imgProfile.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_imgProfile layoutIfNeeded];
    
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
}

-(void)setPlaceHoldersofTextfield{
    
    //[IODUtils setPlaceHolderLabelforTextfield:textField];
}


-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.title =@"My Profile";
}



-(void)editImgClicked{
    
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

# pragma mark Delegates for Action sheet.
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void) getPatientProfile{
}



- (void)takePhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO
    ;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)selectPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    _imgProfile.image = chosenImage;
    _imgProfile.contentMode = UIViewContentModeScaleAspectFill;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self saveImage];
    
}


-(void)saveImage{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    
    NSData *imageData = UIImageJPEGRepresentation(_imgProfile.image, 0.2);
    // UDSet(@"propic", [NSKeyedArchiver archivedDataWithRootObject:_imgProfile.image]);
    NSArray *arrimage = [[NSArray alloc] initWithObjects:imageData, nil];
    NSArray *arrimageNames = [[NSArray alloc] initWithObjects:@"profile_pic", nil];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service editProfilePicture:parameter andImageName:arrimage andImages:arrimageNames WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
       // NSLog(@"Response");
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark Text Field delegate
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
    else  if (textField == self.txtWeight) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
            NSDictionary *dictgender = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"weight" ofType:@"json"]];
            NSArray *gender= [dictgender valueForKey:@"weight"];
            self.pickerView.data = gender;
            self.pickerView.delegate = self;
            self.pickerView.preSelectedValue = textField.text;
            self.pickerView.refernceView = textField;
            [self.view.window addSubview:self.pickerView];;
            return NO;
        }
        return NO;
    }
    else if (textField == self.txtHeight) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.heightPickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.heightPickerView = [[HeightPickeerView alloc] initWithFrame:pickerFrame];
            NSDictionary *dictheight = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"height" ofType:@"json"]];
            NSArray *arrHeight = [dictheight valueForKey:@"height"];
            NSArray *feet= [[arrHeight objectAtIndex:0]valueForKey:@"feet"];
            NSArray *inches= [[arrHeight objectAtIndex:1]valueForKey:@"inches"];
            
            self.heightPickerView.component1 = feet;
            self.heightPickerView.component2 = inches;
            
            self.heightPickerView.delegate = self;
            self.heightPickerView.preSelectedComponent1Value = textField.text;
            self.heightPickerView.preSelectedComponent2Value = textField.text;
            self.heightPickerView.refernceView = textField;
            [self.view addSubview:self.heightPickerView];
            return NO;
        }
        return NO;
    }
    else if (textField == self.txtBloodGroup) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
            NSDictionary *dictBloodGroup = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"bloogGroup" ofType:@"json"]];
            NSArray *bloodGroup= [dictBloodGroup valueForKey:@"bloodGroup"];
            self.pickerView.data = bloodGroup;
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
    else if (textField == self.txtCountry) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 350);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 350, pickerSize.width, pickerSize.height);
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
    else if (textField == self.txtstate) {
        if(_txtCountry.text.length > 0) {
            [textField setEnabled:YES];
            [textField resignFirstResponder];
            [self.view endEditing:YES];
            if(!self.pickerView) {
                CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 350);
                CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 350, pickerSize.width, pickerSize.height);
                self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
                self.pickerView.data = [arrStateList valueForKey:@"state_name"];
                self.pickerView.delegate = self;
                self.pickerView.preSelectedValue = textField.text;
                self.pickerView.refernceView = textField;
                [self.view.window addSubview:self.pickerView];;
                return NO;
            }
        }
        else  {
            
            
            [IODUtils showFCAlertMessage:COUNTRY_SELECTION withTitle:@"" withViewController:self with:@"error"];

            
        }
        return NO;
    }
    else if (textField == self.txtCity) {
        [textField resignFirstResponder];
        if(self.txtstate.text.length == 0){
            
            [IODUtils showFCAlertMessage:STATE_SELECTION withTitle:@"" withViewController:self with:@"error"];
        }
        else{
            [self.view endEditing:YES];
            if(!self.pickerView) {
                CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 350);
                CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 350, pickerSize.width, pickerSize.height);
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

#pragma mark - StringPickerViewDelegate
- (void)stringPickerViewDidSelectDone:(StringPickerView *)view
{
    if( [self.pickerView.refernceView isKindOfClass:[UITextField class]] )
    {
        UITextField *textField = (UITextField*)view.refernceView;
        if(textField == _txtGender){
            textField.text = self.pickerView.value;
            selectedGenderId = self.pickerView.selectedId+1;
        }
        else if(textField == _txtWeight){
            textField.text = self.pickerView.value;
        }
        else if(textField == _txtBloodGroup){
            textField.text = self.pickerView.value;
        }
        if(textField == _txtCountry){
            _txtstate.text = @"";
            _txtCity.text = @"";
            
            arrStateList = [[NSMutableArray alloc] init];
            arrcityList = [[NSMutableArray alloc ]init];
            
            textField.text = self.pickerView.value;
            int a = self.pickerView.selectedId;
            selectedCountryId = [[[arrCountryList objectAtIndex:a] valueForKey:@"country_id"] intValue];
            [self  getAllStatesWith:selectedCountryId];
            [[NSUserDefaults standardUserDefaults] setInteger:selectedCountryId forKey:@"countryid"];
            if([_txtCountry.text isEqualToString:@"United States"]){
                _txtstate.placeholder = @"State*";
            }
            else {
                _txtstate.placeholder = @"State";
            }
        }
        else if(textField == _txtstate){
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
        
    }
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}

- (void)stringPickerViewDidSelectCancel:(StringPickerView *)view
{
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}

#pragma mark -- Height picker delegate

- (void)heightPickerViewDidSelectDone:(HeightPickeerView*)view
{
    if( [self.heightPickerView.refernceView isKindOfClass:[UITextField class]] )
    {
        UITextField *textField = (UITextField*)view.refernceView;
        textField.text = [NSString stringWithFormat:@"%@.%@ feet", self.heightPickerView.component1Value,self.heightPickerView.component2Value];
    }
    [self.heightPickerView removeFromSuperview];
    self.heightPickerView = nil;
}
- (void)heightPickerViewDidSelectCancel:(HeightPickeerView*)view{
    [self.heightPickerView removeFromSuperview];
    self.heightPickerView = nil;
}

- (IBAction)btnSubmitPressed:(id)sender{
    
    if (![IODUtils getError:self.txtFullName minVlue:@"4" minVlue:@"50" onlyNumeric:nil onlyChars:YES canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]) {
    }
    
    else if(![IODUtils getError:self.txtCountry minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtDOB minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:@"18" maxAge:@"110" canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtPincode minVlue:@"5" minVlue:@"6" onlyNumeric:nil onlyChars:nil canBeEmpty:YES checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtMobile minVlue:@"10" minVlue:@"10" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    
    else if([self.txtCountry.text isEqualToString:@"United States"]){
        if(![IODUtils getError:_txtstate minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
        }
        
        else  if(![IODUtils getError:_txtPincode minVlue:@"5" minVlue:@"6" onlyNumeric:nil onlyChars:nil canBeEmpty:YES checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
        }
        
        else if(![IODUtils getError:_txtPincode minVlue:@"5" minVlue:@"6" onlyNumeric:nil onlyChars:nil canBeEmpty:YES checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
        }
        else{
            Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
            BOOL reachable = reach. isReachable;
            if (reachable) {
                [self editProfile];
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
            [self editProfile];
        }
        else{
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        }
    }
}

-(IBAction)changeImage:(id)sender {
    [self editImgClicked];
}
-(void)editProfile{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *orignalDate   =  [dateFormatter dateFromString:_txtDOB.text];
    orignalDate = [IODUtils toLocalTime:orignalDate];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strDob = [dateFormatter stringFromDate:orignalDate];
    NSMutableDictionary *parameter =[[NSMutableDictionary alloc] init];
    int gender = [IODUtils getGenderId:_txtGender.text];
    
    [parameter setObject:_txtFullName.text forKey:@"name"];
    [parameter setObject:_txtemail.text forKey:@"email"];
    if(_txtGender.text.length >0){
        [parameter setObject:[NSNumber numberWithInt:gender] forKey:@"gender"];
    }
    else{
    }
    [parameter setObject:_txtBloodGroup.text forKey:@"blood_group"];
    [parameter setObject:_txtWeight.text forKey:@"weight"];
    [parameter setObject:_txtHeight.text forKey:@"height"];
    [parameter setObject:strDob forKey:@"dob"];
    [parameter setObject:[NSNumber numberWithInt:selectedCountryId] forKey:@"country"];
    
    if(_txtstate.text.length > 0){
        [parameter setObject:[NSNumber numberWithInt:selectedStateId] forKey:@"state"];
    }
    
    if(_txtCity.text.length > 0){
        [parameter setObject:[NSNumber numberWithInt:selectedCityId] forKey:@"city"];
    }
    [parameter setObject:_txtPincode.text forKey:@"pincode"];
    [parameter setObject:_txtMobile.text forKey:@"mobile"];
    [parameter setObject:_txtAddress.text forKey:@"address"];
    
    NSData *imageData = UIImageJPEGRepresentation(_imgProfile.image, 0.2);
    // UDSet(@"propic", [NSKeyedArchiver archivedDataWithRootObject:_imgProfile.image]);
    NSArray *arrimage = [[NSArray alloc] initWithObjects:imageData, nil];
    NSArray *arrimageNames = [[NSArray alloc] initWithObjects:@"profile_pic", nil];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service editProfile:parameter andImageName:arrimageNames andImages:arrimage WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        // NSLog(@"response code");
        self.lblUserName.text = _txtFullName.text;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        // if([[responseCode valueForKey:@"status"] isEqualToString:@"success"])
        {
            UDSet(@"propic", [NSKeyedArchiver archivedDataWithRootObject:_imgProfile.image]);
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            [IODUtils showFCAlertMessage:[responseCode valueForKey:@"message"] withTitle:@"" withViewController:self with:@"error"];
            
            NSString *strname = _txtFullName.text;
            NSString *strCountry = _txtCountry.text;
            NSString *strState = _txtstate.text;
            NSString *strCity =_txtCity.text;
            UDSet(@"country", strCountry);

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
            
            if([strCountry isEqualToString:@""]){
                strCountry = @"";
            }
            
            NSString *strAddress = [NSString stringWithFormat:@"%@%@%@",strCity,strState,strCountry];
            
            NSString *firstLetter = [strAddress substringToIndex:1];
            
            /* if([firstLetter isEqualToString:@","]){
             strAddress = [strAddress substringFromIndex:1];
             }
             if([firstLetter isEqualToString:@","]){
             strAddress = [strAddress substringFromIndex:1];
             }
             */
            UDSet(@"userinfo", ([NSKeyedArchiver archivedDataWithRootObject:@{@"name":strname,@"address":strAddress}]));
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }];
}

- (void) getUserPrfile{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service getUserProfile:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]){
            
            NSDictionary *dictdata = [responseCode valueForKey:@"data"];
            NSString *strname = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"name"]];
            NSString *strHeight = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"height"]];
            NSString *strWeight = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"weightt"]];
            NSString *strGender = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"gender"]];
            NSString *strDob = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"dob"]];
            
            NSString *strAddress = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"address"]];
            NSString *strCountry = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"country"]];
            NSString *strState = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"state"]];
            NSString *strCity = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"city"]];
            NSString *strPincode = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"pincode"]];
            NSString *strMobile  = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"mobile"]];
            
            NSString *stremail  = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"email"]];
            if(![strCountry isEqualToString:@"United States"]){
                _txtstate.placeholder = @"State";
            }
            
            countryId = [[dictdata valueForKey:@"country_id"] intValue];
            stateId = [[dictdata valueForKey:@"state_id"] intValue];
            cityId = [[dictdata valueForKey:@"city_id"] intValue];
            
            [self getAllStatesWith:countryId];
            [self getAllCitieWith:stateId];
            
            strDob = [IODUtils formateStringToDateForUI:strDob];
            NSString *strBloodGroup = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"blood_group"]];
            NSString *profilePic = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"profile_pic"]];
            if([strBloodGroup isEqualToString:@"<null>"] || [strBloodGroup isEqual:[NSNull null]])
                _txtBloodGroup.text = nil;
            else
                _txtBloodGroup.text = strBloodGroup;
            if([strHeight isEqualToString:@"<null>"] || [strHeight isEqual:[NSNull null]] || [strHeight isEqualToString:@"(null)"])
                _txtHeight.text = nil;
            else
                _txtHeight.text = strHeight;
            
            if([strWeight isEqualToString:@"<null>"] || [strWeight isEqual:[NSNull null]] || [strWeight isEqualToString:@"(null)"] || [strWeight isEqualToString:@"0"])
                _txtWeight.text = nil;
            else
                _txtWeight.text = strWeight;
            _txtDOB.text = strDob;
            _txtGender.text = strGender;
            _txtFullName.text = strname;
            [_imgProfile sd_setImageWithURL:[NSURL URLWithString:profilePic] placeholderImage:[UIImage imageNamed:@"D-calling-icon.png"]];
            _lblUserName.text =strname;
            
            _txtAddress.text = strAddress;
            _txtCountry.text = strCountry;
            _txtstate.text = strState;
            _txtCity.text = strCity;
            _txtPincode.text = strPincode;
            _txtMobile.text = strMobile;
            _txtemail.text = stremail;
            
        }
    }];
}


- (void)changeImage{
    
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
        _txtstate.text = @"";
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
        _txtstate.text = @"";
    }
}
-(void)refreshView:(NSNotification*)notification{
    [self getUserPrfile];
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}
@end
