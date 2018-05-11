//
//  AboutdoctorViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 1/8/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "AboutdoctorViewController.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HexString.h"
#import "ReviewCell.h"
#import "CommonServiceHandler.h"
#import "DoctorAppointmentServiceHandler.h"
#import "PatientAppointService.h"
#import "IODUtils.h"
#import "BookAppointmentVC.h"
#import "UIImageView+WebCache.h"
#import "PatientVideoCallViewController.h"
#import "PaymentViewController.h"


@interface AboutdoctorViewController ()
{
    NSMutableArray *arrReview;
    DoctorAppointmentServiceHandler *docService;
    PatientAppointService *patientService;
    int doctorPracticeCount;
    NSString *status;
}
@end

@implementation AboutdoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getallReviews];
    
    patientService = [PatientAppointService sharedManager];
    docService = [DoctorAppointmentServiceHandler sharedManager];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    
    if([patientService.visit_type_id isEqualToString:@"1"]){
        [_callNow setTitle:@"CALL NOW" forState:UIControlStateNormal];
    }
    
    else{
        [_callNow setTitle:@"BOOK NOW" forState:UIControlStateNormal];

    }
    UINib *nib = [UINib nibWithNibName:@"ReviewCell" bundle:[NSBundle mainBundle]];
    [[self tblReview] registerNib:nib forCellReuseIdentifier:@"ReviewCell"];
    
    // Do any additional setup after loading the view.
    _lblDoctorName.text = [NSString stringWithFormat:@"%@",[_userProfile valueForKey:kName]];
   _lblGender.text  = [NSString stringWithFormat:@"%@",[_userProfile valueForKey:kgender]];
    
    NSString *strLanguage = [_userProfile valueForKey:@"languages"];
    strLanguage = [_userProfile valueForKey:@"languages"];
    
    strLanguage = [strLanguage stringByReplacingOccurrencesOfString:@"," withString:@", "];
   _lblLanguage.text= [NSString stringWithFormat:@"%@ ",strLanguage];

    NSString *state =[NSString stringWithFormat:@"%@",[_userProfile valueForKey:@"state"]];
    NSString *country =[NSString stringWithFormat:@"%@",[_userProfile valueForKey:@"country"]];
    
    if([state isEqualToString:@"<null>"]){
        state = @"";
    }
    else{
        state = [state stringByAppendingString:@","];
    }
    
    _lblAddress.text = [NSString stringWithFormat:@"%@ %@",state,country];
    _lblExperience.text =[NSString stringWithFormat:@"%@ yrs. Exp",[_userProfile valueForKey:kexperience]];
    _lblQualification.text =[NSString stringWithFormat:@"%@", [[_userProfile valueForKey:kqualification] uppercaseString]];
   _lblSpecialization.text = [NSString stringWithFormat:@"%@",[_userProfile valueForKey:@"specialization"]];
    
    NSString *strCharge = [NSString stringWithFormat:@"%.2f %@",[[_userProfile valueForKey:@"price"] floatValue],[_userProfile valueForKey:@"currency"]];
    
    NSString *aboutme = [NSString stringWithFormat:@"%@",[_userProfile valueForKey:@"about_me"]];
    doctorPracticeCount =[[_userProfile valueForKey:@"practice_count"] intValue];
    
    strCharge =  [NSString stringWithFormat:@"%@",strCharge];
    if((patientService.isPracticeCallDone <= 0) && (doctorPracticeCount > 0)){
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:strCharge];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@9
                                range:NSMakeRange(0, [attributeString length])];
        [attributeString addAttribute:NSStrikethroughColorAttributeName
                                value:[UIColor redColor]
                                range:NSMakeRange(0, [attributeString length])];
        [ _lblCharge setAttributedText:attributeString];
        [_lblPromoCode setHidden:NO];
    }
    else{
        [_lblPromoCode setHidden:YES];
        _lblCharge.text =  [NSString stringWithFormat:@"%@ /Consult",strCharge];
    }
    
    if([aboutme isEqualToString:@"<null>"]){
        aboutme = @"";
    }
    _txtAboutMe.text =aboutme;
    NSString *rate = [NSString stringWithFormat:@"%@",[_userProfile valueForKey:@"rating"]];
    if([rate isEqualToString:@"<null>"]){
        rate = @"";
    }
    _lblTotalRating.text = rate;
    
   // _lblTotalRating.text = [[_userProfile valueForKey:@"about_me"]];
     NSString *strProfilePic = [NSString stringWithFormat:@"%@",[_userProfile valueForKey:@"profile_pic"]];
    
    _imgProfile.frame =CGRectMake( _imgProfile.frame.origin.x, _imgProfile.frame.origin.y, 85, 85);
    
    [_imgProfile sd_setImageWithURL:[NSURL URLWithString:strProfilePic] placeholderImage:[UIImage imageNamed:@"doc-Aboutme.png"]];
    [_imgProfile.layer setCornerRadius:_imgProfile.frame.size.height/2];
    _imgProfile.clipsToBounds = YES;
    [_imgProfile.layer setBorderWidth:3.0];
    [_imgProfile.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    NSString *rat = [_userProfile valueForKey:@"rating_avg"];
    [self.ratingview setRating:[rat floatValue]];
    
    [_ratingview setStarFillColor:[UIColor yellowColor]];
    [_callNowview.layer setBorderWidth:2.0];
    [_callNowview.layer setBorderColor:[UIColor colorWithHexRGB:kNavigatinBarColor].CGColor];
}

