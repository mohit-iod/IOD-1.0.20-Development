
//
//  PaymentViewController.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/7/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "PaymentViewController.h"
#import "PayeezySDK.h"
#import "IODUtils.h"
#import "NTMonthYearPicker.h"
#import "PatientAppointService.h"
#import "SuccessfulPaymentViewController.h"
#import "CommonServiceHandler.h"
#import "UIColor+HexString.h"
#import "PaymentCurrencyViewController.h"
#import "PatientVideoCallViewController.h"
#import "CouponPaymentViewController.h"


@interface PaymentViewController ()<UITextFieldDelegate, StringPickerViewDelegate> {
    NTMonthYearPicker *yearPicker;
    PatientAppointService *patientService;
    int selectedoption;
    int isCouponPressed;
    NSString *selectedDoctorCountry;
    NSString *myCountry;
}
@end

@implementation PaymentViewController

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    patientService = [PatientAppointService sharedManager];

    
    selectedDoctorCountry = [NSString stringWithFormat:@"%@",patientService.selectedDoctorCountry];
    myCountry =[NSString stringWithFormat:@"%@",UDGet(@"country")];
    if(([selectedDoctorCountry caseInsensitiveCompare :@"India" ] == NSOrderedSame) && ([myCountry caseInsensitiveCompare :@"India" ] == NSOrderedSame)) {
        [_creditCardView setHidden:YES];
        patientService.payment_mode_id = 6;
        
    }
    else{
        [_creditCardView setHidden:NO];
        patientService.payment_mode_id = 1;
    }
    
    [self setYearPicker];
    [_couponCodeView setHidden:YES];
    self.title = @"Payment";
    
    NSString *amount =  [NSString stringWithFormat:@"%.2f ",[patientService.amount floatValue]];
    _lblAmount.text = [NSString stringWithFormat:@"%@ %@",amount, patientService.currency];
    
    _txtamount.text = [NSString stringWithFormat:@"%@ %@", amount, patientService.currency];
    
   // patientService.amount = [patientService.amount stringByReplacingOccurrencesOfString:@"$" withString:@""];
    //LIVE
    patientService.paymentToken =     @"fdoa-abe5329bdca28068fb315dbc8cec1383abe5329bdca28068";
    
    //DEBUG
    //patientService.paymentToken = @"fdoa-541a6d7acb15a72a76023de33eb0689b541a6d7acb15a72a";
    
    patientService.merchantId =  @"372275578881";
    patientService.Currencyid =@"USD";
    [_btnRemoveCouponPayment setHidden:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    
    if( patientService.payment_mode_id == 4){
        [_btnApplyCoupon setTitle:patientService.couponMessage forState:UIControlStateNormal];
        if(patientService.payment_mode_id == 4){
            [_btnRemoveCouponPayment setHidden:NO];
            
            float amountpay = [patientService.amount floatValue];
            float couponPrice = [patientService.couponPrice floatValue];
            float priceToPay =[patientService.price floatValue];
            NSString *strMessage = [NSString stringWithFormat:@"Proceed To Pay %.2f %@",priceToPay,patientService.strCurrency];
            
            if(priceToPay > 0){
                [_btnCouponPayment setTitle:strMessage forState:UIControlStateNormal];
            }
            else{
                if([patientService.visit_type_id isEqualToString:@"1"])
                {
                    [_btnCouponPayment setTitle:@"CALL NOW" forState:UIControlStateNormal];
                 }
                else {
                    [_btnCouponPayment setTitle:@"BOOK NOW" forState:UIControlStateNormal];
                }
                [_creditCardView setHidden:YES];
            }
            NSLog(@"float amount is %2f",priceToPay);
        }
    }
    else if (patientService.payment_mode_id == 3){
        
        NSString *txtfreeCoupon  = [NSString stringWithFormat:@"Awesome! The coupon %@  applied successfully",patientService.couponCode];
        
        [_btnApplyCoupon setTitle:txtfreeCoupon forState:UIControlStateNormal];
        
        if([patientService.visit_type_id isEqualToString:@"1"])
        {
            [_btnCouponPayment setTitle:@"CALL NOW" forState:UIControlStateNormal];
        }
        else {
            [_btnCouponPayment setTitle:@"BOOK NOW" forState:UIControlStateNormal];
        }
        
        [_btnRemoveCouponPayment setHidden:NO];
        [_creditCardView setHidden:YES];
    }
    else if (patientService.payment_mode_id == 2){
        NSString *txtfreeCoupon  = [NSString stringWithFormat:@"Awesome! The coupon %@  applied successfully",patientService.couponCode];
        
        [_btnApplyCoupon setTitle:txtfreeCoupon forState:UIControlStateNormal];
        
        if([patientService.visit_type_id isEqualToString:@"1"])
        {
            [_btnCouponPayment setTitle:@"CALL NOW" forState:UIControlStateNormal];
        }
        else {
            [_btnCouponPayment setTitle:@"BOOK NOW" forState:UIControlStateNormal];
        }
        
        [_btnRemoveCouponPayment setHidden:NO];
        [_creditCardView setHidden:YES];

    }
    else if (patientService.payment_mode_id == 5){
        float amountpay = [patientService.amount floatValue];
        float couponPrice = [patientService.couponPrice floatValue];
        float priceToPay =[patientService.price floatValue];
        NSString *strMessage = [NSString stringWithFormat:@"Proceed To Pay %.2f %@",priceToPay,patientService.strCurrency];
        NSString *txtfreeCoupon  = [NSString stringWithFormat:@"Awesome! The coupon %@  applied successfully",patientService.couponCode];
        [_btnRemoveCouponPayment setHidden:NO];

        [_btnApplyCoupon setTitle:txtfreeCoupon forState:UIControlStateNormal];
        if(priceToPay > 0){
            [_btnCouponPayment setTitle:strMessage forState:UIControlStateNormal];
        }
        else{
            if([patientService.visit_type_id isEqualToString:@"1"])
            {
                [_btnCouponPayment setTitle:@"CALL NOW" forState:UIControlStateNormal];
            }
            else {
                [_btnCouponPayment setTitle:@"BOOK NOW" forState:UIControlStateNormal];
            }
            [_creditCardView setHidden:YES];
        }
        NSLog(@"float amount is %2f",priceToPay);
    }
 
    else if (patientService.payment_mode_id == 7){
        NSString *txtfreeCoupon  = [NSString stringWithFormat:@"Awesome! The coupon %@  applied successfully",patientService.couponCode];
        
        [_btnApplyCoupon setTitle:txtfreeCoupon forState:UIControlStateNormal];
        
        if([patientService.visit_type_id isEqualToString:@"1"])
        {
            [_btnCouponPayment setTitle:@"CALL NOW" forState:UIControlStateNormal];
        }
        else {
            [_btnCouponPayment setTitle:@"BOOK NOW" forState:UIControlStateNormal];
        }
        
        [_btnRemoveCouponPayment setHidden:NO];
        [_creditCardView setHidden:YES];
        
    }
    
    else {
        [_btnApplyCoupon setTitle:@"APPLY COUPON CODE" forState:UIControlStateNormal];
        
        NSString *amount =  [NSString stringWithFormat:@"%.2f ",[patientService.amount floatValue]];
        
        NSString *strMessage = [NSString stringWithFormat:@"Proceed To Pay %@ %@",amount,patientService.strCurrency];
        [_btnCouponPayment setTitle:strMessage forState:UIControlStateNormal];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    NSLog(@"View did appear");
}
#pragma mark Year Picker
// Initialize the picker
- (void) setYearPicker {
    yearPicker = [[NTMonthYearPicker alloc] init];
    [yearPicker addTarget:self action:@selector(onDatePicked:) forControlEvents:UIControlEventValueChanged];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *cal = [NSCalendar currentCalendar];
    yearPicker.datePickerMode = NTMonthYearPickerModeMonthAndYear;
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:1907];
    yearPicker.minimumDate = [cal dateFromComponents:comps];
    [comps setDay:0];
    [comps setMonth:1];
    [comps setYear:0];
    
    [comps setDay:0];
    [comps setMonth:-1];
    [comps setYear:0];
    yearPicker.date = [cal dateByAddingComponents:comps toDate:[NSDate date] options:0];
}

