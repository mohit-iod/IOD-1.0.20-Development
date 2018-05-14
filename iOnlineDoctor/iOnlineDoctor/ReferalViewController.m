//
//  ReferalViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 2/1/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "ReferalViewController.h"
@interface ReferalViewController ()
{
    NSString *referalCode;
}
@end

@implementation ReferalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    referalCode = UDGet(@"referalcode");
    if([referalCode isEqualToString:@"(null)"]){
        referalCode = @"";
    }
    
    self.title = @"Code Share";
    _lblReferalCode.text = referalCode;
}

#pragma mark - IBAction Methods

-(IBAction)btnSharePressed:(id)sender {
    
    NSString * title =[NSString stringWithFormat:@"I am excited to share link for I Online Doctor Mobile App. Download and Video Call Doctor from your Mobile! Please use my code %@. \n https://itunes.apple.com/us/app/i-online-doc/id1299763701?ls=1&mt=8",referalCode];
    
    NSArray* dataToShare = @[title];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
        activityViewController.popoverPresentationController.sourceView = sender;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:activityViewController animated:YES completion:nil];
        });
    }
    else{
        [self presentViewController:activityViewController
                           animated:YES
                         completion:nil];
    }
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

@end
