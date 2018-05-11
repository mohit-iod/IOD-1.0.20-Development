//
//  ContactUsViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/30/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "ContactUsViewController.h"
#import "CommonServiceHandler.h"
#import "ColorsConstants.h"
#import "UIColor+HexString.h"
#import "DEMONavigationController.h"


@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void) showMenu {
    
    self.title=@"";
    if (self.strTitle.length>0) {
        self.title=self.strTitle;
    }
    
    self.title = @"Contact Us";
    if (!_hideMenu) {
        
        UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                         initWithImage:[UIImage imageNamed:@""]
                                         style:UIBarButtonItemStylePlain
                                         target:self action:@selector(showMenu)];
        //[logoutButton setTintColor:[UIColor whiteColor]];
        
        
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
        
        //    [self.navigationController.navigationBar setAlpha:0.5];
        self.navigationItem.leftBarButtonItem = logoutButton;
    }
    [(DEMONavigationController *)self.parentViewController showMenu];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _txtName.text =UDGet(@"uname");
    _txtEmail.text = UDGet (@"uemail");

    
    [_txtName setUserInteractionEnabled:NO];
    [_txtEmail setUserInteractionEnabled:NO];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
  
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
    
    //    [self.navigationController.navigationBar setAlpha:0.5];
    
    // Do any additional setup after loading the view.
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
    }else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)btnSubmitPressed:(id)sender {
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    if (![IODUtils getError:self.txtName minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:YES canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]) {
    }
    else if(![IODUtils getError:self.txtEmail minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:YES minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    else if(![IODUtils getError:self.subject minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]){
    }
    else if(_message.text.length ==0){
        
        [IODUtils showFCAlertMessage:@"Please enter Message" withTitle:@"" withViewController:self with:@"error"];
    }
    else{
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        
        [parameter setObject:_subject.text forKey:@"subject"];
        [parameter setObject:_message.text forKey:@"message"];

        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        if (reachable) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service postFeedBackinContactUs:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if([[responseCode objectForKey:@"status"]isEqualToString:@"success"]){
                  
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                   // [IODUtils showMessage:[responseCode objectForKey:@"message"] withTitle:@""];
                    [IODUtils showFCAlertMessage:[responseCode objectForKey:@"message"] withTitle:@"" withViewController:self with:@"success"];

                    if([[responseCode objectForKey:@"status"] isEqualToString:@"success"]){
                      
                          [IODUtils showFCAlertMessage:@"Your Feedback/Query has been Successfully sent." withTitle:@"" withViewController:self with:@"success"];
                    }
                }
            }];
        }
        else {
            [IODUtils  showMessage:INTERNET_ERROR withTitle:@"Error"];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
