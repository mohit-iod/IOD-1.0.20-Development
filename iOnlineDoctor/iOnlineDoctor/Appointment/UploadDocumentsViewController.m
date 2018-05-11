//
//  UploadDocumentsViewController.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/21/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "UploadDocumentsViewController.h"
#import "searchDoctorVC.h"
#import "PatientAppointService.h"
#import "CommonServiceHandler.h"
#import "PaymentViewController.h"
#import "RegistrationService.h"
#import "DocumentPickerViewController.h"
#import "SuccessfulPaymentViewController.h"
#import "AppDelegate.h"
#import "PatientListCell.h"
#import "UIImageView+WebCache.h"


@interface UploadDocumentsViewController ()<UITableViewDataSource,UITableViewDelegate,documentPickerDelegate>

{
    PatientAppointService *patientService;
    NSArray *arrReferrralDoctor,*arrExistingMembers;
    NSMutableArray *arrAutoComplete;
    UIBarButtonItem *btnNext;
    NSString *strButtonTitle;
    int doctorPracticeCount;
    
    NSArray *searchResultsArray;
    
}

@end

@implementation UploadDocumentsViewController

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [btnNext setEnabled:YES];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    NSLog(@"Child view Controller %@", self.childViewControllers);
    BOOL reachable = reach. isReachable;
    if (reachable){
        [self getallReferralDoctor];
    }
    else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
    patientService = [PatientAppointService sharedManager];
   // [self.view addSubview:_tblReferalDoc];
    //_tblReferalDoc.delegate = self;
   // _tblReferalDoc.dataSource = self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   // arrReferrralDoctor = patientService.ReferalDoc;
    [self.tblReferalDoc registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellRef"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    //Next button
    btnNext = [[UIBarButtonItem alloc] initWithTitle:kSkip style:UIBarButtonItemStyleDone target:self action:@selector(nextPressed:)];
    self.navigationItem.rightBarButtonItem = btnNext;
    _tblReferalDoc.hidden = YES;
    [_btnOr.layer setCornerRadius:20.0];
    [_referalView.layer setCornerRadius:10.0];
    [_referalView.layer setBorderWidth:2.0];
    [_referalView.layer setBorderColor:[UIColor colorWithHexRGB:kBorderColor].CGColor];
    [_referalView setHidden:YES];
    UINib *nib = [UINib nibWithNibName:@"PatientListCell" bundle:[NSBundle mainBundle]];
    [[self tblReferalDoc] registerNib:nib forCellReuseIdentifier:@"PatientListCell"];
}


- (IBAction)closeReferralList:(id)sender{
    [_referalView setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.title =@"Medical Info";
    self.title = @"Medical Info";
    
    if((patientService.isPracticeCallDone <= 0) && (patientService.doctorPracticeCount > 0) && ([patientService.visit_type_id isEqualToString:@"2"]))
        [btnNext setTitle:kBookNow];
    else if((patientService.arrDocumentData.count > 0 ) || (_txtReferalDoctor.text.length > 0) || (_txtReferalCode.text.length > 0) )
            [btnNext setTitle:kNext];
        else
            [btnNext setTitle:kSkip];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- API CALLS
// Get all the list of all referral doctors
- (void)getallReferralDoctor {
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [service getMedicalInforREferalDoctor:parameter ithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"Response code for the medical info is %@",responseCode);
        if([[responseCode  valueForKey:@"status"] isEqualToString:@"success"]) {
            arrReferrralDoctor = [[NSMutableArray alloc] init];
            arrReferrralDoctor = [responseCode valueForKey:@"data"];
            searchResultsArray = arrReferrralDoctor;
            [_tblReferalDoc setHidden:NO];
            [_tblReferalDoc reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
     }
    }];
}


#pragma mark -- tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return searchResultsArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
    
}

