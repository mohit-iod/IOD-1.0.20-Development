//
//  LEaveViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/25/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "LEaveViewController.h"
#import "IODUtils.h"
#import "CommonServiceHandler.h"
#import "DoctorAppointmentServiceHandler.h"
#import "UIColor+HexString.h"
#import "UIImageView+WebCache.h"
#import "TabbarCategoryViewController.h"

@interface LEaveViewController (){
    UIDatePicker *datePicker;
    DoctorAppointmentServiceHandler *docService;
}
@property (nonatomic, strong) UIView *datePickerView;
@end

@implementation LEaveViewController

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    docService = [DoctorAppointmentServiceHandler sharedManager];

    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSString *currentDate;
    currentDate=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    currentDate = [IODUtils ChangeDateFormat:currentDate];
    _lblDate.text = currentDate;
    _txtvDiagnosis.text = docService.diagnosis;
    if([docService.status isEqualToString:@"Pending"])
    {
        [self.view.subviews setValue:@YES forKeyPath:@"hidden"];
        UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(30,self.view.center.y, 260, 30)];
        [self.view addSubview:lblMessage];
        lblMessage.text = LEAVE_ERROR;
        lblMessage.center = self.view.center;
        [_topBar setHidden:NO];
        lblMessage.textAlignment = NSTextAlignmentCenter;
        lblMessage.font = [UIFont boldSystemFontOfSize:16];
        lblMessage.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
    }
    NSDictionary *userDict = UDGet(@"SelectedUser");
    if([docService.callEnd isEqualToString:@"yes"])
    {
        _lblUserName.text = [NSString stringWithFormat:@"%@",docService.patient_name];
        _lblUserAge.text = @"";
        _lblUserGender.text = [NSString stringWithFormat:@"%@",docService.patient_gender];
        if([_lblUserGender.text isEqualToString:@"<null>"] || [_lblUserGender.text isEqualToString:@"2"]){
            _lblUserGender.text = @"";
        }
        _lblDocName.text = UDGet(@"uname");;
        _lblDocGender.text = docService.doctorSpecialization;
        _lblDoctSpecialise.text= @"";
        NSInteger sda = [IODUtils calculateAge:docService.dob];
        _lblUserAge.text = [NSString stringWithFormat:@"Age: %ld",(long)sda];
    }
    else {
        _lblUserName.text = [NSString stringWithFormat:@"%@",[userDict valueForKey:@"patient_name"]];
        _lblUserAge.text = [NSString stringWithFormat:@"Age: %li",(long)[IODUtils calculateAge:[userDict valueForKey:@"dob"]]];
        _lblUserGender.text = [NSString stringWithFormat:@"%@",[userDict valueForKey:@"gender"]];
        if([_lblUserGender.text isEqualToString:@"<null>"] || [_lblUserGender.text isEqualToString:@"2"]){
            _lblUserGender.text = @"";
        }
        _lblDocName.text = docService.doctorName;
        _lblDocGender.text = docService.doctorGender;
        _lblDoctSpecialise.text = docService.doctorSpecialization;
        
    }
    
    NSString *color = [IODUtils setStatusColor :docService.status];
    [_btnStatus setBackgroundColor:[UIColor colorWithHexRGB:color]];
    [_btnStatus setTitle:docService.status forState:UIControlStateNormal];
    
    
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[userDict valueForKey:@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"P-calling-icon.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    CGFloat radius = _imgView.bounds.size.width / 2;
    [_imgView.layer setCornerRadius:radius];
    _imgView.clipsToBounds = YES;
}


- (void)viewWillAppear:(BOOL)animated{
    
    docService = [DoctorAppointmentServiceHandler sharedManager];
    
    _txtvDiagnosis.text = docService.diagnosis;
    
    if (docService.isFromVideo == 1) {
        self.viewHeight.constant = 0;
        self.buttonHeight.constant= 0;
        [self.view updateConstraints];
        
        [self.view.subviews setValue:@YES forKeyPath:@"hidden"];
        UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(30,self.view.center.y, 260, 30)];
        [self.view addSubview:lblMessage];
        lblMessage.text = LEAVE_ERROR;
        lblMessage.center = self.view.center;
        [_topBar setHidden:NO];
        lblMessage.textAlignment = NSTextAlignmentCenter;
        lblMessage.font = [UIFont boldSystemFontOfSize:16];
        lblMessage.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
        
        UIView *view =[self.view viewWithTag:33];
        
        NSMutableArray *arr=[view subviews].mutableCopy ;
        [arr addObject:view];
        for (UIView *v in arr) {
            for (NSLayoutConstraint *cons in v.constraints) {
                if (cons.firstAttribute == NSLayoutAttributeHeight) {
                    cons.active=YES;
                    cons.constant=0;
                }
            }
        }
    }
    else{
        if (![docService.status isEqualToString:@"Call interrupted"] && [docService.callEnd isEqualToString:@"no"] ) {
            if( ![docService.status isEqualToString:@"Successful"] && [docService.isFilled isEqualToString:@"0"]){
                self.viewHeight.constant = 0;
                self.buttonHeight.constant= 0;
            }
        }
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    
    NSDate *date =[NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
    
    
    if (textField == self.txtReason1Date){
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
        CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
  
        
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
       // [datePicker setMaximumDate:newDate];
        [datePicker setMinimumDate:[NSDate date]];
        [datePicker setMaximumDate:newDate];
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.datePickerMode=UIDatePickerModeDate;
        [_datePickerView addSubview:datePicker];
        [textField setInputView:_datePickerView];
    }
    else if(textField == _txtReason2Date){
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
        CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
       
        _datePickerView = [[UIView alloc] initWithFrame:pickerFrame];
        //time interval in seconds
        CGSize buttonSize = CGSizeMake(SCREEN_WIDTH/2, 44);
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame = CGRectMake(0, 0, buttonSize.width, 50);
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(onDoneButton2)
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
        [datePicker setMinimumDate:[NSDate date]];
        [datePicker setMaximumDate:newDate];
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.datePickerMode=UIDatePickerModeDate;
        [_datePickerView addSubview:datePicker];
        [textField setInputView:_datePickerView];

    }
    else if  (textField == self.txtReason3Date){
            [textField resignFirstResponder];
            [self.view endEditing:YES];
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
        
            _datePickerView = [[UIView alloc] initWithFrame:pickerFrame];
            //time interval in seconds
            CGSize buttonSize = CGSizeMake(SCREEN_WIDTH/2, 44);
            UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
            doneButton.frame = CGRectMake(0, 0, buttonSize.width, 50);
            [doneButton setTitle:@"Done" forState:UIControlStateNormal];
            [doneButton addTarget:self action:@selector(onDoneButton3)
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
            [datePicker setMinimumDate:[NSDate date]];
            [datePicker setMaximumDate:newDate];
        
            datePicker.backgroundColor = [UIColor whiteColor];
            datePicker.datePickerMode=UIDatePickerModeDate;
            [_datePickerView addSubview:datePicker];
            [textField setInputView:_datePickerView];
        }
        return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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
    self.txtReason1Date.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.txtReason1Date resignFirstResponder];
}

-(void)onDoneButton2
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY"];
    self.txtReason2Date.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.txtReason2Date resignFirstResponder];
}
-(void)onDoneButton3
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY"];
    self.txtReason3Date.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.txtReason3Date resignFirstResponder];
}
-(void)onCancelButton {
    [self.txtReason1Date resignFirstResponder];
    [self.txtReason2Date resignFirstResponder];
    [self.txtReason3Date resignFirstResponder];
    [_datePickerView removeFromSuperview];
}


