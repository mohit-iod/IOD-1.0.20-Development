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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//Forgot Password Click Event
-(IBAction)sendPressed:(id)sender {
    if(![IODUtils getError:self.txtEmail minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:YES minAge:nil maxAge:nil canBeSameDate:nil ]){
        [IODUtils showFCAlertMessage:EMAIL_ERR withTitle:nil withViewController:self with:@"error" ];
    }
    else {
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        if (reachable) {
            //Pass email id in Parameter
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
    }
}

@end