- (void)onDatePicked:(UITapGestureRecognizer *)gestureRecognizer {
    [self updateLabel];
}

#pragma mark Payment Methods
- (IBAction)Next:(id)sender{
    if(patientService.payment_mode_id == 1){
        if (![IODUtils getError:self.txtName minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:YES canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){}
        else if(![IODUtils getError:self.txtCardType minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
        }
        else if(![IODUtils getError:self.txtCardNumber minVlue:@"13" minVlue:@"20" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
        }
        else if(![IODUtils getError:self.txtExpiryDate minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
        }
        else if(![IODUtils getError:self.txtCvv minVlue:@"3" minVlue:@"4" onlyNumeric:YES onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
        }
        else{
            Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
            BOOL reachable = reach. isReachable;
            if (reachable) {
                [self performPayment];
            }
            else{
                //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
            }
        }
    }
    else if (patientService.payment_mode_id == 2){
       
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        if (reachable) {
            if([patientService.visit_type_id isEqualToString:@"1"]){
                [self PostData];
            }
            else {
                [self PostDataForApppointment];
            }
        }
        else{
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        }
    }
    else if (patientService.payment_mode_id == 3){
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        if (reachable) {
            if([patientService.visit_type_id isEqualToString:@"1"]){
                [self PostData];
            }
            else {
                [self PostDataForApppointment];
            }
        }
        else{
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        }
    }
    else if (patientService.payment_mode_id == 4){
        if (![IODUtils getError:self.txtName minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:YES canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){}
        else if(![IODUtils getError:self.txtCardType minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
        }
        else if(![IODUtils getError:self.txtCardNumber minVlue:@"13" minVlue:@"20" onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
        }
        else if(![IODUtils getError:self.txtExpiryDate minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
        }
        else if(![IODUtils getError:self.txtCvv minVlue:@"3" minVlue:@"4" onlyNumeric:YES onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
        }
        else{
            Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
            BOOL reachable = reach. isReachable;
            if (reachable) {
                [self performPayment];
            }
            else{
                //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
            }
        }
        
    }
    else if (patientService.payment_mode_id == 5){
      
        [self verifyChecksum];
    }
    else if (patientService.payment_mode_id == 6){
        [self verifyChecksum];
    }
    else if (patientService.payment_mode_id == 7){
        
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        if (reachable) {
            if([patientService.visit_type_id isEqualToString:@"1"]){
                [self PostData];
            }
            else {
                [self PostDataForApppointment];
            }
        }
        else{
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        }
    }
}

- (void)performPayment{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strCardNumber = _txtCardNumber.text;
    strCardNumber = [strCardNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *strExpiryDate =[_txtExpiryDate.text stringByReplacingOccurrencesOfString:@"/" withString:@""];
    self.icredit_card = [[NSMutableDictionary alloc] init];
    [self.icredit_card setObject:_txtCardType.text forKey:@"type"];
    [self.icredit_card setObject:_txtName.text forKey:@"cardholder_name"];
    [self.icredit_card setObject:strCardNumber forKey:@"card_number"];
    [self.icredit_card setObject:strExpiryDate forKey:@"exp_date"];
    [self.icredit_card setObject:_txtCvv.text forKey:@"cvv"];
    if(_fdTokenValue){
        [self preAuthorizeCard];
    }
    else {
        [self getToken];
    }
}

-(void)getToken {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Test credit card info
   /* NSDictionary* tokenizer = @{
                                @"type":@"FDToken",  // you can change to Amex/Discover/Master Card here
                                @"auth":@"true",
                                @"ta_token":@"NOIW"   // to fetch ta_token please refer developer.payeezy
                                };
    */
    //LIVE
    
    
   NSDictionary* tokenizer = @{
                                @"type":@"FDToken",  // you can change to Amex/Discover/Master Card here
                                @"auth":@"true",
                                @"ta_token":@"NIQE"   // to fetch ta_token please refer developer.payeezy
                                };
    
    
   
    //NIQE
    
     NSDictionary* credit_card = self.icredit_card ;
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:patientService.paymentToken url:KURL];
   
    [myClient submitPostFDTokenForCreditCard:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] type: tokenizer[@"type"] auth:tokenizer[@"auth"] ta_token:tokenizer[@"ta_token"] completion:^(NSDictionary *dict, NSError *error)
     {
         NSString *authStatusMessage = nil;
       
         /*if(error){
             [MBProgressHUD hideHUDForView:self.view animated:YES];

             [IODUtils showMessage:[error description] withTitle:@"Error"];

             
         }
         */
         
         
      //   else
         
         {
             if([[dict valueForKey:@"status"] isEqualToString:@"success"]) {
                 NSDictionary *result = [dict objectForKey:@"token"];
                 self.fdTokenValue =[result objectForKey:@"value"];
                 [[NSUserDefaults standardUserDefaults] setValue:self.fdTokenValue forKey:@"fdtoken"];
                 [[NSUserDefaults standardUserDefaults]setObject:credit_card forKey:@"ccdetails"];
                 if([patientService.visit_type_id isEqualToString:@"1"])
                     [self preAuthorizeCard];
                 else if ([patientService.visit_type_id isEqualToString:@"2"])
                     [self creditCardPayment];
                 else if ([patientService.visit_type_id isEqualToString:@"3"])
                     [self creditCardPayment];
             }
             else {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 authStatusMessage = [NSString stringWithFormat:@"%@",[[[error.userInfo valueForKey:@"Error"] valueForKey:@"messages"]valueForKey:@"description"]];
                 authStatusMessage = [authStatusMessage stringByReplacingOccurrencesOfString:@"(" withString:@""];
                 authStatusMessage = [authStatusMessage stringByReplacingOccurrencesOfString:@")" withString:@""];
                 
                 if([authStatusMessage containsString:@"GATEWAY:CVV2/CID/CVC2 Data not Verified"]) {
                     authStatusMessage = @"Incorrect CVV / Expiry date. Please re-enter.";
                 }
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:authStatusMessage delegate:self
                                                       cancelButtonTitle:@"Dismiss"
                                                       otherButtonTitles:nil];
                 alert.tag = 2;
                 [alert show];
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             }
         }
         
     }];
}
- (void)preAuthorizeCard{
    // Test credit card info
    NSDictionary* credit_card = self.icredit_card ;
    
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:patientService.paymentToken  url:PURL];
    [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:self.fdTokenValue cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:patientService.Currencyid totalAmount:@"0" merchantRef:patientService.merchantId  transactionType:@"authorize" token_type:@"FDToken" method:@"token" completion:^(NSDictionary *dict, NSError *error)
     {
         NSString *authStatusMessage = nil;
         if (error == nil)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             authStatusMessage = [NSString stringWithFormat:@"Payment is Pre-Authorized at this time. Payment will be deducted upon video call start." ];
             
             patientService.payment_status=@"Pre-Authorize";
             patientService.correlation_id = @"";
             patientService.transaction_status = [dict objectForKey:@"transaction_status"];
             patientService.transaction_type =[dict objectForKey:@"transaction_type"];
             patientService.correlation_id  = [dict objectForKey:@"correlation_id"];
             patientService.transaction_id = [dict objectForKey:@"transaction_id"];
             patientService.validation_status = [dict objectForKey:@"validation_status"];
             patientService.transaction_tag = [dict objectForKey:@"transaction_tag"];
             patientService.method = [dict objectForKey:@"method"];
             patientService.amount = patientService.amount;
             patientService.currency = [dict objectForKey:@"currency"];
             patientService.bank_resp_code = [dict objectForKey:@"bank_resp_code"];
             patientService.bank_message = [dict objectForKey:@"bank_message"];
             patientService.gateway_resp_code = [dict objectForKey:@"gateway_resp_code"];
             patientService.gateway_message = [dict objectForKey:@"gateway_message"];
             //[self creditCardPayment];
             if([[dict objectForKey:@"bank_message"] isEqualToString:@"Approved"]) {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pre Authorization "
                                                                 message:authStatusMessage delegate:self
                                                       cancelButtonTitle:@"Call Now"
                                                       otherButtonTitles:nil];
                 alert.tag = 1;
                 [alert show];
             }
             else {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pre Authorization "
                                                                 message:[dict objectForKey:@"bank_message"] delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 alert.tag = 0;
                 [alert show];
                 
             }
           
         }
         else
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];

             authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
                         //[self creditCardPayment];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pre Authorization "
                                                             message:authStatusMessage delegate:self
                                                   cancelButtonTitle:@"Dismiss"
                                                   otherButtonTitles:nil];
             alert.tag = 2;
             [alert show];
         }
     }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if(alertView.tag == 1) {
       //  [[NSNotificationCenter defaultCenter] postNotificationName:@"ForceUpdateLocation" object:self userInfo:[NSDictionary dictionaryWithObject:@"3" forKey:@"pnumb"]];
        [self PostLiveCallData];
    }
}

-(void)PostLiveCallData {
    
    NSString *strSymptom = UDGet(@"SelectedSymptoms");

    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
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
    [parameter setObject:patientService.question_8_code forKey:@"question_8_code"];
    [parameter setObject:patientService.question_8_id forKey:@"question_8_id"];

    [parameter setObject:patientService.amount forKey:@"price"];
    [parameter setObject:patientService.couponPrice forKey:@"coupon_price"];
    [parameter setObject:patientService.doctorPrice forKey:@"doctor_price"];
    
    [parameter setObject:[NSNumber numberWithInt:patientService.payment_mode_id] forKey:@"payment_mode_id"];
    int paymentMode = patientService.payment_mode_id;
    if(paymentMode == 2 || paymentMode == 3){
        
        NSString *payment = [NSString stringWithFormat:@"%@$",patientService.amount];
        
        [parameter setObject:payment forKey:@"amount"];
    }

    else{
        [parameter setObject:@"0$" forKey:@"amount"];
    }
    
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
                
                [IODUtils showMessage:@"Something went wrong." withTitle:@"Error"];
            } @finally {
                
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
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
    if (textField == self.txtCardType) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
            NSDictionary *dictgender = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"CreditcardType" ofType:@"json"]];
            NSArray *gender= [dictgender valueForKey:@"CreditCard"];
            self.pickerView.data = gender;
            self.pickerView.delegate = self;
            self.pickerView.preSelectedValue = textField.text;
            self.pickerView.refernceView = textField;
            [self.view.window addSubview:self.pickerView];;
            return NO;
        }
        return NO;
    }
    else if (textField == self.txtExpiryDate){
        
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
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField == _txtCardNumber){
        // All digits entered
        if (range.location == 19) {
            return NO;
        }
        
        // Reject appending non-digit characters
        if (range.length == 0 &&
            ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
            return NO;
        }
        
        // Auto-add hyphen before appending 5rd or 8th digit
        if (range.length == 0 &&
            (range.location == 4 || range.location == 9 || range.location == 14)) {
            textField.text = [NSString stringWithFormat:@"%@-%@", textField.text, string];
            return NO;
        }
        
        // Delete hyphen when deleting its trailing digit
        if (range.length == 1 &&
            (range.location == 4 || range.location == 9))  {
            range.location--;
            range.length = 2;
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
        
        return YES;
        
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - StringPickerViewDelegate
- (void)stringPickerViewDidSelectDone:(StringPickerView *)view
{
    if( [self.pickerView.refernceView isKindOfClass:[UITextField class]] )
    {
        UITextField *textField = (UITextField*)view.refernceView;
        if(textField == _txtCardType){
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

#pragma mark - Date Picker
-(void)onDoneButtonYearPicker
{
    [self updateLabel];
    [self.txtExpiryDate resignFirstResponder];
}

-(void)onCancelButtonYearPicker {
    [self.txtExpiryDate resignFirstResponder];
    [_datePickerView removeFromSuperview];
}

- (void)updateLabel {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/YY"];
    NSString *dateStr = [df stringFromDate:yearPicker.date];
    _txtExpiryDate.text = [NSString stringWithFormat:@"%@", dateStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCouponCodePressed:(id)sender {
    isCouponPressed = 1;
    [self.couponCodeView setHidden:NO];
    [self.creditCardView setHidden:YES];
}

-(IBAction)btnCreditCardPressed:(id)sender {
    isCouponPressed = 0;
    [self.couponCodeView setHidden:YES];
    [self.creditCardView setHidden:NO];
}

-(IBAction)previousPressed:(id)sender{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"ForceUpdateLocation" object:self userInfo:@{@"pnumb":@"2",@"direction":@"back"}];
}

-(void)creditCardPayment{
    // Test credit card info
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
        NSDictionary* credit_card = [[NSUserDefaults standardUserDefaults]objectForKey:@"ccdetails"] ;
        NSString *strtoken = [[NSUserDefaults standardUserDefaults]valueForKey:@"fdtoken"];
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:patientService.paymentToken  url:PURL];
       //patientService.amount
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:2];
        [formatter setRoundingMode: NSNumberFormatterRoundUp];
        
        NSString *numberString;
        if(patientService.payment_mode_id == 4) {
           numberString = [NSString stringWithFormat:@"%@", patientService.price];
        }
        else {
           numberString = [NSString stringWithFormat:@"%@", patientService.amount];
        }
        NSLog(@"Result...%@",numberString);//Result 22.37
        float amt = [numberString floatValue];
        
        int   amount = amt * 100;
        
        
        NSString *stramt = [NSString stringWithFormat:@"%d",amount];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:strtoken cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:patientService.Currencyid totalAmount:stramt merchantRef:patientService.merchantId   transactionType:@"purchase" token_type:@"FDToken" method:@"token" completion:^(NSDictionary *dict, NSError *error)
         {
             NSString *authStatusMessage = nil;
             if (error == nil)
             {
                 authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                      [dict objectForKey:@"transaction_type"],
                                      [dict objectForKey:@"transaction_tag"],
                                      [dict objectForKey:@"correlation_id"],
                                      [dict objectForKey:@"bank_resp_code"],
                                      [dict objectForKey:@"transaction_status"] ];

                 patientService.payment_status=@"Authorize";
                 patientService.correlation_id = @"";
                 patientService.transaction_status = [dict objectForKey:@"transaction_status"];
                 patientService.transaction_type =[dict objectForKey:@"transaction_type"];
                 patientService.correlation_id  = [dict objectForKey:@"correlation_id"];
                 patientService.transaction_id = [dict objectForKey:@"transaction_id"];
                 patientService.validation_status = [dict objectForKey:@"validation_status"];
                 patientService.transaction_tag = [dict objectForKey:@"transaction_tag"];
                 patientService.method = [dict objectForKey:@"method"];
                 patientService.amount = patientService.amount;
                 patientService.currency = [dict objectForKey:@"currency"];
                 patientService.bank_resp_code = [dict objectForKey:@"bank_resp_code"];
                 patientService.bank_message = [dict objectForKey:@"bank_message"];
                 patientService.gateway_resp_code = [dict objectForKey:@"gateway_resp_code"];
                 patientService.gateway_message = [dict objectForKey:@"gateway_message"];
                 
                 if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                     [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"ccdetails"];
                     [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"fdtoken"];
                 }
                 if(![[dict objectForKey:@"bank_message"] isEqualToString:@"Approved"]) {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment fail"
                                                                     message:[dict objectForKey:@"bank_message"] delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                     alert.tag = 0;
                     [alert show];
                     [MBProgressHUD hideHUDForView:self.view animated:YES];

                 }
                 else {
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     
                     if([patientService.visit_type_id isEqualToString:@"2"])
                         [self PostDataForApppointment];
                     if([patientService.visit_type_id isEqualToString:@"3"])
                         [self PostDataForApppointment];
                 }
             }
             else
             {
                 authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                                 message:authStatusMessage delegate:self
                                                       cancelButtonTitle:@"Dismiss"
                                                       otherButtonTitles:nil];
                 alert.tag = 2;
                 
                 [alert show];
                 
                 
             }
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];
    }
    else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}

