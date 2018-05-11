//
//  rateUsVC.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/17/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "rateUsVC.h"
#import "CommonServiceHandler.h"
#import "PatientAppointService.h"
#import "IODUtils.h"

@interface rateUsVC ()
{
    int selectedindex;
    PatientAppointService *patientService;
}
@end

@implementation rateUsVC

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.title = @"Rate Us";
   // patientService.isPracticeCallDone
   
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    
    patientService = [PatientAppointService sharedManager];
    self.textViewRate.layer.borderColor=[UIColor greenColor].CGColor;
    self.textViewRate.layer.borderWidth=0.5;
    
    
    self.imgSLmiley.image=[UIImage imageNamed:@"smile-3.png"];
    self.pagerRate.currentPage=4;
    self.stepSLider.index=4;
  
}

-(void)viewDidAppear:(BOOL)animated{
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderValueChange:(StepSlider *)sender {
    self.pagerRate.currentPage=sender.index;
    selectedindex = (int)sender.index+1;
    self.imgSLmiley.image=[UIImage imageNamed:[NSString stringWithFormat:@"smile-%lu.png",sender.index+1]];
}
- (IBAction)brnSubmitPressed:(id)sender {
    CommonServiceHandler *service = [[CommonServiceHandler alloc]init];
    NSString *visitId = patientService.res_visit_id;
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        [parameter setObject:[NSNumber numberWithInt:selectedindex] forKey:@"rating"];
        [parameter setObject:visitId forKey:@"patient_visit_id"];
        [parameter setObject:_textViewRate.text forKey:@"feedback"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service PostFeedack:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            if(responseCode) {
                if([[responseCode valueForKey:@"status"] isEqualToString:@"success"])
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else {
            }
        }];
    }
    else {
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}
@end
