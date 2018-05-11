//
//  SelectPatientViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 3/6/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "SelectPatientViewController.h"
#import "CommonServiceHandler.h"
#import "PatientAppointService.h"
#import "medicalnfoCell.h"
#import "UploadDocCell.h"
#import "MemberCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SymptomsViewController.h"
#import "AppDelegate.h"


@interface SelectPatientViewController ()
{
    medicalnfoCell *medicalView, *medicalViewMemberInfo,*existingMember;
    NSMutableArray *arrReferrralDoctor,*arrExistingMembers,*arrmember;
    PatientAppointService *patientService;
    int selectedOption;
    UIDatePicker *datePicker;
    UIBarButtonItem *btnNext;
    int selectedGEnder;
    int genderid ;
    NSMutableArray *arrSelection;
    SymptomsViewController *hvc;
}

@end

@implementation SelectPatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    //Set title of the Navigation Bar
    self.title = @"Medical Info";
    
    // Call the referaal list of doctors.
    //[self performSelectorInBackground:@selector(getallReferralDoctor) withObject:nil];
    
   // [self getallReferralDoctor];
    
    hvc =  [self.storyboard instantiateViewControllerWithIdentifier:@"SymptomsViewController"];

    // Initializatin
    arrSelection = [[NSMutableArray alloc] initWithObjects:@"NO",@"NO" ,nil];
    patientService = [PatientAppointService sharedManager];
    arrExistingMembers = [[NSMutableArray alloc]initWithObjects:@"New Member",@"me",nil];
    
    // Call Exixting members list
    [self getAllExistingMembers];

    
    [self.membersCollectionView registerNib:[UINib nibWithNibName:@"MemberCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MemberCollectionViewCell"];
    [_MemberView setHidden:YES];
    
    /*! @brief This is barbutton used to navigate to nect screen */
    btnNext = [[UIBarButtonItem alloc] initWithTitle:kNext style:UIBarButtonItemStyleDone target:self action:@selector(goNextPage:)];
    self.navigationItem.rightBarButtonItem = btnNext;
    selectedOption =0;
    
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



/*! @brief This method is used to get the list of all existing member from API */
-(void)getAllExistingMembers{
    

    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    
    //Check if the internet is reachable
    if (reachable) {
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service getAllMembersWithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        if([[responseCode  valueForKey:@"status"] isEqualToString:@"success"]) {
            NSArray *ExistingMembers = [responseCode valueForKey:@"data"];
            [arrExistingMembers addObjectsFromArray:ExistingMembers];
            for(int i = 0 ;i< arrExistingMembers.count; i++)
                [arrSelection addObject:@"NO"];
            
            [_membersCollectionView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    }
    else {
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}

#pragma mark - Collection view delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arrExistingMembers.count;
}

-(MemberCollectionViewCell  *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MemberCollectionViewCell *cell=(MemberCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"MemberCollectionViewCell" forIndexPath:indexPath];
    
    if([[arrSelection objectAtIndex:indexPath.item] isEqualToString:@"YES"])
        [cell.img setImage:[UIImage imageNamed: @"check-icn.png"]];
    else
        [cell.img setImage:nil];
    
    // First cell is a button to add new member, second cell will be the patient and rest all are existing family members.
    if(indexPath.row == 0) {
       cell.lblTitle.text = @"New Member";
        [cell.imgCell setImage:[UIImage imageNamed:@"New-mem-active.png"]];
        [cell.imgCell setClipsToBounds:YES];
    }
    else if(indexPath.row == 1){
        NSString *strname = @"Self";
        NSString *profilePic = [NSString stringWithFormat:@"%@",UDGet(@"profilePic") ];
        [cell.imgCell sd_setImageWithURL:[NSURL URLWithString:profilePic] placeholderImage:[UIImage imageNamed:@"D-calling-icon.png"]];
        [cell.imgCell setClipsToBounds:YES];
        cell.lblTitle.text = strname;
    }
    else{
        cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[arrExistingMembers objectAtIndex:indexPath.row] valueForKey:@"name"]];
        [cell.imgCell setImage:[UIImage imageNamed:@"D-calling-icon.png"]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    for(int i =0 ; i < arrSelection.count; i++){
        [arrSelection replaceObjectAtIndex:i withObject:@"NO"];
    }
    [arrSelection replaceObjectAtIndex:indexPath.item withObject:@"YES"];
    [_membersCollectionView reloadData];
    if(indexPath.item == 0){
        selectedOption = 3;
        patientService.question_1 = @"3";
        [_MemberView setHidden:NO];
        selectedGEnder = (int)[IODUtils getGenderId:@"Male"];
    }
    else if(indexPath.item >1){
        patientService.question_1 = @"2";
        patientService.question_1_option_value = [[arrExistingMembers objectAtIndex:indexPath.row] valueForKey:@"id"];
        NSString *strSelectedSymptoms;
        [self.navigationController pushViewController:hvc animated:YES];
    }
    else if(indexPath.item == 1){
        [_MemberView setHidden:YES];
        selectedOption =1;
        patientService.question_1 = @"1";
        [self.navigationController pushViewController:hvc animated:YES];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}



#pragma mark -- medical info delegate

-(IBAction)newMemberCLicked:(id)sender{
    selectedOption = 3;
}

-(IBAction)newSelfCLicked:(id)sender{
    _txtName.text = @"";
    _txtDOB.text = @"";
    selectedOption =1;
}

- (IBAction)otherTapped:(UIButton *)sender {
  [sender setBackgroundImage:[UIImage imageNamed:@"gender-o-active.png"] forState:UIControlStateNormal];
    [_Male setBackgroundImage:[UIImage imageNamed:@"gender-m.png"] forState:UIControlStateNormal];
    [_Female setBackgroundImage:[UIImage imageNamed:@"gender-f.png"] forState:UIControlStateNormal];
    selectedGEnder = (int)[IODUtils getGenderId:@"Other"];
}

- (IBAction)femmaleTapped:(UIButton *)sender {
    [sender setBackgroundImage:[UIImage imageNamed:@"gender-f-active.png"] forState:UIControlStateNormal];
    [_Male setBackgroundImage:[UIImage imageNamed:@"gender-m.png"] forState:UIControlStateNormal];
    [_Other setBackgroundImage:[UIImage imageNamed:@"gender-o.png"] forState:UIControlStateNormal];
    selectedGEnder = (int)[IODUtils getGenderId:@"Female"];
}

- (IBAction)maleTapped:(UIButton *)sender {
    [sender setBackgroundImage:[UIImage imageNamed:@"gender-m-active.png"] forState:UIControlStateNormal];
    [_Female setBackgroundImage:[UIImage imageNamed:@"gender-f.png"] forState:UIControlStateNormal];
    [_Other setBackgroundImage:[UIImage imageNamed:@"gender-o.png"] forState:UIControlStateNormal];
    selectedGEnder = (int)[IODUtils getGenderId:@"Male"];
}

-(IBAction)goNext:(id)sender{
}


#pragma mark Textfield delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
     if (textField == self.txtDOB){
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


#pragma mark Button click events
-(IBAction)goNextPage:(id)sender{
    if(selectedOption == 0){
        [IODUtils showFCAlertMessage:SELECT_PATIENT  withTitle:nil withViewController:self with:@"error" ];
    }
    else if(selectedOption == 1){
        [self.navigationController pushViewController:hvc animated:YES];
    }
    else if(selectedOption == 3) {
            if(![IODUtils getError:self.txtName minVlue:@"4" minVlue:@"50" onlyNumeric:nil onlyChars:YES canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]) {
            }
            else if(![IODUtils getError:self.txtDOB minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
            }
            else{
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *strDob =[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
                patientService.member_name = _txtName.text;
                patientService.member_dob = strDob;
                int genderid = selectedGEnder;
                patientService.member_gender = genderid;
                [self.navigationController pushViewController:hvc animated:YES];
            }
    }
    else{
        [IODUtils showFCAlertMessage:SELECT_PATIENT  withTitle:nil withViewController:self with:@"error" ];
    }
}




-(IBAction)btnHomePressed:(id)sender{
    AppDelegate *appDelegate=( AppDelegate* )[UIApplication sharedApplication].delegate;
    [appDelegate updateStatus:@""];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)getallReferralDoctor {
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *postparameter = [[NSMutableDictionary alloc]init];
    [postparameter setObject:@"" forKey:@"sort"];
    [postparameter setObject:@"" forKey:@"gender"];
    
    [service getAllRefer:parameter PostParameter:postparameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        
        if([[responseCode  valueForKey:@"status"] isEqualToString:@"success"]) {
            NSMutableArray  *ReferrralDoctor = [responseCode valueForKey:@"data"];
            if(patientService.ReferalDoc.count == 0){
                patientService.ReferalDoc = ReferrralDoctor;
            }
        }
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return CGSizeMake(110, 110);
    }
    return CGSizeMake(100, 100);
}


-(void)refreshView:(NSNotification*)notification{
    [self getAllExistingMembers];
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}


@end