//Live call
-(void)PostData {
    NSString *strSymptom = UDGet(@"SelectedSymptoms");
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:patientService.doctor_id forKey:kdoctor_id];
    [parameter setObject:@"" forKey:kappointment_slot_id];
    [parameter setObject:@"" forKey:ktime_slot_id];
    [parameter setObject:patientService.visit_type_id forKey:kvisit_type_id];
    [parameter setObject:patientService.date forKey:kdate];
    [parameter setObject:patientService.question_1 forKey:kquestion_1];
    [parameter setObject:patientService.amount forKey:@"price"];
    [parameter setObject:patientService.couponPrice forKey:@"coupon_price"];
    [parameter setObject:patientService.doctorPrice forKey:@"doctor_price"];
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
    [parameter setObject:[NSString stringWithFormat:@"%@$",@"0"] forKey:kamount];
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
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //  }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        PatientVideoCallViewController *patientVideoCallVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PatientVideoCallViewController"];
        [self.navigationController pushViewController:patientVideoCallVC animated:YES];
        
        NSLog(@"Successfully done");
    }];
}



//book an appointment
-(void)PostDataForApppointment{
    int slotid =[patientService.slot_id intValue];
    NSString *slots = patientService.slot_id;
    if([patientService.visit_type_id isEqualToString:@"3"]){
    }
    
    NSString *numberString = [NSString stringWithFormat:@"%@", patientService.amount];
    NSLog(@"Result...%@",numberString);//Result 22.37
    float amt = [numberString floatValue];
    NSString *stramt = [NSString stringWithFormat:@"%.2f",amt];
    
    patientService.amount = stramt;
    NSString *strSymptom = UDGet(@"SelectedSymptoms");

    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:patientService.doctor_id forKey:kdoctor_id];
    [parameter setObject:patientService.amount forKey:@"price"];
    [parameter setObject:patientService.couponPrice forKey:@"coupon_price"];
    [parameter setObject:slots forKey:ktime_slot_id];

    [parameter setObject:patientService.doctorPrice forKey:@"doctor_price"];
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
    [parameter setObject:[NSString stringWithFormat:@"%@",patientService.amount] forKey:kamount];
    
    [parameter setObject:patientService.currency forKey:kcurrency];
    [parameter setObject:patientService.bank_resp_code forKey:kbank_resp_code];
    [parameter setObject:patientService.bank_message forKey:kbank_message];
    [parameter setObject:patientService.gateway_resp_code forKey:kgateway_resp_code];
    [parameter setObject:patientService.gateway_message forKey:kgateway_message];
    [parameter setObject:patientService.amount forKey:@"price"];
    [parameter setObject:patientService.couponPrice forKey:@"coupon_price"];
    [parameter setObject:patientService.doctorPrice forKey:@"doctor_price"];
    

    //mit - New (Change method name)
    PatientAppointService *service = [[PatientAppointService alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service bookAppointment:parameter andImageName:patientService.documentName andImages:patientService.arrDocumentData dataType:patientService.arrDocType WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //NSLog(@"RESPONSE");
        if(responseCode ) {
            if ([[responseCode objectForKey:@"status"] isEqualToString:@"success"]) {
                //NSLog(@"success");
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
        }
    }];
}