-(PatientListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PatientListCell"];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    
    cell.lblDoctorName.text = [NSString stringWithFormat:@"%@", [[ searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"name"]];
    cell.lblDate.text  = [NSString stringWithFormat:@"%@", [[ searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"specialization"]];
       
    NSString *profilePic = [NSString stringWithFormat:@"%@",[[ searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"profile_pic"]];
    if([profilePic isEqualToString:@"<null>"]){
        profilePic = @"";
    }
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:profilePic] placeholderImage:[UIImage imageNamed:@"D-calling-icon.png"]];
    
    [cell.imgV.layer setCornerRadius:(cell.imgV.frame.size.width/2)];
    [cell.imgV setClipsToBounds:YES];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor whiteColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(searchResultsArray.count > 0){
          NSString *doctorId = [NSString stringWithFormat:@"%@",[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"id"]];
          NSString *doctorName = [NSString stringWithFormat:@"%@",[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"name"]];
        _txtReferalDoctor.text = doctorName;
        patientService.question_8_id = doctorId;
        [_referalView setHidden:YES];
        [btnNext setTitle:kNext];
    }
}

#pragma mark - Textfield delegate method
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if(textField == _txtReferalCode)
        _txtReferalDoctor.text = @"";
    
    if(textField == _txtReferalDoctor) {
        _txtReferalCode.text = @"";
        [_referalView setHidden:NO];
    }
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
  //  [_tblReferalDoc setHidden:YES];
    if(string.length>0)
        btnNext.title = kNext;
    else
        btnNext.title = kSkip;

    if(textField == _txtReferalCode){
        if(textField.text.length > 0)
            _txtReferalDoctor.text =@"";
    }
    else{
        if(_referalView.hidden == YES){
            [_referalView setHidden:NO];
        }
    }
  /*  else{
         if(string.length > 0){
           _txtReferalCode.text =@"";
           // _tblReferalDoc.hidden = NO;
            NSString *substring = [NSString stringWithString:textField.text];
            substring = [substring
                         stringByReplacingCharactersInRange:range withString:string];
           // [self searchAutocompleteEntriesWithSubstring:substring];
        }
        else{
            _tblReferalDoc.hidden = YES;
            [self.view bringSubviewToFront:_tblReferalDoc];
            
            NSString *substring = [NSString stringWithString:textField.text];
            substring = [substring
                         stringByReplacingCharactersInRange:range withString:string];
            [self searchAutocompleteEntriesWithSubstring:substring];
        }*/
   // return YES;

    //}
    return YES;
}

/*! @discussion This method is used to get the auto complete doctor list when enter text in textfield */
-(void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [arrAutoComplete removeAllObjects];
    arrAutoComplete = [[NSMutableArray alloc] init];
    for(NSDictionary *curDict in arrReferrralDoctor ) {
        NSString *strName =[NSString stringWithFormat:@"%@", [curDict valueForKey:@"name"]];
        NSRange substringRange = [strName rangeOfString:substring];
        if (substringRange.location == 0) {
            [arrAutoComplete addObject:curDict];
        }
    }
    if(arrAutoComplete.count > 0){
        [_tblReferalDoc reloadData];
        [_tblReferalDoc setHidden:NO];
    }
}

/*!@discussion This method  is used to go to RootViewController./ dashboard view !*/

