//
//  ForgotPasswordViewController.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/16/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "IODUtils.h"
#import "CommonServiceHandler.h"
@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    self.title=@"Forgot password";
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
    }
    else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
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


////> http://localhost/iod-web/public/v1/forgot-password
//post request
//email: "sdsd"


-(IBAction)sendPressed:(id)sender {
    if(![IODUtils getError:self.txtEmail minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:YES minAge:nil maxAge:nil canBeSameDate:nil ]){
        [IODUtils showFCAlertMessage:EMAIL_ERR withTitle:nil withViewController:self with:@"error" ];
    }
    else {
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        if (reachable) {
            NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
            [parameter setObject:self.txtEmail.text forKey:@"email"];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
            [service forgotPassword:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if(responseCode) {
                    NSString *status = [responseCode valueForKey:@"status"];
                    if([status isEqualToString:@"success"]) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [IODUtils showFCAlertMessage:[responseCode valueForKey:@"message"] withTitle:nil withViewController:self with:@"success"];
                    }
                    else{
                           [IODUtils showFCAlertMessage:[responseCode valueForKey:@"message"] withTitle:nil withViewController:self with:@"error"];
                    }
                }
                else {
                    
                       [IODUtils showFCAlertMessage:[error valueForKey:@"message"] withTitle:nil withViewController:self with:@"error"];
                }
            }];
        }
        else{
            [IODUtils showFCAlertMessage:INTERNET_ERROR withTitle:@"Error" withViewController:self with:@"error"];
            
        }
    }
}

@end