- (NSString *) ChangeDateFormat : (NSString *) toDate
{
    NSString *toDateCheck;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *date = [dateFormatter dateFromString: toDate]; // here you can fetch date from string with define format
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];// here set format which you want...
    
    toDateCheck = [dateFormatter stringFromDate:date]; //here convert date in NSString
    return toDateCheck;
}


- (IBAction)btnSubmitPressed:(id)sender {
    if((_txtReason1Date.text.length == 0) && (_txtReason2Date.text.length == 0) && (_txtReason3Date.text.length == 0)) {
        [IODUtils showFCAlertMessage:@"Please select at least one" withTitle:@"" withViewController:self with:@"error"];
    }
    else {
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        if (reachable) {
            int can_resume_work = 0;
            int can_give_exam = 0;
            int was_able_for_exam = 0;
            
            NSString *strDate1,*strDate2,*strdate3;
            if(_txtReason1Date.text.length > 0) {
                can_resume_work = 1;
                 strDate1 =[NSString stringWithFormat:@"%@",[self ChangeDateFormat:_txtReason1Date.text]];
            }
            else {
                strDate1= @"";
            }
            if(_txtReason2Date.text.length > 0) {
                was_able_for_exam = 1;
                 strDate2 =[NSString stringWithFormat:@"%@",[self ChangeDateFormat:_txtReason2Date.text]];
            }
            else {
                strDate2 =@"";
            }
            if(_txtReason3Date.text.length > 0) {
                can_give_exam = 1;

                strdate3 =[NSString stringWithFormat:@"%@",[self ChangeDateFormat:_txtReason3Date.text]];;
            }
            else {
                strdate3 = @"";
            }
            NSString *visitId = docService.visit_id;
            CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
            NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
            [parameter setObject:[NSNumber numberWithInt:can_resume_work] forKey:@"can_resume_work"];
            [parameter setObject:strDate1 forKey:@"resume_date"];
            [parameter setObject:[NSNumber numberWithInt:was_able_for_exam] forKey:@"was_able_for_exam"];
            [parameter setObject:strDate2 forKey:@"past_exam_date"];
            [parameter setObject:[NSNumber numberWithInt:can_give_exam] forKey:@"can_give_exam"];
            [parameter setObject:strdate3 forKey:@"can_give_exam_date"];
            [parameter setObject: _txtvDiagnosis.text forKey:@"diagnosis"];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service postLeave:parameter WithVisitId:visitId WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
                if(responseCode){
                
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Thank You"message:@"" preferredStyle:UIAlertControllerStyleAlert];
                    //We add buttons to the alert controller by creating UIAlertActions:
                    docService.diagnosis= @"";
                    UIAlertAction *yesPressed = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        //[tabBarController setSelectedViewController:[viewControllersCopy objectAtIndex:2]];
                    }];
                    [alertController addAction:yesPressed];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }];
        }
        else{
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        }
    }
}


- (void)showMessage:(NSString*)message withTitle:(NSString *)title
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //do something when click button
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //do something when click button
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}



-(void)ViewClickedName:(NSString *)viewTitle setHidden:(BOOL)hideViewBelow{
    if ([viewTitle caseInsensitiveCompare:@"May resume work/school/college" ]== NSOrderedSame) {
        //   [medicalViewMemberInfo setHidden:YES];
        [(UIView *)[self.view viewWithTag:1] setHidden:hideViewBelow];
    }
    else if([viewTitle caseInsensitiveCompare:@"is too ill to attend PE" ]== NSOrderedSame){
        [(UIView *)[self.view viewWithTag:2] setHidden:hideViewBelow];
    }
    else if([viewTitle caseInsensitiveCompare:@"was too ill to write exam"]== NSOrderedSame){
        [(UIView *)[self.view viewWithTag:3] setHidden:hideViewBelow];
    }
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        //reset clicked
    }
}

@end
