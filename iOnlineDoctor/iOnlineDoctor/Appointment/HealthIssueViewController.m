//
//  HealthIssueViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 3/1/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "HealthIssueViewController.h"
#import "MedicationViewController.h"
#import "PatientAppointService.h"
#import "IQKeyboardManager.h"
#import "AppDelegate.h"

@interface HealthIssueViewController () <UITextViewDelegate>
{
    UIBarButtonItem *btnNext;
    PatientAppointService *patientService;
    MedicationViewController *mvc;
}

@end

@implementation HealthIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Medical Info";
    [[IQKeyboardManager sharedManager] setEnable:false];

    patientService = [PatientAppointService sharedManager];
    // Do any additional setup after loading the view.
    mvc =  [self.storyboard instantiateViewControllerWithIdentifier:@"MedicationViewController"];

    [_txtvHEalthIssue.layer setBorderColor:[UIColor colorWithHexRGB:kBorderColor].CGColor];
    [_txtvHEalthIssue.layer  setBorderWidth:1.0];
    [_txtvHEalthIssue.layer setCornerRadius:6.0];
    _txtvHEalthIssue.text = patientService.question_3;
    
    //NExt Button
    btnNext = [[UIBarButtonItem alloc] initWithTitle:kNext style:UIBarButtonItemStyleDone target:self action:@selector(goNextPage:)];
    self.navigationItem.rightBarButtonItem = btnNext;
    _txtvHEalthIssue.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [[IQKeyboardManager sharedManager] setEnable:true];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- textview delegate
-(void)textViewDidChange:(UITextView *)textView{
    if ([textView isEqual:self.txtvHEalthIssue]) {
        if (textView.text.length>1500)
            textView.text=[textView.text substringToIndex:1500];
    }
}

/*!@discussion This method  is used to go to RootViewController.!*/
-(IBAction)btnHomePressed:(id)sender{
    AppDelegate *appDelegate=( AppDelegate* )[UIApplication sharedApplication].delegate;
    [appDelegate updateStatus:@""];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*! @discussion This method is used to handle click event to go to next page  */
-(IBAction)goNextPage:(id)sender{
    if(_txtvHEalthIssue.text.length>0){
        patientService.question_3 = _txtvHEalthIssue.text;
        [self.navigationController pushViewController:mvc animated:YES];
    }
    else{
       // [IODUtils showMessage:HEALTH_ISSUE withTitle:@""];
        [IODUtils showFCAlertMessage:HEALTH_ISSUE  withTitle:nil withViewController:self with:@"error" ];
    }
}
@end