-(IBAction)btnApplyCouponPressed:(id)sender{
  //  [self.navigationController pushViewController:paymentVC animated:YES];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CouponPaymentViewController *couponPaymentVC  = [sb instantiateViewControllerWithIdentifier:@"CouponPaymentViewController"];
    [self.navigationController pushViewController:couponPaymentVC animated:YES];
}

-(IBAction)btnRemovePaymentPressed:(id)sender {
    [_btnApplyCoupon setTitle:@"APPLY COUPON CODE" forState:UIControlStateNormal];
    NSString *strMessage = [NSString stringWithFormat:@"Proceed To Pay %@ %@",patientService.amount,patientService.strCurrency];
    patientService.couponPrice = @"";
    patientService.payment_mode_id = 0;
    [_btnCouponPayment setTitle:strMessage forState:UIControlStateNormal];
    
    [_btnRemoveCouponPayment setHidden:YES];
    if(([selectedDoctorCountry caseInsensitiveCompare :@"India" ] == NSOrderedSame) && ([myCountry caseInsensitiveCompare :@"India" ] == NSOrderedSame)) {
        [_creditCardView setHidden:YES];
          patientService.payment_mode_id = 6;
    }
    else{
          patientService.payment_mode_id = 1;
        [_creditCardView setHidden:NO];
    }
}

