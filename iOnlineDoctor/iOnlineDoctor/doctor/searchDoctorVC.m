  //
//  searchDoctorVC.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/9/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//
#import "searchDoctorVC.h"
#import "doctorOnlineCell.h"
#import "searchDoctorTableCell.h"
#import "PatientVideoCallViewController.h"
#import "CommonServiceHandler.h"
#import "PatientAppointService.h"
#import "IODUtils.h"
#import "BookAppointmentVC.h"
#import "UIImageView+WebCache.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "DoctorAppointmentServiceHandler.h"
#import "AboutdoctorViewController.h"
#import "PatientAppointService.h"
#import "PaymentViewController.h"


@interface searchDoctorVC ()
@end
@implementation searchDoctorVC
{
    NSMutableArray *arrOnlineDoctor;
    NSArray *searchResultsArray;
    PatientAppointService *patientService;
    DoctorAppointmentServiceHandler *docService;
    NSString *sortKey;
    NSString *sortGender;
    NSString *experience;
    NSString *status;
    int doctorSelected;
    
}
-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {

    
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    patientService = [PatientAppointService sharedManager];
    docService = [DoctorAppointmentServiceHandler sharedManager];
    
    self.title=@"Search Doctors";
    
    //Setting the sorting key to blank
    sortKey = @"";
    experience = @"";
    sortGender = @"";
    patientService.couponMessage = @"";
    patientService.couponPrice = @"";
    patientService.remainingPrice = @"";
    doctorSelected =0;
    
    searchResultsArray = [[NSArray alloc]init];
    UINib *nib = [UINib nibWithNibName:@"doctorOnlineCell" bundle:[NSBundle mainBundle]];
    UINib *nib1 = [UINib nibWithNibName:@"searchDoctorTableCell" bundle:[NSBundle mainBundle]];
    
    [[self tblDoctSearch] registerNib:nib forCellReuseIdentifier:@"doctorOnlineCell"];
    [[self tblDoctSearch] registerNib:nib1 forCellReuseIdentifier:@"searchDoctorTableCell"];
    [self refresh];
    //If doctor is busy set doctor idle
    status = @"0";
    if(patientService.doctor_id.length > 0){
        [self performSelectorInBackground:@selector(updateDoctorStatus) withObject:nil];
        //patientService.doctor_id = @"";
    }
}

