//
//  labReportViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/17/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "labReportViewController.h"
#import "CommonServiceHandler.h"
#import "IODUtils.h"
#import "DoctorAppointmentServiceHandler.h"
@interface labReportViewController ()
{
    DoctorAppointmentServiceHandler *docService;
}
@end

@implementation labReportViewController

{
    NSInteger RowsPrescribeAdded;

    
}

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
  //  _viewAddPrescribtion.hidden=YES;
    //RowsPrescribeAdded=0;
    docService = [DoctorAppointmentServiceHandler sharedManager];
}

- (void)viewDidAppear:(BOOL)animated{
    docService = [DoctorAppointmentServiceHandler sharedManager];
    [self getAllLAB];
}

-(void)getAllLAB {
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:docService.visit_id forKey:@"visitId"];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
        [service getLab:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            if(responseCode) {
                //NSLog(@"Response code %@", responseCode);
            }
        }];
    }else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
    
}


@end