-(void)verifyChecksum{
    float PriceToPay;
    NSLog(@"paitent service price %@",patientService.price);
    NSLog(@"paitent service amount %@",patientService.amount);

    if(patientService.payment_mode_id == 5){
        PriceToPay  = [patientService.price floatValue];

    }
    else{
        PriceToPay  = [patientService.amount floatValue];
    }
   if(patientService.payment_mode_id == 6 || patientService.payment_mode_id == 5  || patientService.payment_mode_id == 6){
        CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        
        NSString *price = [NSString stringWithFormat:@"%.2f",PriceToPay];
        [parameter setObject:@"" forKey:@"mobile_no"];
        [parameter setObject:price forKey:@"amount"];
        [service verifyChecksum:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            NSLog(@"Respose code %@", responseCode);
            if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]){
                NSString *callbackUrl  = [NSString stringWithFormat:@"%@",[[responseCode valueForKey:@"data"] valueForKey:@"CALLBACK_URL"]];
                NSString *channelId  = [NSString stringWithFormat:@"%@",[[responseCode valueForKey:@"data"] valueForKey:@"CHANNEL_ID"]];
                NSString *checksumHash  = [NSString stringWithFormat:@"%@",[[responseCode valueForKey:@"data"] valueForKey:@"CHECKSUMHASH"]];
                NSString *custid  = [NSString stringWithFormat:@"%@",[[responseCode valueForKey:@"data"] valueForKey:@"CUST_ID"]];
                NSString *industrytypeid  = [NSString stringWithFormat:@"%@",[[responseCode valueForKey:@"data"] valueForKey:@"INDUSTRY_TYPE_ID"]];
                NSString *mid  = [NSString stringWithFormat:@"%@",[[responseCode valueForKey:@"data"] valueForKey:@"MID"]];
                NSString *mobileno  = [NSString stringWithFormat:@"%@",[[responseCode valueForKey:@"data"] valueForKey:@"MOBILE_NO"]];
                NSString *orderid  = [NSString stringWithFormat:@"%@",[[responseCode valueForKey:@"data"] valueForKey:@"ORDER_ID"]];
                NSString *txnamount  = [NSString stringWithFormat:@"%@",[[responseCode valueForKey:@"data"] valueForKey:@"TXN_AMOUNT"]];
                NSString *website  = [NSString stringWithFormat:@"%@",[[responseCode valueForKey:@"data"] valueForKey:@"WEBSITE"]];
                
                //Step 1: Create a default merchant config object
                PGMerchantConfiguration *mc = [PGMerchantConfiguration defaultConfiguration];
                
                //Step 2: Create the order with whatever params you want to add. But make sure that you include the merchant mandatory params
                NSMutableDictionary *orderDict = [NSMutableDictionary new];
                
                //Step 3: Choose the PG server. In your production build dont call selectServerDialog. Just create a instance of the
                orderDict[kMID] = mid;
                orderDict[kORDERID] = orderid;
                orderDict[kCUST_ID] = custid;
                orderDict[kINDUSTRYTYPEID] = industrytypeid;
                orderDict[kCHANNEL_ID] = channelId;
                orderDict[kTXN_AMOUNT] =txnamount;
                orderDict[kWEBSITE] = website;
                orderDict[kCALLBACK_URL] = callbackUrl;
                orderDict[kCHECKSUMHASH] = checksumHash;
                orderDict[@"MOBILE_NO"]=@"";
                
                PGOrder *order = [PGOrder orderWithParams:orderDict];
                
                //Step 3: Choose the PG server. In your production build dont call selectServerDialog. Just create a instance of the
                //PGTransactionViewController and set the serverType to eServerTypeProduction
                PGTransactionViewController *txnController = [[PGTransactionViewController alloc]initTransactionForOrder:order];
                txnController.serverType = eServerTypeProduction;
                txnController.delegate = self;
                txnController.merchant = mc;
                [self showController:txnController];
            }
        }];
    }
    else if(patientService.payment_mode_id == 7){
        
    }
    
    }

