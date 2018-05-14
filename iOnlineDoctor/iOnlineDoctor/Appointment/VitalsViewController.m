//
//  VitalsViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 3/3/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "VitalsViewController.h"
#import "UploadDocumentsViewController.h"
#import "PatientAppointService.h"
#import "AppDelegate.h"

@interface VitalsViewController ()
{
    UIBarButtonItem *btnNext;
    PatientAppointService *patientService;
    UploadDocumentsViewController *hvc;
}

@end

@implementation VitalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the title for navigation bar.
    self.title = @"Medical Info";
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    hvc =  [mainSB instantiateViewControllerWithIdentifier:@"UploadDocumentsViewController"];
    patientService = [PatientAppointService sharedManager];
  
    //set the UI for
    [_vitalsView.layer setBorderWidth:1.0];
    [_vitalsView.layer  setCornerRadius:6];
    [_vitalsView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    // Do any additional setup after loading the view.
    btnNext = [[UIBarButtonItem alloc] initWithTitle:kSkip style:UIBarButtonItemStyleDone target:self action:@selector(goNextPage:)];
    self.navigationItem.rightBarButtonItem = btnNext;
}


/*! @discussion This method is used to handle click event to go to next page  */
-(IBAction)goNextPage:(id)sender{
    
    NSString *bloodPressure =  _txtBloodPressure.text;
    NSString *bloodPressure2 =  _txtBloodPressure2.text;
    
    if(bloodPressure2.length == 0){
        bloodPressure = _txtBloodPressure.text;
    }
    else {
        bloodPressure = [NSString stringWithFormat:@"%@-%@",_txtBloodPressure.text,_txtBloodPressure2.text];
    }
    NSString *strVitals = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",_txtbodyTemparature.text,bloodPressure,_txtPulseRate.text,_txtRespiratoryRate.text,_txtBloodGlucose.text];
    patientService.question_7 =strVitals;

    
    [self.navigationController pushViewController:hvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Text field delegate method.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    // Set the maximum length of the vitals textfield.
   if(textField == _txtBloodPressure || textField == _txtPulseRate || textField == _txtBloodGlucose || textField == _txtBloodPressure2 || textField == _txtbodyTemparature || textField == _txtRespiratoryRate){
        {
            const char *_char = [string cStringUsingEncoding:NSUTF8StringEncoding];
            int isBackSpace = strcmp(_char, "\b");
            if (isBackSpace == -8) {
                return YES;
            }
            // If it's not a backspace, allow it if we're still under 30 chars.
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            return (newLength > 3) ? NO : YES;
        }
    }
    if(string.length >0) {
        [btnNext setTitle:kNext];
    }
    return YES;
}


/*!@discussion This method  is used to go to RootViewController / home page.!*/
-(IBAction)btnHomePressed:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