- (IBAction)showSortingOption:(id)sender{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Sort By" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIPopoverPresentationController *popover = actionSheet.popoverPresentationController;
    if (popover)
    {
        popover.sourceView = sender;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Price (Low to High) " style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Distructive button tapped.
        sortGender = @"";
        sortKey = @"price-asc";
        if([patientService.visit_type_id isEqualToString:@"1"])
            [self getAllOnlineDoctors];
        if([patientService.visit_type_id isEqualToString:@"2"])
            [self getallReferralDoctor];            if([patientService.visit_type_id isEqualToString:@"3"])
                [self getallReferralDoctor];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Price (High to Low) " style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Distructive button tapped.
        sortGender = @"";
        sortKey = @"price-desc";
        if([patientService.visit_type_id isEqualToString:@"1"])
            [self getAllOnlineDoctors];
        if([patientService.visit_type_id isEqualToString:@"2"])
            [self getallReferralDoctor];            if([patientService.visit_type_id isEqualToString:@"3"])
                [self getallReferralDoctor];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Ratings (Low to High) " style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Distructive button tapped.
        sortGender = @"";
        sortKey = @"rating-asc";
        if([patientService.visit_type_id isEqualToString:@"1"])
            [self getAllOnlineDoctors];
        if([patientService.visit_type_id isEqualToString:@"2"])
            [self getallReferralDoctor];            if([patientService.visit_type_id isEqualToString:@"3"])
                [self getallReferralDoctor];
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Ratings (High to Low) " style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Distructive button tapped.
        sortGender = @"";
        sortKey = @"rating-desc";
        if([patientService.visit_type_id isEqualToString:@"1"])
            [self getAllOnlineDoctors];
        if([patientService.visit_type_id isEqualToString:@"2"])
            [self getallReferralDoctor];            if([patientService.visit_type_id isEqualToString:@"3"])
                [self getallReferralDoctor];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Experience (Low to High) " style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Distructive button tapped.
        sortGender = @"";
        sortKey = @"experience-asc";
        if([patientService.visit_type_id isEqualToString:@"1"])
            [self getAllOnlineDoctors];
        if([patientService.visit_type_id isEqualToString:@"2"])
            [self getallReferralDoctor];            if([patientService.visit_type_id isEqualToString:@"3"])
                [self getallReferralDoctor];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Experience (High to Low) " style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Distructive button tapped.
        sortGender = @"";
        sortKey = @"experience-desc";
        if([patientService.visit_type_id isEqualToString:@"1"])
            [self getAllOnlineDoctors];
        if([patientService.visit_type_id isEqualToString:@"2"])
            [self getallReferralDoctor];            if([patientService.visit_type_id isEqualToString:@"3"])
                [self getallReferralDoctor];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    
    
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Gender (Male)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Distructive button tapped.
        sortGender = @"male";
        sortKey = @"";
        if([patientService.visit_type_id isEqualToString:@"1"])
            [self getAllOnlineDoctors];
        if([patientService.visit_type_id isEqualToString:@"2"])
            [self getallReferralDoctor];            if([patientService.visit_type_id isEqualToString:@"3"])
                [self getallReferralDoctor];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Gender (Female) " style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Distructive button tapped.
        sortGender = @"female";
        sortKey = @"";
        if([patientService.visit_type_id isEqualToString:@"1"])
            [self getAllOnlineDoctors];
        if([patientService.visit_type_id isEqualToString:@"2"])
            [self getallReferralDoctor];            if([patientService.visit_type_id isEqualToString:@"3"])
                [self getallReferralDoctor];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)refresh{
    searchResultsArray = [[NSArray alloc]init];
    UINib *nib = [UINib nibWithNibName:@"doctorOnlineCell" bundle:[NSBundle mainBundle]];
    [[self tblDoctSearch] registerNib:nib forCellReuseIdentifier:@"doctorOnlineCell"];
    
    UINib *nib1 = [UINib nibWithNibName:@"searchDoctorTableCell" bundle:[NSBundle mainBundle]];
    [[self tblDoctSearch] registerNib:nib1 forCellReuseIdentifier:@"searchDoctorTableCell"];
    
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach.isReachable;
    [self.errorPage setHidden:YES];
    docService.isCallInterrupted = @"no";
    docService.isFromDocument = @"no";
    if (reachable){
        if([patientService.visit_type_id isEqualToString:@"1"])
            [self getAllOnlineDoctors];
        if([patientService.visit_type_id isEqualToString:@"2"])
            [self getallReferralDoctor];
        
        if([patientService.visit_type_id isEqualToString:@"3"])
            [self getallReferralDoctor];
    }
    
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
}

-(void) viewWillAppear:(BOOL)animated {
    [self refresh];
}

-(void)viewDidAppear:(BOOL)animated{

}

//Update Doctor satus
- (void)updateDoctorStatus{    
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:patientService.doctor_id forKey:@"doctor_id"];
    [parameter setObject:@"" forKey:@"slot_id"];
    [parameter setObject:patientService.visit_type_id forKey:@"visit_type_id"];
    [parameter setObject:status forKey:@"status"];
    [parameter setObject:[NSNumber numberWithInt:patientService.payment_mode_id] forKey:kpayment_mode_id];
    
    NSLog(@"Parameter %@", parameter);
    [service updateStatus:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        if(error){
           // NSLog(@"RESPONSE is %@", responseCode);
            if([[error valueForKey:@"status"] isEqualToString:@"fail"]){
             //   [IODUtils showMessage:[error valueForKey:@"message"] withTitle:@"Error"];
                
                 [IODUtils showFCAlertMessage:[error valueForKey:@"message"] withTitle:@"" withViewController:self with:@"error"];
                
            }
        }
        else{
            // check doctor id here
            if([patientService.visit_type_id isEqualToString:@"1"] && doctorSelected == 1){
                [self PostData];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    searchResultsArray = arrOnlineDoctor;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length ==0) {
        searchResultsArray=arrOnlineDoctor;
        [_tblDoctSearch reloadData];
       // return;
    }
    else {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@ OR  specialization contains[c] %@ OR languages  contains[c] %@ OR qualification contains[c] %@" ,searchText,searchText,searchText,searchText,searchText];
            NSArray *SearchResult = [arrOnlineDoctor filteredArrayUsingPredicate:resultPredicate];
            
            searchResultsArray=SearchResult.copy;
            [_tblDoctSearch reloadData];
        }
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0){
    return  YES;
} // called before text changes
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // called when keyboard search button pressed
    [self.view endEditing:YES];
}

#pragma mark Tble view mwthods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat heighForRow;
    int doctorPracticeCount = [[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"practice_count"] intValue];
    if([patientService.visit_type_id isEqualToString:@"3"]){
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            heighForRow = 140;
        }else{
            heighForRow = 120;
        }
    }
    else{
        if((patientService.isPracticeCallDone <= 0) && (doctorPracticeCount > 0))
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                heighForRow = 170;
            }else{
                heighForRow = 150;
            }
            else
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    heighForRow = 140;
                }else{
                    heighForRow = 120;
                }
    }
    return heighForRow;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return searchResultsArray.count;
}

