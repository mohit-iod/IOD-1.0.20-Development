//
//  addMemberRegisterVC.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/9/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "addMemberRegisterVC.h"
#import "CommonServiceHandler.h"
#import "AppSettings.h"
#import "StringPickerView.h"
#import "UIColor+HexString.h"
@interface addMemberRegisterVC ()< UITextFieldDelegate, StringPickerViewDelegate>

@end

@implementation addMemberRegisterVC
{
    UIDatePicker *datePicker;
    int selectedGenderId;
}
-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
   // [self addNewMember];
    
    if([self.isEdit isEqualToString:@"yes"]){
        self.txtfullName.text = _fullname;
       
        if([_mobile isKindOfClass: [NSNull class]]){
            self.txtPhone.text = @"";
        }
        else if(![_mobile isKindOfClass: [NSNull class]]){
            self.txtPhone.text = _mobile;
        }
        else if([_mobile isEqualToString:@"0"]){
            self.txtPhone.text = @"";
        }
     
        
        if(![_email isKindOfClass: [NSNull class]]){
            self.txtEmail.text = _email;
        }
        if([_email isKindOfClass: [NSNull class]]){
            self.txtEmail.text = @"";
        }
        else  if([_email isEqualToString:@"<null>"]){
            self.txtEmail.text =@"";
        }
        else if ([_email isEqualToString:@"0"]){
            self.txtEmail.text = @"";
        }
        
        
        self.txtGender.text = _gender;
        self.txtDOB.text = _dob;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigationz
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
            [self.view.window addSubview:self.pickerView];
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
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField==_txtPhone)
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
    }
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}

- (void)stringPickerViewDidSelectCancel:(StringPickerView *)view
{
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}

-(IBAction)btnSubmitPressed:(id)sender {
    if (![IODUtils getError:self.txtfullName minVlue:@"4" minVlue:@"50" onlyNumeric:nil onlyChars:YES canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]) {
    }
    else if(![IODUtils getError:self.txtEmail minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:YES minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtDOB minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtGender minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtPhone minVlue:@"10" minVlue:@"10" onlyNumeric:nil onlyChars:nil canBeEmpty:YES checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    else{
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        if (reachable) {
            if([_isEdit isEqualToString:@"yes"]){
                [self editMember];
            }
            else{
                [self addNewMember];
            }
        }
        else{
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        }
    }
}

-(void)addNewMember{
    int gender = [IODUtils getGenderId:_txtGender.text];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDob =[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kaddPatientMember];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:_txtfullName.text forKey:@"name"];
    [parameter setObject:[NSNumber numberWithInt:gender] forKey:@"gender"];
    [parameter setObject:strDob forKey:@"dob"];
    [parameter setObject:_txtEmail.text forKey:@"email"];
    [parameter setObject:_txtPhone.text forKey:@"mobile"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service postPatientNewMember:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD HUDForView:self.view];
        if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)editMember{
    
    int gender = [IODUtils getGenderId:_txtGender.text];
  
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *orignalDate   =  [dateFormatter dateFromString:_txtDOB.text];
    orignalDate = [IODUtils toLocalTime:orignalDate];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strDob = [dateFormatter stringFromDate:orignalDate];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kaddPatientMember];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSString *uuid =  UDGet(@"uid");
       NSString *uid = [NSString stringWithFormat:@"%@",uuid ];
    
    [parameter setObject:_txtfullName.text forKey:@"name"];
    [parameter setObject:[NSNumber numberWithInt:gender] forKey:@"gender"];
    [parameter setObject:strDob forKey:@"dob"];
    [parameter setObject:_txtEmail.text forKey:@"email"];
    [parameter setObject:_txtPhone.text forKey:@"mobile"];
    [parameter setObject:self.mid forKey:@"id"];
    [parameter setObject:uid forKey:@"patient_id"];
      [MBProgressHUD HUDForView:self.view];
    [service editPatientNewMember:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:nil];
        //NSLog(@"response %@",responseCode);
        if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