-(IBAction)btnHomePressed:(id)sender{
    AppDelegate *appDelegate=( AppDelegate* )[UIApplication sharedApplication].delegate;
    [appDelegate updateStatus:@""];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*!@discussion This method  is used to go to next page based on type of visit_type_id*/
-(IBAction)nextPressed:(id)sender {
    if(_txtReferalCode.text.length > 0 ){
        patientService.question_8_code= _txtReferalCode.text;
        patientService.question_8_id= @"";
        
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        if (reachable){
            RegistrationService *service = [[RegistrationService alloc] init];
            NSMutableDictionary *userdata = [[NSMutableDictionary alloc] init];
            [userdata setObject:_txtReferalCode.text forKey:@"reffral_code"];
            [userdata setObject:@"doctor" forKey:@"user_type"];
            if(_txtReferalCode.text.length > 0 ){
                [service validateReferalCode:userdata withCompletionBlock:^(id response, NSError *error) {
                    if(error){
                        [btnNext setEnabled:YES];
                        [IODUtils showFCAlertMessage:[error valueForKey:@"message"]  withTitle:@"" withViewController:self with:@"error"];
                    }
                    else if([[response  valueForKey:@"status"] isEqualToString:@"success"]) {
                        if([[response valueForKey:@"message"]
                            isEqualToString:@"This reffral code is not valid."]){
                            [btnNext setEnabled:YES];
                      [IODUtils showFCAlertMessage:[response valueForKey:@"message"] withTitle:@"" withViewController:self with:@"error"];
                        }
                        else{
                            if((patientService.isPracticeCallDone <= 0) && (patientService.doctorPracticeCount > 0)){
                                if([patientService.visit_type_id isEqualToString:@"1"]){
                                    [btnNext setEnabled:YES];
                                    [self redirectUSer];
                                }
                                else if([patientService.visit_type_id isEqualToString:@"2"]){
                                    [self PostDataForApppointment];
                                }
                                else{
                                    [btnNext setEnabled:YES];
                                    [self redirectUSer];
                                }
                            }
                            else{
                                [btnNext setEnabled:YES];
                                [self redirectUSer];
                            }
                        }
                    }
                    else if([[response  valueForKey:@"status"] isEqualToString:@"fail"]){
                         [IODUtils showFCAlertMessage:[response valueForKey:@"message"] withTitle:@"" withViewController:self with:@"error"];
                    }
                }];
            }
        }
        else
        {
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        }
    }
    else{
        patientService.question_8_code= @"";
        if(_txtReferalDoctor.text.length>0){
            if(arrReferrralDoctor.count > 0){
                NSMutableArray *arrNames = [[NSMutableArray alloc] init];
                for (NSDictionary *aDict in arrReferrralDoctor)
                    [arrNames addObject:[aDict valueForKey:@"name"]];
                if([arrNames containsObject:_txtReferalDoctor.text])
                    [self redirectUSer];
                else
                    [IODUtils showFCAlertMessage:@"Please select valid Telemedicine Facilitator" withTitle:@"" withViewController:self with:@"error"];
            }
            else{
                [IODUtils showFCAlertMessage:@"Please select valid Telemedicine Facilitator" withTitle:@"" withViewController:self with:@"error"];
            }
        }
        else{
            
            if((patientService.isPracticeCallDone <= 0) && (patientService.doctorPracticeCount > 0)){
                if([patientService.visit_type_id isEqualToString:@"1"])
                    [self redirectUSer];
                
                else if([patientService.visit_type_id isEqualToString:@"2"])
                    [self PostDataForApppointment];
                else
                    [self redirectUSer];
            }
            else{
                [self redirectUSer];
            }
        }
    }
}



-(void) redirectUSer{
    PaymentViewController *pvc =  [self.storyboard instantiateViewControllerWithIdentifier:@"paymentViewController"];
    UIViewController *viewTab=[self.storyboard instantiateViewControllerWithIdentifier:@"TabbarCategoryViewController"];
    searchDoctorVC *searchDoctor = [self.storyboard instantiateViewControllerWithIdentifier:@"searchDoctorVC"];
    
    if((patientService.isPracticeCallDone <= 0) && (patientService.doctorPracticeCount > 0)){
        if ([patientService.visit_type_id isEqualToString:@"1"])
            [self.navigationController pushViewController:viewTab animated:YES];
        else if ([patientService.visit_type_id isEqualToString: @"2"])
            [self PostDataForApppointment];
        else
            [self.navigationController pushViewController:pvc animated:YES];
    }
    else{
        if ([patientService.visit_type_id isEqualToString:@"1"]) {
            [self.navigationController pushViewController:viewTab animated:YES];
        }
        else if ([patientService.visit_type_id isEqualToString:@"2"]) {
            if([patientService.isFromliveCall isEqualToString:@"yes"])
                [self.navigationController pushViewController:searchDoctor animated:YES];
            else
                [self.navigationController pushViewController:pvc animated:YES];
        }
        else if ([patientService.visit_type_id isEqualToString:@"3"]) {
            [self.navigationController pushViewController:pvc animated:YES];
        }
    }
}

-(IBAction)previousPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ForceUpdateLocation" object:self userInfo:@{@"pnumb":@"0",@"direction":@"back"}];
}