-(searchDoctorTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    searchDoctorTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"searchDoctorTableCell" ];
    
    NSString *state = [NSString stringWithFormat:@"%@",[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"state"]];
    NSString *country = [NSString stringWithFormat:@"%@",[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"country"]];
    
    if([state isEqualToString:@"<null>"])
        state = @"";
    else
        state = [state stringByAppendingString:@","];
    
    cell.lblAddress.text = [NSString stringWithFormat:@"%@ %@",state,country];
    cell.lblName.text = [NSString stringWithFormat:@"%@",[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"name"]];
    NSString *strLanguage = [[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"languages"];
    strLanguage = [[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"languages"];
    strLanguage = [strLanguage stringByReplacingOccurrencesOfString:@"," withString:@", "];
    cell.lblLanguage.text= [NSString stringWithFormat:@"%@ ",strLanguage];
    
    cell.lblQualification.text =[NSString stringWithFormat:@"%@ ",[NSString stringWithFormat:@"%@",[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:kqualification]]];
    
    NSString *gender = [NSString stringWithFormat:@"%@ ",[NSString stringWithFormat:@"%@",[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:kgender]]];
    gender = [gender capitalizedString];
    cell.lblGender.text =[NSString stringWithFormat:@"%@ ",gender];
    cell.lblExperience.text =[NSString stringWithFormat:@"%@ yrs. Exp.",[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:kexperience]];
    
    [cell.btnCall setTag:indexPath.row];
    
    NSString *strPrice = [NSString stringWithFormat:@"%.02f %@",[[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"price"] floatValue], [[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"currency"]];
    int doctorPracticeCount = [[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"practice_count"] intValue];
    if((patientService.isPracticeCallDone <= 0) && (doctorPracticeCount > 0)){
    
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:strPrice];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@9
                                range:NSMakeRange(0, [attributeString length])];
        
        [attributeString addAttribute:NSStrikethroughColorAttributeName
                                value:[UIColor redColor]
                                range:NSMakeRange(0, [attributeString length])];
        [cell.btnCall.layer setBorderWidth:0];
        [cell.btnCall setAttributedText:attributeString];
        [cell.lblPromoCall setHidden:NO];
    }
    else{
        [cell.btnCall setText:strPrice];
        [cell.lblPromoCall setHidden:YES];
    }
    
    NSString *rating = [NSString stringWithFormat:@"(%@)",[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"rating"]];
    if([rating isEqualToString:@"(<null>)"])
        cell.lblRating.text =@"";
    else
        cell.lblRating.text = rating;
     NSString *rat = [NSString stringWithFormat:@"%@",[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"rating_avg"] ];
    [cell.ratingView setRating:[rat floatValue]];
    
    
    NSString *strProfilePic = [NSString stringWithFormat:@"%@",[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"profile_pic"]];
    if ([strProfilePic isEqual:[NSNull null]])
        strProfilePic = @"";
    cell.btnProfilePic.clipsToBounds = YES;
    [cell.btnProfilePic.layer setCornerRadius:cell.btnProfilePic.frame.size.width/2];
    [cell.btnProfilePic sd_setImageWithURL:[NSURL URLWithString:strProfilePic] placeholderImage:[UIImage imageNamed:@"P-calling-icon.png"]];
    [cell.btnProfile setTag:indexPath.row];
    [cell.btnProfile addTarget:self action:@selector(goToDoctorProfile:) forControlEvents:UIControlEventTouchUpInside];
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
    if([searchResultsArray count]>0){
        
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach.isReachable;
        [self.errorPage setHidden:YES];
        
        if (reachable){
            doctorSelected = 1;
            
            status = @"1";
            docService.isCallInterrupted = @"no";
            NSString *doctorId = [NSString stringWithFormat:@"%@",[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"id"]];
            patientService.doctor_id = doctorId;
            patientService.amount  = [NSString stringWithFormat:@"%.2f",[[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"price"] floatValue]];
            patientService.selectedDoctorCountry =[NSString stringWithFormat:@"%@",[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"country"]];
            patientService.usdPrice =[NSString stringWithFormat:@"%@",[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"usd_price"]];
            patientService.doctorPrice = [NSString stringWithFormat:@"%.2f",[[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"doctor_price"] floatValue]];
            patientService.strCurrency = [NSString stringWithFormat:@"%@",[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"currency"]];
            patientService.currency = [NSString stringWithFormat:@"%@",[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"currency"]];
            int doctorPracticeCount = [[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"practice_count"] intValue];
            patientService.doctorPracticeCount = doctorPracticeCount;
            
            if((patientService.isPracticeCallDone <= 0) && (doctorPracticeCount > 0)){
                if([patientService.visit_type_id isEqualToString:@"1"]){
                    patientService.payment_mode_id = 8;
                    status = @"1";
                    [self updateDoctorStatus];
                }
                else if([patientService.visit_type_id isEqualToString:@"2"]){
                    patientService.payment_mode_id = 8;
                    [self navigateBookAppointmentVC];
                }
                else{
                    if(patientService.payment_mode_id != 8)
                        patientService.payment_mode_id = 0;
                    [self navigateBookAppointmentVC];
                }
            }
            else{
                if([patientService.visit_type_id isEqualToString:@"1"]) {
                    if([patientService.isFromLiveVideoCall  isEqualToString: @"yes"]){
                        if(patientService.payment_mode_id == 1){
                            [self PostData];
                        }
                        else{
                            patientService.couponPrice = @"";
                            patientService.payment_mode_id = 0;
                            [self navigatePaymentVC];
                        }
                    }
                    else{
                        patientService.payment_mode_id = 0;
                        [self navigatePaymentVC];
                    }
                }
                else  if([patientService.visit_type_id isEqualToString:@"2"]) {
                    [self navigateBookAppointmentVC];
                }
                else{
                    [self navigateBookAppointmentVC];
                }
            }
        }
        else{
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        }
    }
}

