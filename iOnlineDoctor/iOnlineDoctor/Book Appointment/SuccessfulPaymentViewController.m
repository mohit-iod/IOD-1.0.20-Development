//
//  SuccessfulPaymentViewController.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 10/5/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "SuccessfulPaymentViewController.h"
#import "PatientAppointService.h"

@interface SuccessfulPaymentViewController ()

{
    PatientAppointService *patientService;
}
@end

@implementation SuccessfulPaymentViewController

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
      self.navigationItem.leftBarButtonItem=nil;
      self.navigationItem.hidesBackButton=YES;
    // Do any additional setup after loading the view.
    patientService = [PatientAppointService sharedManager];
   // _lblPayment.text = [NSString stringWithFormat:@"%@",];
    NSString *strPayment = [NSString stringWithFormat:@"%@ %@",patientService.amount, patientService.currency];
    NSString *strCharge = [NSString stringWithFormat:@"%.2f %@",[patientService.amount floatValue],patientService.currency];
    
    
    if(patientService.isPracticeCallDone == 0 ){
        _lblPayment.text = [NSString stringWithFormat:@""];
    
    }
    else {
        _lblPayment.text = [NSString stringWithFormat:@"Payment Successful You paid  $ %@",strCharge];
    }
    
    
    _lblPaymentWith.text = [NSString stringWithFormat:@"with Dr. %@",patientService.res_doctor_name];
    
    _lblDateTime.text = [NSString stringWithFormat:@"%@         %@", [IODUtils formateStringToDateForUI:patientService.res_date],patientService.res_startTime ];
    _lblOrderNo.text = [NSString stringWithFormat:@"Order No: %@",patientService.res_order_no];
    
    NSString *strRes_order_no = [NSString stringWithFormat:@"%@",patientService.res_order_no];
    
    if([strRes_order_no isEqualToString:@"(null)"] || strRes_order_no == nil || [strRes_order_no isEqual:[NSNull null]] ||[strRes_order_no isKindOfClass:[NSNull class]] ){
        [_lblOrderNo setHidden:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
}


-(void)viewDidDisappear:(BOOL)animated{
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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


-(IBAction)btnHomePressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)GoHomePressed:(id)sender {
}
@end