-(IBAction)CallNowPressed:(id)sender{
    docService.isCallInterrupted = @"no";
    patientService.amount = [_userProfile valueForKey:@"price"];
    
    NSString *amount =  [NSString stringWithFormat:@"%.2f",[[_userProfile valueForKey:@"price"] floatValue]];
    patientService.amount = amount;
    
    patientService.selectedDoctorCountry =[NSString stringWithFormat:@"%@",[_userProfile valueForKey:@"country"]];
    patientService.usdPrice =[NSString stringWithFormat:@"%@",[_userProfile valueForKey:@"usd_price"]];

    patientService.strCurrency = [NSString stringWithFormat:@"%@",[_userProfile valueForKey:@"currency"]];
    
    patientService.currency = [NSString stringWithFormat:@"%@",[_userProfile valueForKey:@"currency"]];
    patientService.doctorPrice = [NSString stringWithFormat:@"%.2f",[[_userProfile valueForKey:@"doctor_price"] floatValue]];
    NSString *doctorId = [_userProfile valueForKey:@"id"];
    patientService.doctor_id = doctorId;

    //Check if it is a Practice call
    if((patientService.isPracticeCallDone <= 0) && (doctorPracticeCount > 0)){
        if([patientService.visit_type_id isEqualToString:@"1"]){
            patientService.payment_mode_id = 8;
          //  [self PostData];
            
            [self updateDoctorStatus];
        }
        else  if([patientService.visit_type_id isEqualToString:@"2"]){
            patientService.payment_mode_id = 8;
            patientService.doctorPracticeCount =doctorPracticeCount;
            
            BookAppointmentVC *bookAppointmentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BookAppointmentVC"];
            [self.navigationController pushViewController:bookAppointmentVC animated:YES];
            
        }
    }
    else{
        if([patientService.visit_type_id isEqualToString:@"1"]) {
            
            PaymentViewController *pvc =  [self.storyboard instantiateViewControllerWithIdentifier:@"paymentViewController"];
            [self.navigationController pushViewController:pvc animated:YES];
            //    [self PostData];
        }
        else  if([patientService.visit_type_id isEqualToString:@"2"]) {
            BookAppointmentVC *bookAppointmentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BookAppointmentVC"];
            [self.navigationController pushViewController:bookAppointmentVC animated:YES];
        }
        else{
            BookAppointmentVC *bookAppointmentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BookAppointmentVC"];
            [self.navigationController pushViewController:bookAppointmentVC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath * )indexPath
{
    return  UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrReview.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReviewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
//    NSString *strAge =[[memberArray objectAtIndex:indexPath.row]valueForKey:@"dob"];
//    
//    cell.lblTitle.text = [[memberArray objectAtIndex:indexPath.row]valueForKey:@"name"];
//    NSInteger age = [IODUtils calculateAge:strAge];
//    strAge = [NSString stringWithFormat:@"Age: %ld",(long)age];
//    [cell.btnAge.layer setCornerRadius:15.0];
//    [cell.btnAge setTitle:strAge forState:UIControlStateNormal];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.lblName.text = [[arrReview objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.reviewDate.text = [[arrReview objectAtIndex:indexPath.row] valueForKey:@"created_dt"];
    cell.lblComment.text  = [[arrReview objectAtIndex:indexPath.row] valueForKey:@"feedback"];
    
    NSString *strProfilePic = [NSString stringWithFormat:@"%@",[[arrReview objectAtIndex:indexPath.row] valueForKey:@"profile_pic"]];
    if ([strProfilePic isEqual:[NSNull null]])
        strProfilePic = @"";
    cell.imgProfile.clipsToBounds = YES;
    [cell.imgProfile.layer setCornerRadius:cell.imgProfile.frame.size.width/2];

    [cell.imgProfile sd_setImageWithURL:[NSURL URLWithString:strProfilePic] placeholderImage:[UIImage imageNamed:@"D-calling-icon.png"]];
    NSString *rat = [NSString stringWithFormat:@"%@",[[arrReview objectAtIndex:indexPath.row] valueForKey:@"rating"] ];
    
    if([rat isEqualToString:@"<null>"]){
        rat = @"";
    }
    [cell.rateV setRating:[rat floatValue]];
    return cell;
}
- (void)getallReviews{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:[_userProfile valueForKey:@"id"] forKey:@"doctorid"];
    CommonServiceHandler *service = [[CommonServiceHandler alloc]init];
   [service getAllReviews:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
       arrReview =  [responseCode valueForKey:@"data"];
       UILabel *lblNoData = [[UILabel alloc]init];
       lblNoData.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30) ;
       lblNoData.center = self.view.center;
       lblNoData.text = @"";
       [self.view addSubview:lblNoData];
       [lblNoData setHidden:YES];
       if([arrReview count]>0){
           [_tblReview setHidden:NO];
           [lblNoData setHidden:YES];
           [self.tblReview reloadData];
       }
       else{
           [lblNoData setHidden:NO];
           [_tblReview setHidden:YES];
       }
    }];
}