-(IBAction)goToDoctorProfile:(UIButton *)sender{
    AboutdoctorViewController *aboutDoctor = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutdoctorViewController"];
    aboutDoctor.userProfile = [searchResultsArray objectAtIndex:sender.tag];
    [self.navigationController pushViewController:aboutDoctor animated:YES];
}


-(void)navigateBookAppointmentVC{
    BookAppointmentVC *bookAppointmentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BookAppointmentVC"];
    [self.navigationController pushViewController:bookAppointmentVC animated:YES];
}

-(void)navigatePaymentVC{
    PaymentViewController *pvc =  [self.storyboard instantiateViewControllerWithIdentifier:@"paymentViewController"];
    [self.navigationController pushViewController:pvc animated:YES];
}
//Live call
-(void)PostData {

    NSString *strSymptom = UDGet(@"SelectedSymptoms");
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:[NSNumber numberWithInt:patientService.payment_mode_id] forKey:@"payment_mode_id"];
    int paymentMode = patientService.payment_mode_id;
    if(paymentMode == 2 || paymentMode == 3){
        
        NSString *payment = [NSString stringWithFormat:@"%@$",patientService.amount];
        
        [parameter setObject:payment forKey:@"amount"];
    }
    else if(paymentMode == 8){
        patientService.amount = @"0";
        patientService.doctorPrice = @"0";
        patientService.couponCode = @"";
        patientService.couponPrice = @"0";
        [parameter setObject:@"0" forKey:@"amount"];
    }
    else{
        [parameter setObject:@"0$" forKey:@"amount"];
    }
    [parameter setObject:patientService.doctor_id forKey:@"doctor_id"];
    [parameter setObject:@"" forKey:@"appointment_slot_id"];
    [parameter setObject:patientService.couponCode forKey:@"coupan"];
    [parameter setObject:patientService.visit_type_id forKey:@"visit_type_id"];
    [parameter setObject:patientService.date forKey:@"date"];
    [parameter setObject:patientService.question_1 forKey:@"question_1"];
    [parameter setObject:strSymptom forKey:@"question_2"];
    [parameter setObject:patientService.question_1_option_value forKey:@"question_1_option_value"];
    [parameter setObject:patientService.member_name forKey:@"new_member_name"];
    [parameter setObject:[NSNumber numberWithInt:patientService.member_gender] forKey:@"new_member_gender"];
    [parameter setObject:patientService.member_dob forKey:@"new_member_dob"];
    [parameter setObject:patientService.question_3 forKey:@"question_3"];
    [parameter setObject:patientService.question_4 forKey:@"question_4"];
    [parameter setObject:patientService.question_5 forKey:@"question_5"];
    [parameter setObject:patientService.question_6 forKey:@"question_6"];
    [parameter setObject:patientService.question_7 forKey:@"question_7"];
    [parameter setObject:patientService.amount forKey:@"price"];
    [parameter setObject:patientService.couponPrice forKey:@"coupon_price"];
    [parameter setObject:patientService.doctorPrice forKey:@"doctor_price"];
    [parameter setObject:patientService.question_8_id forKey:@"question_8_id"];
    [parameter setObject:patientService.question_8_code forKey:@"question_8_code"];
    [parameter setObject:patientService.payment_status forKey:@"payment_status"];
    [parameter setObject:patientService.correlation_id forKey:@"correlation_id"];
    [parameter setObject:patientService.transaction_status forKey:@"transaction_status"];
    [parameter setObject:patientService.validation_status forKey:@"validation_status"];
    [parameter setObject:patientService.transaction_type forKey:@"transaction_type"];
    [parameter setObject:patientService.transaction_id forKey:@"transaction_id"];
    [parameter setObject:patientService.transaction_tag forKey:@"transaction_tag"];
    [parameter setObject:patientService.method forKey:@"method"];
    [parameter setObject:patientService.currency forKey:@"currency"];
    [parameter setObject:patientService.bank_resp_code forKey:@"bank_resp_code"];
    [parameter setObject:patientService.bank_message forKey:@"bank_message"];
    [parameter setObject:patientService.gateway_resp_code forKey:@"gateway_resp_code"];
    [parameter setObject:patientService.gateway_message forKey:@"gateway_message"];
    
    PatientAppointService *service = [[PatientAppointService alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service postAppointmentDetail:parameter andImageName:patientService.documentName andImages: patientService.arrDocumentData WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        if(!error) {
            @try {
                if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]) {
                    patientService.res_call_duration = [[responseCode valueForKey:@"data"] valueForKey:@"call_duration"];
                    patientService.res_doctor_address = [[responseCode valueForKey:@"data"] valueForKey:@"doctor_address"];
                    patientService.res_doctor_id = [[responseCode valueForKey:@"data"] valueForKey:@"doctor_id"];
                    patientService.res_doctor_name = [[responseCode valueForKey:@"data"] valueForKey:@"doctor_name"];
                    patientService.res_profile_pic = [[responseCode valueForKey:@"data"] valueForKey:@"profile_pic"];
                    patientService.res_session_id = [[responseCode valueForKey:@"data"] valueForKey:@"session_id"];
                    patientService.res_session_token = [[responseCode valueForKey:@"data"] valueForKey:@"session_token"];
                    patientService.res_visit_id = [[responseCode valueForKey:@"data"] valueForKey:@"visit_id"];
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    PatientVideoCallViewController *patientVideoCallVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PatientVideoCallViewController"];
                    [self.navigationController pushViewController:patientVideoCallVC animated:YES];
                }
                
            } @catch (NSException *exception) {
                [IODUtils showFCAlertMessage:@"Something went wrong."  withTitle:@"" withViewController:self with:@"error"];
            } @finally {
                
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];

    
}


