//
//  medicalInfoMainVC.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/8/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "medicalInfoMainVC.h"
#import "CommonServiceHandler.h"
#import "PatientAppointService.h"
#import "IODUtils.h"
#import "StringPickerView.h"
#import "UIColor+HexString.h"
#import "UploadDocCell.h"
#import "AppDelegate.h"


@interface medicalInfoMainVC () < UITextFieldDelegate, StringPickerViewDelegate>{
    int selectedOption;
    UIDatePicker *datePicker;
    NSString *sortKey;
    NSString *sortGender;
    NSString *experience;
}

@end

@implementation medicalInfoMainVC
{
    medicalnfoCell *medicalView, *medicalViewMemberInfo,*existingMember;
    NSArray *arrReferrralDoctor,*arrExistingMembers;
    PatientAppointService *patientService;
}


-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   " style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    self.navigationItem.backBarButtonItem = nil;
    
    selectedOption = 0;
    patientService = [PatientAppointService sharedManager];
    [self setMedicalInfoData];
    [self getallReferralDoctor];
    [self getAllExistingMembers];
    //NSLog(@"%@",self.parentViewController.parentViewController.parentViewController.parentViewController);
    [_tblReferalDoc reloadData];
    self.title = @"Medical Info";
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    [self.membersCollectionView registerNib:[UINib nibWithNibName:@"UploadDocCell" bundle:nil] forCellWithReuseIdentifier:@"photoUploadCell"];
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

-(void) viewWillDisappear:(BOOL)animated
{
}

