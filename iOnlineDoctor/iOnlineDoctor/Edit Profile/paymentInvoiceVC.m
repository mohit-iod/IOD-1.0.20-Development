//
//  paymentInvoiceVC.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/4/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "paymentInvoiceVC.h"
#import "CommonServiceHandler.h"
#import "FileViewerVC.h"
#import "UIColor+HexString.h"


@interface paymentInvoiceVC ()
{
    NSArray *arrPatientInvoice;
}
@end

@implementation paymentInvoiceVC

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
   UINib *nib = [UINib nibWithNibName:@"DocCellXib" bundle:[NSBundle mainBundle]];
    [[self tblPayment] registerNib:nib forCellReuseIdentifier:@"DocCellXib"];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        _tblPayment.rowHeight=80;
    }else{
        _tblPayment.rowHeight=70;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach.isReachable;
    if (reachable)
        [self getPatientPaymentInvoice];
    
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    // Do any additional setup after loading the view.
  
}
-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.title =@"Payment Invoice";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrPatientInvoice.count;
}


-(DocCellXib *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DocCellXib *cell=[tableView dequeueReusableCellWithIdentifier:@"DocCellXib" ];
    NSString *strInvoiceDate = [[arrPatientInvoice objectAtIndex:indexPath.row] valueForKey:@"date"];
    strInvoiceDate = [IODUtils formateStringToDateForUI:strInvoiceDate];
    cell.lblCellText.text = strInvoiceDate;
    cell.btnDwnload.tag = indexPath.row;
    cell.btnView.tag = indexPath.row;
    
    cell.btnView.alpha = 1;
    cell.btnDwnload.alpha = 1;
    
    [cell.btnDwnload addTarget:self action:@selector(btnDownloadPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnView addTarget:self action:@selector(viewFileClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.imgIcon.image = [UIImage imageNamed:@"payment-invoice-icn.png"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(IBAction)btnDownloadPressed:(UIButton*)sender {
   // NSLog(@"Download Pressed");
    CommonServiceHandler *service =[[CommonServiceHandler alloc]init];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (reachable) {
        [service downloadFilePath:[[arrPatientInvoice objectAtIndex:sender.tag] valueForKey:@"path"] imagePath:@"Test" finished:^(NSString *filePath, NSError *error) {
            if (filePath != nil) {
              //  NSLog(@"File path:%@",filePath);
                [IODUtils showFCAlertMessage:kFileDownloaded withTitle:@"" withViewController:self with:@"error"];
            } else{
                [IODUtils showFCAlertMessage:kFileNotAvailable withTitle:@"" withViewController:self with:@"error"];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}

- (IBAction)viewFileClicked:(UIButton*)sender {
    
    NSString *fileName = [[arrPatientInvoice objectAtIndex:sender.tag] valueForKey:@"invoice-url"];
    NSString *fName = [fileName lastPathComponent];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    FileViewerVC *fileviewervc = [self.storyboard instantiateViewControllerWithIdentifier:@"FileViewerVC"];
    if (fileExists) {
        fileviewervc.strFilePath = [[arrPatientInvoice objectAtIndex:sender.tag] valueForKey:@"invoice-url"];
    }
    else {
        fileviewervc.strFilePath = [[arrPatientInvoice objectAtIndex:sender.tag] valueForKey:@"invoice-url"];
        fileviewervc.strTitle = @"Invoice";
    }
    [self.navigationController pushViewController:fileviewervc animated:YES];
}

- (void)getPatientPaymentInvoice {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //NSDictionary *parameter = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"categoryId",nil];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service getPatienPaymentInvoice:nil WithCompletionBlock:^
     (NSDictionary *responseCode, NSError *error){
        ////NSLog(@"Array of invoices %@ error: %@",responseCode, error);
        if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]) {
            arrPatientInvoice = [responseCode valueForKey:@"data"];
            if(arrPatientInvoice.count == 0) {
                [self.tblPayment setHidden:YES];
                UILabel *lblNoData = [[UILabel alloc]init];
                lblNoData.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30) ;
                lblNoData.center = self.view.center;
                lblNoData.text = kNodata;
                [self.view addSubview:lblNoData];
                lblNoData.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
                lblNoData.font = [UIFont boldSystemFontOfSize:18.0];
                lblNoData.textAlignment = NSTextAlignmentCenter;
            }
            
            [self.tblPayment reloadData];
            //NSLog(@"Array of invoice:%@",arrPatientInvoice);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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

@end