#pragma mark PAYTM DELEGATE
#pragma mark PGTransactionViewController delegate

-(void)didFinishedResponse:(PGTransactionViewController *)controller response:(NSString *)responseString {
    DEBUGLOG(@"ViewController::didFinishedResponse:response = %@", responseString);
    NSString *title = [NSString stringWithFormat:@"Response"];
    NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
    //NSLog(@"Response is %@",[jsonResponse valueForKey:@"STATUS"]);
    if([[jsonResponse valueForKey:@"STATUS"] caseInsensitiveCompare:@"TXN_SUCCESS"] == NSOrderedSame){
        [self removeController:controller];
        
        if([patientService.visit_type_id isEqualToString:@"1"])
            [self PostLiveCallData];
        if([patientService.visit_type_id isEqualToString:@"2"])
            [self PostDataForApppointment];
        if([patientService.visit_type_id isEqualToString:@"3"])
            [self PostDataForApppointment];
    }
    else if([[jsonResponse valueForKey:@"STATUS"] caseInsensitiveCompare:@"TXN_FAILURE"] == NSOrderedSame){
         [self removeController:controller];
        
        [IODUtils showFCAlertMessage:[jsonResponse valueForKey:@"RESPMSG"] withTitle:@"" withViewController:self with:@"error"];        
    }
}


