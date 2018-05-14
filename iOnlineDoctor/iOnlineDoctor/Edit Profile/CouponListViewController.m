//
//  CouponListViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 12/26/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "CouponListViewController.h"
#import "CouponCellTableViewCell.h"

@interface CouponListViewController ()
{
    NSMutableArray *arrCouponList;
    
}
@end

@implementation CouponListViewController

#pragma mark - View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    

        
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"CouponCellTableViewCell" bundle:[NSBundle mainBundle]];
    [[self tblCoupon] registerNib:nib forCellReuseIdentifier:@"CouponCellTableViewCell"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    
    BOOL reachable = reach.isReachable;
    if (reachable)
        [self getAllCoupon];
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    
}

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.title =@"My Coupons";
}

#pragma mark - Tableview Delegate & Datasource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrCouponList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68.0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CouponCellTableViewCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *strCouponType = [NSString stringWithFormat:@"%@",[[arrCouponList objectAtIndex:indexPath.row]valueForKey:@"coupon_type"]];
    
    if([strCouponType caseInsensitiveCompare:@"Referral"] == NSOrderedSame){
        cell.imgLogo.image = [UIImage imageNamed:@"icn-coupon-referral.png"];
    }
    else{
        cell.imgLogo.image = [UIImage imageNamed:@"icn-coupon-cancle.png"];
    }
    
    cell.lblTitle.text = [[arrCouponList objectAtIndex:indexPath.row]valueForKey:@"coupan_code"];
   NSString *createdDate = [[arrCouponList objectAtIndex:indexPath.row]valueForKey:@"created_dt"];
    cell.lblDate.text = [self ChangeDateFormat:createdDate];
    
   [cell.lblAmount setTitle:[NSString stringWithFormat:@"%@$",[[arrCouponList objectAtIndex:indexPath.row]valueForKey:@"coupon_price"] ] forState:UIControlStateNormal];
    [cell.lblAmount.layer setCornerRadius:12.0];
    NSString *expDate = [NSString stringWithFormat:@"%@",[[arrCouponList objectAtIndex:indexPath.row]valueForKey:@"expiry_dt"]];
    expDate = [self ChangeDateFormat:expDate];
    if(![expDate isEqualToString:@"<null>"]){
        cell.lblExpiryDate.text = expDate;
    }else{
        cell.lblExpiryDate.text = @"";
        
    }
    
    return cell;
}

#pragma mark - Void Methods

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) getAllCoupon{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service getAllCouponWithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([[responseCode  valueForKey:@"status"] isEqualToString:@"success"]) {
            arrCouponList = [responseCode valueForKey:@"data"];
            if(arrCouponList.count ==0) {
              
                    [_tblCoupon setHidden:YES];
                    UILabel *lblNoData = [[UILabel alloc]init];
                    lblNoData.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30) ;
                    lblNoData.center = self.view.center;
                    lblNoData.text = kNodata;
                    [self.view addSubview:lblNoData];
                    lblNoData.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
                    lblNoData.font = [UIFont boldSystemFontOfSize:18.0];
                    lblNoData.textAlignment = NSTextAlignmentCenter;
            }
            else{
                [_tblCoupon setHidden:NO];
            }
            [_tblCoupon reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

- (NSString *) ChangeDateFormat : (NSString *) toDate
{
    NSString *toDateCheck;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString: toDate]; // here you can fetch date from string with define format
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MMM/yyyy HH:mm:ss"];// here set format which you want...
    toDateCheck = [dateFormatter stringFromDate:date]; //here convert date in NSString
    
    return toDateCheck;
}
@end