- (void) setMedicalInfoData {
    medicalView=[[NSBundle mainBundle] loadNibNamed:@"medicalInfoCell" owner:self options:nil][0];
  // medicalViewMemberInfo=[[NSBundle mainBundle] loadNibNamed:@"medicalInfoCell" owner:self options:nil][1];
    medicalView.delegate=self;
    medicalView.frame=CGRectMake(0, 0, [(UIView *)[self.view viewWithTag:4]frame].size.width,  [(UIView *)[self.view viewWithTag:4]frame].size.height);
    
    [self.view bringSubviewToFront:medicalView];
   
    medicalViewMemberInfo.frame=CGRectMake(0, 0, [(UIView *)[self.view viewWithTag:5]frame].size.width,  [(UIView *)[self.view viewWithTag:5]frame].size.height);
    
    [(UIView *)[self.view viewWithTag:4] addSubview:medicalView];
    [(UIView *)[self.view viewWithTag:5] addSubview:medicalViewMemberInfo];
    
      existingMember.frame=CGRectMake(0, 0, [(UIView *)[self.view viewWithTag:16]frame].size.width,  [(UIView *)[self.view viewWithTag:16]frame].size.height);
     [(UIView *)[self.view viewWithTag:4] addSubview:existingMember];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark delegateDropdown

-(void)ViewClickedName:(NSString *)viewTitle setHidden:(BOOL)hideViewBelow{
    [self.tblReferalDoc registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellRef"];
    if ([viewTitle caseInsensitiveCompare:@"Referral Doctor" ]== NSOrderedSame) {
     //   [medicalViewMemberInfo setHidden:YES];
            [(UIView *)[self.view viewWithTag:2] setHidden:hideViewBelow];
        [_tblReferalDoc reloadData];
    }
    else if([viewTitle caseInsensitiveCompare:@"Patient is *" ]== NSOrderedSame){
         [(UIView *)[self.view viewWithTag:4] setHidden:hideViewBelow];
         [(UIView *)[self.view viewWithTag:5] setHidden:YES];
    }
    else if([viewTitle caseInsensitiveCompare:@"Purpose of your visit *"]== NSOrderedSame){
         [(UIView *)[self.view viewWithTag:7] setHidden:hideViewBelow];
        
        // [(UIView *)[self.view viewWithTag:5] setHidden:NO];
    }
    else if([viewTitle caseInsensitiveCompare:@"List all current medication including non-prescription and mention how long you have been taking these"]== NSOrderedSame){
        [(UIView *)[self.view viewWithTag:9] setHidden:hideViewBelow];
        
        // [(UIView *)[self.view viewWithTag:5] setHidden:NO];
    }
    else if([viewTitle caseInsensitiveCompare:@"Allergies, if any"]== NSOrderedSame){
        [(UIView *)[self.view viewWithTag:11] setHidden:hideViewBelow];
        
        // [(UIView *)[self.view viewWithTag:5] setHidden:NO];
    }
    else if([viewTitle caseInsensitiveCompare:@"Pre-diagnosed health conditions, if any"]== NSOrderedSame){
        [(UIView *)[self.view viewWithTag:13] setHidden:hideViewBelow];
        
        // [(UIView *)[self.view viewWithTag:5] setHidden:NO];
    }
    else if([viewTitle caseInsensitiveCompare:@"Vitals"]== NSOrderedSame){
        [(UIView *)[self.view viewWithTag:15] setHidden:hideViewBelow];
        
        // [(UIView *)[self.view viewWithTag:5] setHidden:NO];
    }
}

#pragma mark -- textview delegate

-(void)textViewDidChange:(UITextView *)textView{
    if ([textView isEqual:self.txtViewCHange]) {
    if (textView.text.length>700) {
        textView.text=[textView.text substringToIndex:700];
     }
    }
    else{
        if (textView.text.length>500) {
            textView.text=[textView.text substringToIndex:500];
        }
    }
    if (textView.frame.size.height>SCREEN_HEIGHT*0.45)
        return;
    
    CGRect frame = textView.frame;
    frame.size.height = textView.contentSize.height+20;
    textView.frame = frame;
    
    [[(UIView *)textView.superview heightAnchor]constraintGreaterThanOrEqualToConstant:textView.frame.size.height].active=YES;
}

#pragma mark -- tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag == 1) {
    return arrReferrralDoctor.count;
    }
   else if (tableView.tag == 2) {
        return  arrExistingMembers.count;
   }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellRef" forIndexPath:indexPath];
    
    if(tableView.tag == 1) {
           cell.textLabel.text=[NSString stringWithFormat:@"%@", [[arrReferrralDoctor objectAtIndex:indexPath.row] valueForKey:@"name"]];
    }
    else if (tableView.tag == 2) {
         cell.textLabel.text=[NSString stringWithFormat:@"%@", [[arrExistingMembers objectAtIndex:indexPath.row] valueForKey:@"name"]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.transform = CGAffineTransformMakeTranslation(0.f, cell.frame.size.height);
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    //2. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.5];
    cell.transform = CGAffineTransformMakeTranslation(0.f, 0);
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        _txtReferralDoctor.text = [[arrReferrralDoctor objectAtIndex:indexPath.row] valueForKey:@"name"];
        patientService.question_1 = [[arrReferrralDoctor objectAtIndex:indexPath.row] valueForKey:@"id"];
         patientService.question_1_option_value = @"";
    }
    else if(tableView.tag == 2){
        _txtExistingMember.text = [[arrExistingMembers objectAtIndex:indexPath.row] valueForKey:@"name"];
        patientService.question_1_option_value = [[arrExistingMembers objectAtIndex:indexPath.row] valueForKey:@"id"];
    }
}

#pragma mark -- medical info delegate

-(void)newMemberCLicked:(BOOL)show{
    [(UIView *)[self.view viewWithTag:5] setHidden:show];
    [(UIView *)[self.view viewWithTag:16] setHidden:YES];
    selectedOption = 3;
}
-(void)newSelfCLicked:(BOOL)show{
    [(UIView *)[self.view viewWithTag:5] setHidden:YES];
    [(UIView *)[self.view viewWithTag:16] setHidden:YES];

    _txtName.text = @"";
    _txtDOB.text = @"";
    _txtGender.text = @"";
    selectedOption =1;
}
-(void)newExistingMemberCLicked:(BOOL)show{
    [(UIView *)[self.view viewWithTag:5] setHidden:YES];
    [(UIView *)[self.view viewWithTag:16] setHidden:NO];
    selectedOption =2;
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

#pragma mark -- click events
-(IBAction)btnNextPressed:(id)sender {
    
    if(_txtViewCHange.text.length > 0) {
        
        if(selectedOption == 3) {
            if(![IODUtils getError:self.txtName minVlue:@"4" minVlue:@"50" onlyNumeric:nil onlyChars:YES canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]) {
            }
            else if(![IODUtils getError:self.txtDOB minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
            }
            else if(![IODUtils getError:self.txtGender minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
            }
            else{
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *strDob =[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
                patientService.member_name = _txtName.text;
                patientService.member_dob = strDob;
                int genderid = (int)[IODUtils getGenderId:_txtGender.text];
                patientService.member_gender = genderid;
                [self addData];
            }
        }
        else if (selectedOption == 2) {
            
            if(arrExistingMembers.count >0 && _txtExistingMember.text.length >0) {
                [self addData];
            }
            else {
                if(arrExistingMembers.count == 0) {
                    [IODUtils showFCAlertMessage:MEMBER_ERROR withTitle:@"" withViewController:self with:@"error"];
                }
                else if(_txtExistingMember.text.length == 0) {
                    
                    [IODUtils showFCAlertMessage:SELECT_MEMBER_ERROR withTitle:@"" withViewController:self with:@"error"];
                }
            }
        }
        else if(selectedOption == 1){
            [self addData];
        }
        
        else {
            
            [IODUtils showFCAlertMessage:SELECT_PATIENT_ERROR withTitle:@"" withViewController:self with:@"error"];
        }
    }
    else {
        if(selectedOption == 0) {
            [IODUtils showFCAlertMessage:SELECT_PATIENT_ERROR withTitle:@"" withViewController:self with:@"error"];

        }
        if(_txtViewCHange.text.length == 0) {
            [IODUtils showFCAlertMessage:SELECT_PURPOSE withTitle:@"" withViewController:self with:@"error"];
        }
    }
}

- (void)addData{
    
    NSString *bloodPressure =  _txtBloodPressure.text;
    NSString *bloodPressure2 =  _txtBloodPressure2.text;
    
    if(bloodPressure2.length == 0){
        bloodPressure = _txtBloodPressure.text;
    }
    else {
        bloodPressure = [NSString stringWithFormat:@"%@-%@",_txtBloodPressure.text,_txtBloodPressure2.text];
    }

    NSString *strVitals = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",_txtbodyTemparature.text,bloodPressure,_txtPulseRate.text,_txtRespiratoryRate.text,_txtBloodGlucose.text];
    NSString *strPurpose = _txtViewCHange.text;
    NSString *strcurrentMedication = _txtCurrentMeds.text;
    NSString *strAllergies = _txtAllergies.text;
    NSString *strHealthcondition = _txtDiagnose.text;
    
    patientService.question_3 = strPurpose;
    patientService.question_4 = strcurrentMedication;
    patientService.question_5 = strAllergies;
    patientService.question_6 = strHealthcondition;
    patientService.question_7 =strVitals;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ForceUpdateLocation" object:self userInfo:@{@"pnumb":@"1",@"direction":kNext}];

}

-(IBAction)btnPreviousPressed:(id)sender {
     //  [[NSNotificationCenter defaultCenter] postNotificationName:@"ForceUpdateLocation" object:self userInfo:[NSDictionary dictionaryWithObject:@"0" forKey:@"pnumb"]];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -- API CALLS
- (void)getallReferralDoctor {
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *postparameter = [[NSMutableDictionary alloc]init];
    NSString *category =  patientService.selectedCategory;
    [parameter setObject:patientService.selectedCategoryName forKey:@"categoryname"];
    
   // [parameter setObject:category forKey:@"categoryId"];
    [postparameter setObject:@"" forKey:@"sort"];
    [postparameter setObject:@"" forKey:@"gender"];
    
    [service getAllRefer:parameter PostParameter:postparameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        if([[responseCode  valueForKey:@"status"] isEqualToString:@"success"]) {
                                            NSLog(@"Referral Doctor ");
                                            arrReferrralDoctor = [responseCode valueForKey:@"data"];
                                            [_tblReferalDoc reloadData];
                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
             }
    }];
}

-(void)getAllExistingMembers{
    
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service getAllMembersWithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        if([[responseCode  valueForKey:@"status"] isEqualToString:@"success"]) {
            arrExistingMembers = [responseCode valueForKey:@"data"];
            //NSLog(@"Existing Member ");
            [_tblExistingMember reloadData];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

//-------------------------------------------------------------

// LATEST CHANGES
//-------------------------------------------------------------

#pragma mark - Collection view delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70,70);
}

-(UploadDocCell  *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UploadDocCell *cell=(UploadDocCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"photoUploadCell" forIndexPath:indexPath];
    cell.uploadButon.backgroundColor = [UIColor grayColor];
    [cell.uploadButon setTag:indexPath.row];
    [cell.deleteButton setTag:indexPath.row];
    return cell;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

-(IBAction)btnHomePressed:(id)sender{
    AppDelegate *appDelegate=( AppDelegate* )[UIApplication sharedApplication].delegate;
    [appDelegate updateStatus:@""];
    [self.navigationController popToRootViewControllerAnimated:YES];}



-(void)refreshView:(NSNotification*)notification{
    [self setMedicalInfoData];
    [self getallReferralDoctor];
    [self getAllExistingMembers];
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}

@end
