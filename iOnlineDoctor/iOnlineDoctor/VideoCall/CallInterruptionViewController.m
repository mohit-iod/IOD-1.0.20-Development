//
//  CallInterruptionViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 10/9/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "CallInterruptionViewController.h"
#import "CommonServiceHandler.h"
#import "DoctorAppointmentServiceHandler.h"
#import "rateUsVC.h"
#import "DoctorCallAgainViewController.h"
#import "DoctorVideoViewController.h"

@interface CallInterruptionViewController ()
{
    DoctorAppointmentServiceHandler *doctorService;
    int remainingTime ;
}
@end

@implementation CallInterruptionViewController

- (void)viewDidLoad {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   " style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    [super viewDidLoad];
    doctorService = [DoctorAppointmentServiceHandler sharedManager];
    doctorService.isCallInterrupted = @"yes";
    
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    self.lblRemainingTime.text = self.strRemainingTime;
    remainingTime = doctorService.InterruptionTime;
    //NSLog(@"Remaining time is %d", remainingTime);
    if(remainingTime < 5) {
        [self.btnCallInterruption setHidden:YES];
        _btnCancel.center = self.view.center;
    }
    
    //UILabel *lblRemainingTime = [NSString stringWithFormat:@"Remaining time is %@",]
    // Do any additional setup after loading the view.
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

- (void)InterruptedCall{
    
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
    NSString *start_time = doctorService.strStartTime;
    NSString *end_time = doctorService.endTime;
    NSMutableDictionary *paramater = [[NSMutableDictionary alloc] init];
    [paramater setObject:doctorService.visit_id forKey:@"patient_visit_id"];
    [paramater setObject:kCallInterupted forKey:@"call_status"];
    [paramater setObject:kCallInterupted forKey:@"appointment_status_id"];
    [paramater setObject:UDGet(@"uid") forKey:@"call_dropped_by"];
    [paramater setObject:@"NO" forKey:@"is_call_dropped"];
    [paramater setObject:@"Call end" forKey:@"call_status_description"];
    [paramater setObject:doctorService.call_duration forKey:@"call_duration"];
    [paramater setObject:start_time forKey:@"start_time"];
    [paramater setObject:end_time forKey:@"end_time"];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service postEndCallData:paramater WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];}
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (void)successfulCall{
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
        NSString *start_time = doctorService.strStartTime;
        NSString *end_time = doctorService.endTime;
        NSMutableDictionary *paramater = [[NSMutableDictionary alloc] init];
        [paramater setObject:doctorService.visit_id forKey:@"patient_visit_id"];
        [paramater setObject:kCallSuccess forKey:@"call_status"];
        [paramater setObject:kCallSuccess forKey:@"appointment_status_id"];
        [paramater setObject:UDGet(@"uid") forKey:@"call_dropped_by"];
        [paramater setObject:@"NO" forKey:@"is_call_dropped"];
        [paramater setObject:@"Call end" forKey:@"call_status_description"];
        [paramater setObject:doctorService.call_duration forKey:@"call_duration"];
        [paramater setObject:start_time forKey:@"start_time"];
        [paramater setObject:end_time forKey:@"end_time"];
        CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
        [service postEndCallData:paramater WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
    else {
       // //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(IBAction)btnCancellPressed:(id)sender {
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
        NSMutableDictionary *paramater = [[NSMutableDictionary alloc] init];
        [paramater setObject:doctorService.visit_id forKey:@"patient_visit_id"];
        [paramater setObject:kCallInterupted forKey:@"call_status"];
        [paramater setObject:kCallInterupted forKey:@"appointment_status_id"];
        [paramater setObject:UDGet(@"uid") forKey:@"call_dropped_by"];
        [paramater setObject:@"NO" forKey:@"is_call_dropped"];
        [paramater setObject:@"Call end" forKey:@"call_status_description"];
        [paramater setObject:doctorService.call_duration forKey:@"call_duration"];
        [paramater setObject:@"" forKey:@"start_time"];
        [paramater setObject:@"" forKey:@"end_time"];
        CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
        [service postEndCallData:paramater WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];}
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}

-(IBAction)btnCallAgainPressed:(id)sender {
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter  =[[NSMutableDictionary alloc] init];
    
    [parameter setObject:doctorService.visit_id  forKey:@"visit_id"];
    
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;

    if (reachable) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [service callToPatientByDoctor:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            // NSLog(@"Response %@",responseCode);
            if(responseCode){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if([[responseCode objectForKey:@"status"] isEqualToString:@"success"]) {
                    NSMutableDictionary *userInfo = [responseCode objectForKey:@"data"];
                    doctorService = [DoctorAppointmentServiceHandler sharedManager];
                    doctorService.appoitment_date = [userInfo objectForKey:@"appoitment_date"];
                    doctorService.from = [userInfo objectForKey:@"from"];
                    doctorService.patient_address  =[userInfo objectForKey:@"patient_address"];
                    doctorService.patient_dob  =[userInfo objectForKey:@"patient_dob"];
                    doctorService.patient_gender  =[userInfo objectForKey:@"patient_gender"];
                    doctorService.patient_id  =[userInfo objectForKey:@"patient_id"];
                    doctorService.patient_name  =[userInfo objectForKey:@"patient_name"];
                    doctorService.patient_id = [userInfo objectForKey:@"patient_id"];
                    doctorService.profile_pic  =[userInfo objectForKey:@"profile_pic"];
                    doctorService.session_id  =[userInfo objectForKey:@"session_id"];
                    doctorService.session_token  =[userInfo objectForKey:@"session_token"];
                    doctorService.type  =[userInfo objectForKey:@"type"];
                    doctorService.visit_id  =[userInfo objectForKey:@"visit_id"];
                    doctorService.visit_type  =[userInfo objectForKey:@"visit_type"];
                    doctorService.call_duration = [userInfo objectForKey:@"call_duration"];
                    
                 //   [self.navigationController popViewControllerAnimated:NO];
                    
                    DoctorCallAgainViewController *doctorCallAgainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DoctorCallAgainViewController"];
                    [self.navigationController pushViewController:doctorCallAgainVC animated:YES];
                  //  DoctorVideoViewController *doc = [self.storyboard instantiateViewControllerWithIdentifier:@"DoctorVideoViewController"];
                 //   [self.navigationController pushViewController:doc animated:YES];

                    
                }
            }
        }];
    }
    
    else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
    
}

