//
//  PatientEarningsViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 2/21/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "PatientEarningsViewController.h"
#import "CommonServiceHandler.h"
#import "CouponCellTableViewCell.h"

@interface PatientEarningsViewController ()
{
    NSMutableArray *arrMyEarnings;
    UILabel *lblNoData;

}

@end

@implementation PatientEarningsViewController

#pragma mark - View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *arrMyEarnings;
    NSDictionary *response;
    UILabel *lblNoData;
    
}

-(void)viewWillAppear:(BOOL)animated{
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    
    BOOL reachable = reach.isReachable;
    if (reachable)
        [self getAllEarnings];
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    
    UINib *nib = [UINib nibWithNibName:@"CouponCellTableViewCell" bundle:[NSBundle mainBundle]];
    [[self tblMyEarnings] registerNib:nib forCellReuseIdentifier:@"CouponCellTableViewCell"];
    
}
-(void) viewDidAppear:(BOOL)animated {
    self.tabBarController.title =@"My Earnings";
}

#pragma mark - Tableview Delegate & Datasource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrMyEarnings.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CouponCellTableViewCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.lblTitle.text = [[arrMyEarnings objectAtIndex:indexPath.row]valueForKey:@"appointment_date"];
    cell.lblDate.text = [[arrMyEarnings objectAtIndex:indexPath.row]valueForKey:@"username"];
    [cell.lblAmount setTitle:[NSString stringWithFormat:@"%@$",[[arrMyEarnings objectAtIndex:indexPath.row]valueForKey:@"amount"]  ]forState:UIControlStateNormal];
    [cell.lblAmount.layer setCornerRadius:12.0];
    cell.imgLogo.image = [UIImage imageNamed:@"icn-my-earning"];
    cell.lblExpiryDate.text =[NSString stringWithFormat:@"Apt Date: %@",[[arrMyEarnings objectAtIndex:indexPath.row]valueForKey:@"appointment_date"]];
    return cell;
}

#pragma mark - Void Methods

-(void)getAllEarnings{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service getPatientEarningsWithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        NSLog(@"Response %@", responseCode);
        
        if([[responseCode  valueForKey:@"status"] isEqualToString:@"success"]) {
            lblNoData = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
            lblNoData.center = self.view.center;
            lblNoData.text = kNodata;
            lblNoData.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
            lblNoData.font = [UIFont boldSystemFontOfSize:18.0];
            lblNoData.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:lblNoData];
            [lblNoData setHidden:YES];
            
            // response =responseCode ;
            arrMyEarnings = [responseCode valueForKey:@"data"];
            if(arrMyEarnings.count == 0) {
                [lblNoData setHidden:NO];
                [_tblMyEarnings setHidden:YES];
            }
            else{
                [lblNoData setHidden:YES];
            }
            
            [_tblMyEarnings reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
    }];
}

@end