- (void)getallReferralDoctor {
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *postparameter = [[NSMutableDictionary alloc]init];
    NSString *category =  patientService.selectedCategory;
    [parameter setObject:patientService.selectedCategoryName forKey:@"categoryname"];
    [parameter setObject:category forKey:@"categoryId"];
    [postparameter setObject:sortKey forKey:@"sort"];
    
    [postparameter setObject:sortGender forKey:@"gender"];
    [postparameter setObject:patientService.visit_type_id forKey:@"visit_type_id"];

    [service getAllReferralDoctor:parameter PostParameter:postparameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([[responseCode  valueForKey:@"status"] isEqualToString:@"success"]) {
            //NSLog(@"Referral Doctor ");
            arrOnlineDoctor = [responseCode valueForKey:@"data"];
            if(arrOnlineDoctor.count > 0){
            if ([arrOnlineDoctor isKindOfClass:[NSDictionary class]]) {
                if([arrOnlineDoctor valueForKey:@"error"])
                arrOnlineDoctor = [[NSMutableArray alloc] init];
            }
            else{
                searchResultsArray = arrOnlineDoctor;
            }
        }
            searchResultsArray = arrOnlineDoctor;
            //NSLog(@"array %@",arrOnlineDoctor);
            [self.tblDoctSearch reloadData];
            if(arrOnlineDoctor.count == 0) {
                [self.errorPage setHidden:NO];
                self.lblMessage.text = @"We are extremely sorry but there are currently no Doctors available in the selected Category available for booking an appointment.\n \nNo payment has been deducted at this point in time. \nPlease try again after some time. ";
                sortKey = @"";
                sortGender = @"";
                
                [_btnBookAppointment setHidden:YES];
                [_btnCancel setTitle:@"Go to Home" forState:UIControlStateNormal];
                [_btnCancel addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
                [self.view bringSubviewToFront:self.errorPage];
            }
            else
            {
                [self.errorPage setHidden:YES];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

-(void)getAllOnlineDoctors{
    CommonServiceHandler *service = [[CommonServiceHandler alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]  init];
    NSMutableDictionary *postparameter = [[NSMutableDictionary alloc]init];

    NSString *category =  patientService.selectedCategory;
    [parameter setObject:category forKey:@"categoryId"];
    [parameter setObject:patientService.selectedCategoryName forKey:@"categoryname"];
    [postparameter setObject:patientService.visit_type_id forKey:@"visit_type_id"];
    [postparameter setObject:@"" forKey:@"sort"];
    [postparameter setObject:@"" forKey:@"gender"];

    [service getAllOnlineDoctors:parameter PostParameter:postparameter  WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        arrOnlineDoctor =  [responseCode valueForKey:@"data"] ;
        
        if(arrOnlineDoctor.count > 0){
            if ([arrOnlineDoctor isKindOfClass:[NSDictionary class]]) {
                if([arrOnlineDoctor valueForKey:@"error"])
                    arrOnlineDoctor = [[NSMutableArray alloc] init];
            }
            else{
                searchResultsArray = arrOnlineDoctor;
            }
        }
        searchResultsArray = arrOnlineDoctor;
        //NSLog(@"array %@",arrOnlineDoctor);
        [self.tblDoctSearch reloadData];
        if(arrOnlineDoctor.count == 0) {
        [self.errorPage setHidden:NO];
             self.lblMessage.text = @"We are extremely sorry but all our Doctors are busy. No Payment has been deducted at this point in time. Book an Appointment or please try again after some time.";
            [_btnBookAppointment setHidden:NO];
            sortKey = @"";
            sortGender = @"";
            [_btnCancel setHidden:NO];
           
        [self.view bringSubviewToFront:self.errorPage];
        }
        else
        {
        [self.errorPage setHidden:YES];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(IBAction)bookAnAppointmentPressed:(id)sender {
    [_errorPage setHidden:YES];
    [self.view sendSubviewToBack:_errorPage];
    patientService.isFromliveCall = @"yes";
    patientService.visit_type_id = @"2";
    [self getallReferralDoctor];
}

-(IBAction)cancelPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