- (IBAction)goHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)InterruptedPatientCancel:(id)sender {
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
        NSString *start_time = doctorService.strStartTime;
        NSString *end_time = doctorService.endTime;
        NSMutableDictionary *paramater = [[NSMutableDictionary alloc] init];
        [paramater setObject:doctorService.visit_id forKey:@"patient_visit_id"];
        [paramater setObject:kCallInterupted forKey:@"call_status"];
        [paramater setObject:kCallInterupted forKey:@"appointment_status_id"];
        [paramater setObject:UDGet(@"uid") forKey:@"call_dropped_by"];
        [paramater setObject:@"NO" forKey:@"is_call_dropped"];
        [paramater setObject:doctorService.callInterruptionMessage forKey:@"call_status_description"];
        [paramater setObject:doctorService.call_duration forKey:@"call_duration"];
        [paramater setObject:start_time forKey:@"start_time"];
        [paramater setObject:end_time forKey:@"end_time"];
        CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
        [service postEndCallData:paramater WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            doctorService.isCallInterrupted = @"no";
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];}
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(IBAction)InterruptedPatientDone:(id)sender {
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
        NSString *start_time = doctorService.strStartTime;
        NSString *end_time = doctorService.endTime;
        NSMutableDictionary *paramater = [[NSMutableDictionary alloc] init];
        [paramater setObject:doctorService.visit_id forKey:@"patient_visit_id"];
        [paramater setObject:kCallSuccess forKey:@"call_status"];
        [paramater setObject:kCallInterupted forKey:@"appointment_status_id"];
        [paramater setObject:UDGet(@"uid") forKey:@"call_dropped_by"];
        [paramater setObject:@"NO" forKey:@"is_call_dropped"];
        [paramater setObject:doctorService.callInterruptionMessage forKey:@"call_status_description"];
        [paramater setObject:doctorService.call_duration forKey:@"call_duration"];
        [paramater setObject:start_time forKey:@"start_time"];
        [paramater setObject:end_time forKey:@"end_time"];
        CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service postEndCallData:paramater WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
           // [self.navigationController popToRootViewControllerAnimated:YES];
            UIViewController *rateUs=[self.storyboard instantiateViewControllerWithIdentifier:@"rateUsVC"];
            doctorService.isCallInterrupted = @"no";
            
            [self.navigationController pushViewController:rateUs animated:YES];
            
        }];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}

@end
