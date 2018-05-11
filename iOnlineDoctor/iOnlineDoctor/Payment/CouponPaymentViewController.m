//
//  CouponPaymentViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 2/5/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "CouponPaymentViewController.h"
#import "CopponCell.h"
#import "CommonServiceHandler.h"
#import "UIColor+HexString.h"
#import "PatientAppointService.h"

@interface CouponPaymentViewController ()
{
    NSArray *arrCouponList;
    PatientAppointService *patientService;
   
}
@end

@implementation CouponPaymentViewController

-(void)viewDidAppear:(BOOL)animated{
   
}

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"CopponCell" bundle:[NSBundle mainBundle]];
    [[self tblCoupon] registerNib:nib forCellReuseIdentifier:@"CopponCell"];
    patientService = [PatientAppointService sharedManager];
}

-(void)viewWillAppear:(BOOL)animated{
    self.title = @"Apply Coupon";
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach.isReachable;
    if (reachable)
        [self getAllCoupon];
    
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrCouponList.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CopponCell *cell=[_tblCoupon dequeueReusableCellWithIdentifier:@"CopponCell"];
    
    NSString *strCouponList = [NSString stringWithFormat:@"Use %@ of  $%@", [[arrCouponList objectAtIndex:indexPath.row] valueForKey:@"coupan_code"], [[arrCouponList objectAtIndex:indexPath.row]valueForKey:@"coupon_price"]];
    
    cell.lblCoupon.text = strCouponList;
    NSString *strCouponType = [NSString stringWithFormat:@"%@",[[arrCouponList objectAtIndex:indexPath.row]valueForKey:@"coupon_type"]];

    [cell.lblCoupon.layer setCornerRadius:12.0];
    if([strCouponType caseInsensitiveCompare:@"Referral"] == NSOrderedSame){
        cell.imgCoupon.image = [UIImage imageNamed:@"icn-coupon-referral.png"];
    }
    else{
        cell.imgCoupon.image = [UIImage imageNamed:@"icn-coupon-cancle.png"];
    }
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.lblCoupon.text];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexRGB:kNavigatinBarColor] range:NSMakeRange(4,6)];
    cell.lblCoupon.attributedText = string;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.btnApplyCoupon setTag:indexPath.row];
    [cell.btnApplyCoupon addTarget:self action:@selector(btnApplyCouponPressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(IBAction)btnApplyCouponPressed:(UIButton *)sender {
    NSMutableDictionary *parameter  = [[NSMutableDictionary alloc] init];
    int specializationId = [patientService.selectedCategory intValue];
    [parameter setObject:patientService.amount forKey:@"price"];
    [parameter setObject:patientService.selectedCategoryName forKey:@"category"];
    NSString *couponCode;
    
    if(sender.tag == -1){
        if (![IODUtils getError:self.txtCouponCode minVlue:nil minVlue:nil onlyNumeric:nil
                      onlyChars:NO canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]) {
            
            return;
            
        }
    }
    if(sender.tag == -1){
        
        NSString *couponCode = _txtCouponCode.text;
        [parameter setObject:couponCode forKey:@"coupan"];
        
    }
    else{
        NSString *couponCode = [[arrCouponList objectAtIndex:sender.tag] valueForKey:@"coupan_code"];
        
        [parameter setObject:couponCode forKey:@"coupan"];
    }
    //NSLog(@"apply coupon pressed");
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
  
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];

    [service verifyCouponcode:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        if(responseCode){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if([[responseCode objectForKey:@"status"] isEqualToString:@"success"])
            {
                //NSLog(@"Response is:%@",responseCode);
                NSString *couponPrice;
                NSDictionary *dict = [responseCode objectForKey:@"data"];
                if(dict){
                    NSString *paymentMode = [dict valueForKey:@"type"];
                    patientService.payment_mode_id = [paymentMode intValue];
                    
                    couponPrice = [NSString stringWithFormat:@"%@",[dict valueForKey:@"coupon_price"]];
                    
                    patientService.couponPrice =couponPrice;
                    if (dict[@"price"]){
                        patientService.price = [dict valueForKey:@"price"];
                    }
                    
                    if(patientService.payment_mode_id == 2 || patientService.payment_mode_id == 7){
                        
                        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:kCouponValidatemessage preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction * yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                            if(sender.tag == -1) {
                                patientService.couponCode = _txtCouponCode.text;
                                patientService.couponMessage = [NSString stringWithFormat:@"Coupon worth $%@ is applied successfully",couponPrice];
                            }
                            else {
                                patientService.couponCode = [[arrCouponList objectAtIndex:sender.tag] valueForKey:@"coupan_code"];
                                patientService.couponMessage = [NSString stringWithFormat:@"Coupon worth $%@ is applied successfully",couponPrice];
                            }
                            
                            if( [patientService.visit_type_id isEqualToString:@"1"]){
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                                message:kCouponSuccessful delegate:self
                                                                      cancelButtonTitle:@"Ok"
                                                                      otherButtonTitles:nil];
                                alert.tag = 1;
                                [alert show];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            else {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                                message:@"Coupon applied successfully" delegate:self
                                                                      cancelButtonTitle:@"Ok"
                                                                      otherButtonTitles:nil];
                                alert.tag = 1;
                                [alert show];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        }];
                        
                        UIAlertAction * noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
                        
                        [alert addAction:yesAction];
                        [alert addAction:noAction];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else{
                        if(sender.tag == -1) {
                            patientService.couponCode = _txtCouponCode.text;
                            patientService.couponMessage = [NSString stringWithFormat:@"Coupon worth $%@ is applied successfully",couponPrice];
                        }
                        else {
                            patientService.couponCode = [[arrCouponList objectAtIndex:sender.tag] valueForKey:@"coupan_code"];
                            patientService.couponMessage = [NSString stringWithFormat:@"Coupon worth $%@ is applied successfully",couponPrice];
                        }
                        
                        if( [patientService.visit_type_id isEqualToString:@"1"]){
                            [IODUtils showFCAlertMessage:kCouponSuccessful  withTitle:@"" withViewController:self with:@"success"];
                             [self.navigationController popViewControllerAnimated:YES];
                        }
                        else {
                    
                            [IODUtils showFCAlertMessage:kCouponSuccessful  withTitle:@"" withViewController:self with:@"success"];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                }
            }
            else {
             //   [IODUtils showMessage:VALID_COUPON withTitle:@"Error"];
                
                [IODUtils showFCAlertMessage:VALID_COUPON  withTitle:@"" withViewController:self with:@"error"];

                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }
        else if(error){
           // [IODUtils showMessage:error withTitle:@""];
            [IODUtils showFCAlertMessage:[error valueForKey:@"message"]  withTitle:@"" withViewController:self with:@"error"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
            //NSLog(@"Existing Member ");
            [_tblCoupon reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

@end
