//
//  MyEarningsViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 12/27/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "MyEarningsViewController.h"

@interface MyEarningsViewController ()
{
     NSMutableArray *arrMyEarnings;
    NSDictionary *response;
    UILabel *lblNoData;
}
@end

@implementation MyEarningsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getMyEarnings];
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"CouponCellTableViewCell" bundle:[NSBundle mainBundle]];
    [_segmentControl addTarget:self
                        action:@selector(segmentSwitch:)
              forControlEvents:UIControlEventValueChanged];
    
    [_segmentControl.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        [obj.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UILabel class]]) {
                UILabel *_tempLabel = (UILabel *)obj;
                [_tempLabel setNumberOfLines:0];
            }
        }];     
    }];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    
    [[self tblMyEarnings] registerNib:nib forCellReuseIdentifier:@"CouponCellTableViewCell"];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.title =@"My Earnings";
 
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
    return arrMyEarnings.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CouponCellTableViewCell"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.lblTitle.text = [[arrMyEarnings objectAtIndex:indexPath.row]valueForKey:@"appointment_date"];
    cell.lblDate.text = [[arrMyEarnings objectAtIndex:indexPath.row]valueForKey:@"username"];
   
    if([[[arrMyEarnings objectAtIndex:indexPath.row]valueForKey:@"paymentmode"] isEqualToString:@"Practice call"]){
        [cell.lblAmount setTitle:[NSString stringWithFormat:@"Practice Call"]forState:UIControlStateNormal];
    }
    else{
        [cell.lblAmount setTitle:[NSString stringWithFormat:@"%@$",[[arrMyEarnings objectAtIndex:indexPath.row]valueForKey:@"amount"]  ]forState:UIControlStateNormal];
    }
    
    //[cell.lblAmount setTitle:[NSString stringWithFormat:@"%@$",[[arrMyEarnings objectAtIndex:indexPath.row]valueForKey:@"amount"]  ]forState:UIControlStateNormal];
    [cell.lblAmount.layer setCornerRadius:12.0];
    cell.imgLogo.image = [UIImage imageNamed:@"icn-my-earning"];
    return cell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void) getMyEarnings{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service getMyEarningsWithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([[responseCode  valueForKey:@"status"] isEqualToString:@"success"]) {
            lblNoData = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
            lblNoData.center = self.view.center;
            lblNoData.text = kNodata;
            lblNoData.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
            lblNoData.font = [UIFont boldSystemFontOfSize:18.0];
            lblNoData.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:lblNoData];
            [lblNoData setHidden:YES];
            response =responseCode ;
            arrMyEarnings = [[responseCode valueForKey:@"data"] valueForKey:@"earnings"];
            if(arrMyEarnings.count == 0) {
                [lblNoData setHidden:NO];
                [_tblMyEarnings setHidden:YES];
            }
            [_tblMyEarnings reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}


- (IBAction)segmentSwitch:(UISegmentedControl *)sender {
    [lblNoData setHidden:YES];
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    if (selectedSegment == 0) {
       arrMyEarnings =  [[response valueForKey:@"data"] valueForKey:@"earnings"];
        if(arrMyEarnings.count == 0) {
            [lblNoData setHidden:NO];
            [_tblMyEarnings setHidden:YES];
        }
        else {
            [lblNoData setHidden:YES];
            [_tblMyEarnings setHidden:NO];

        }
    }
    else if(selectedSegment == 1){
       arrMyEarnings =  [[response valueForKey:@"data"] valueForKey:@"referal"];
        if(arrMyEarnings.count == 0) {
            [lblNoData setHidden:NO];
            [_tblMyEarnings setHidden:YES];
        }
        else {
            [lblNoData setHidden:YES];
            [_tblMyEarnings setHidden:NO];
        }
    }
    else if(selectedSegment == 2){
        arrMyEarnings =  [[response valueForKey:@"data"] valueForKey:@"network"];
        if(arrMyEarnings.count == 0) {
            [lblNoData setHidden:NO];
            [_tblMyEarnings setHidden:YES];
        }
        else {
            [lblNoData setHidden:YES];
            [_tblMyEarnings setHidden:NO];
        }
    }
    else if(selectedSegment == 3){
        arrMyEarnings =  [[response valueForKey:@"data"] valueForKey:@"special"];
        if(arrMyEarnings.count == 0) {
            [lblNoData setHidden:NO];
            [_tblMyEarnings setHidden:YES];
        }
        else {
            [lblNoData setHidden:YES];
            [_tblMyEarnings setHidden:NO];
        }
    }
    [_tblMyEarnings reloadData];
}

-(void)refreshView:(NSNotification*)notification{
    [self getMyEarnings];
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}

@end