-(void)PostData {
    NSString *strSymptom = UDGet(@"SelectedSymptoms");
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:patientService.doctor_id forKey:kdoctor_id];
    [parameter setObject:@"" forKey:kappointment_slot_id];
    [parameter setObject:@"" forKey:ktime_slot_id];
    [parameter setObject:patientService.visit_type_id forKey:kvisit_type_id];
    [parameter setObject:patientService.date forKey:kdate];
    [parameter setObject:patientService.question_1 forKey:kquestion_1];
    [parameter setObject:@"0" forKey:@"price"];
    [parameter setObject:@"0" forKey:@"coupon_price"];
    [parameter setObject:@"0" forKey:@"doctor_price"];
    [parameter setObject:patientService.couponCode forKey:@"coupan"];
    
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
    [parameter setObject:[NSString stringWithFormat:@"%@",@"0"] forKey:kamount];
    [parameter setObject:patientService.currency forKey:kcurrency];
    [parameter setObject:patientService.bank_resp_code forKey:kbank_resp_code];
    [parameter setObject:patientService.bank_message forKey:kbank_message];
    [parameter setObject:patientService.gateway_resp_code forKey:kgateway_resp_code];
    [parameter setObject:patientService.gateway_message forKey:kgateway_message];
    
    
    NSLog(@"PArameter for post %@",parameter);
    PatientAppointService *service = [[PatientAppointService alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service postAppointmentDetail:parameter andImageName:patientService.documentName andImages: patientService.arrDocumentData WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        //NSLog(@"Response");
        if(!error) {
            //if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]) {
            patientService.res_call_duration = [[responseCode valueForKey:@"data"] valueForKey:@"call_duration"];
            patientService.res_doctor_address = [[responseCode valueForKey:@"data"] valueForKey:@"doctor_address"];
            patientService.res_doctor_id = [[responseCode valueForKey:@"data"] valueForKey:@"doctor_id"];
            patientService.res_doctor_name = [[responseCode valueForKey:@"data"] valueForKey:@"doctor_name"];
            patientService.res_profile_pic = [[responseCode valueForKey:@"data"] valueForKey:@"profile_pic"];
            patientService.res_session_id = [[responseCode valueForKey:@"data"] valueForKey:@"session_id"];
            patientService.res_session_token = [[responseCode valueForKey:@"data"] valueForKey:@"session_token"];
            patientService.res_visit_id = [[responseCode valueForKey:@"data"] valueForKey:@"visit_id"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //  }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            PatientVideoCallViewController *patientVideoCallVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PatientVideoCallViewController"];
            [self.navigationController pushViewController:patientVideoCallVC animated:YES];
            
        }
    
    }];
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
    
    [service updateStatus:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        if(error){
            if([[error valueForKey:@"status"] isEqualToString:@"fail"]){
                
                [IODUtils showFCAlertMessage:[error valueForKey:@"message"]  withTitle:@"" withViewController:self with:@"error"];
                
            }
        }
        else{
            // check doctor id here
            if([patientService.visit_type_id isEqualToString:@"1"]){
                [self PostData];
            }
            else{
                BookAppointmentVC *bookAppointmentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BookAppointmentVC"];
                [self.navigationController pushViewController:bookAppointmentVC animated:YES];
            }
        }
    }];
}

-(void)refreshView:(NSNotification*)notification{
    [self getallReviews];
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}


@end