-(void)didCancelTrasaction:(PGTransactionViewController *)controller{
    
  //  DEBUGLOG(@"ViewController::didCancelTransaction error = %@ response= %@", error, response);
  //  NSString *msg = nil;
   // if (!error) msg = [NSString stringWithFormat:@"Successful"];
   // else msg = [NSString stringWithFormat:@"UnSuccessful"];
    
   // [[[UIAlertView alloc] initWithTitle:@"Transaction Cancel" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self removeController:controller];
    
}
- (void)didCancelTransaction:(PGTransactionViewController *)controller error:(NSError*)error response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didCancelTransaction error = %@ response= %@", error, response);
    NSString *msg = nil;
    if (!error) msg = [NSString stringWithFormat:@"Successful"];
    else msg = [NSString stringWithFormat:@"UnSuccessful"];
    [self removeController:controller];
}


- (void)didFinishCASTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didFinishCASTransaction:response = %@", response);
}

-(void)removeController:(PGTransactionViewController *)controller
{
    if (self.navigationController != nil)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [controller dismissViewControllerAnimated:YES
                                       completion:^{
                                       }];
}


-(void)showController:(PGTransactionViewController *)controller
{
    if (self.navigationController != nil)
        [self.navigationController pushViewController:controller animated:YES];
    else
        [self presentViewController:controller animated:YES
                         completion:^{
                         }];
}


@end