/*! Post Book appointment data for GEt patient token Api  !*/
-(void)PostDataForApppointment{
    int slotid =[patientService.slot_id intValue];
    NSString *slots = patientService.slot_id;
    if([patientService.visit_type_id isEqualToString:@"3"]){
    }
    
    NSString *numberString = [NSString stringWithFormat:@"%@", patientService.amount];
    float amt = [numberString floatValue];
    NSString *stramt = [NSString stringWithFormat:@"%.2f",amt];
    patientService.amount = stramt;
    NSString *strSymptom = UDGet(@"SelectedSymptoms");
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:patientService.doctor_id forKey:kdoctor_id];
    [parameter setObject:@"0" forKey:@"price"];
    [parameter setObject:@"0" forKey:@"coupon_price"];
    [parameter setObject:slots forKey:ktime_slot_id];
    [parameter setObject:@"0" forKey:@"doctor_price"];
    [parameter setObject:@"" forKey:kappointment_slot_id];
    [parameter setObject:patientService.visit_type_id forKey:kvisit_type_id];
    [parameter setObject:patientService.couponCode forKey:@"coupan"];
    [parameter setObject:patientService.date forKey:kdate];
    [parameter setObject:patientService.question_1 forKey:kquestion_1];
    [parameter setObject:strSymptom forKey:kquestion_2];
    [parameter setObject:patientService.question_1_option_value forKey:kquestion_1_option_value];
    [parameter setObject:patientService.selectedCategoryName forKey:@"category"];
    [parameter setObject:patientService.member_name forKey:knew_member_name];
    [parameter setObject:[NSNumber numberWithInt:patientService.member_gender] forKey:knew_member_gender];
    [parameter setObject:patientService.member_dob forKey:knew_member_dob];
    [parameter setObject:patientService.question_3 forKey:kquestion_3];
    [parameter setObject:patientService.question_4 forKey:kquestion_4];
    [parameter setObject:patientService.question_5 forKey:kquestion_5];
    [parameter setObject:patientService.question_6 forKey:kquestion_6];
    [parameter setObject:patientService.question_7 forKey:kquestion_7];
    [parameter setObject:patientService.question_8_code forKey:@"question_8_code"];
    [parameter setObject:patientService.question_8_id forKey:@"question_8_id"];
    [parameter setObject:[NSNumber numberWithInt:patientService.payment_mode_id] forKey:kpayment_mode_id];
    [parameter setObject:patientService.payment_status forKey:kpayment_status];
    [parameter setObject:patientService.correlation_id forKey:kcorrelation_id];
    [parameter setObject:patientService.transaction_status forKey:ktransaction_status];
    [parameter setObject:patientService.validation_status forKey:kvalidation_status];
    [parameter setObject:patientService.transaction_type forKey:ktransaction_type];
    [parameter setObject:patientService.transaction_id forKey:ktransaction_id];
    [parameter setObject:patientService.transaction_tag forKey:ktransaction_tag];
    [parameter setObject:patientService.method forKey:kmethod];
    [parameter setObject:[NSString stringWithFormat:@"0"] forKey:kamount];
    [parameter setObject:patientService.currency forKey:kcurrency];
    [parameter setObject:patientService.bank_resp_code forKey:kbank_resp_code];
    [parameter setObject:patientService.bank_message forKey:kbank_message];
    [parameter setObject:patientService.gateway_resp_code forKey:kgateway_resp_code];
    [parameter setObject:patientService.gateway_message forKey:kgateway_message];
    
    PatientAppointService *service = [[PatientAppointService alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service bookAppointment:parameter andImageName:patientService.documentName andImages:patientService.arrDocumentData dataType:patientService.arrDocType WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(error){
        }
        else if ([[responseCode objectForKey:@"status"] isEqualToString:@"success"]) {
                patientService.res_order_no = [[responseCode objectForKey:@"data"] valueForKey:@"order_no"];
                patientService.res_date = [[responseCode objectForKey:@"data"] valueForKey:@"date"];
                patientService.res_doctor_name = [[responseCode objectForKey:@"data"] valueForKey:@"doctor_name"];
                patientService.res_startTime = [[responseCode objectForKey:@"data"] valueForKey:@"start_time"];
                SuccessfulPaymentViewController *succPayment = [self.storyboard instantiateViewControllerWithIdentifier:@"SuccessfulPaymentViewController"];
                UILocalNotification* localNotification = [[UILocalNotification alloc] init];
                NSString *str = [NSString stringWithFormat:@"%@ %@",patientService.res_date,patientService.res_startTime];
                NSDate *dt = [IODUtils formatDateAndTimeForBusinessSlots:str];
                dt = [dt dateByAddingTimeInterval: 60*-30];
                localNotification.fireDate = dt;
                localNotification.alertBody = @"Book appointment";
                localNotification.timeZone = [NSTimeZone localTimeZone];
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                patientService.documentName = [[NSMutableArray alloc] init];
                patientService.arrDocumentData =[[NSMutableArray alloc] init];
                [self.navigationController pushViewController:succPayment animated:YES];
            }
    }];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // called when text ends editing
    [searchBar setShowsCancelButton:NO animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    searchResultsArray = arrReferrralDoctor;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length ==0) {
        searchResultsArray=arrReferrralDoctor;
        [_tblReferalDoc reloadData];
        // return;
    }
    else {
        //NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@ " ,searchText];
        
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name.description CONTAINS[cd] %@", searchText];
        NSArray *SearchResult = [arrReferrralDoctor filteredArrayUsingPredicate:resultPredicate];
        searchResultsArray = [[NSArray alloc] init];
        searchResultsArray=SearchResult.copy;
        [_tblReferalDoc reloadData];
    }
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0){
    return  YES;
}

// called before text changes
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // called when keyboard search button pressed
    [self.view endEditing:YES];
}


@end
