//
//  PaymentCurrencyViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 12/19/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "PaymentCurrencyViewController.h"
#import "PaymentCurrency.h"
#import "PatientAppointService.h"

@interface PaymentCurrencyViewController ()
{
    NSMutableArray *arrCurrency;
    PatientAppointService *patientService;

}
@end

@implementation PaymentCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    [super viewDidLoad];
       patientService = [PatientAppointService sharedManager];

    arrCurrency = [[NSMutableArray alloc] init];
    NSDictionary *dictgender = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"currency" ofType:@"json"]];
   arrCurrency = [dictgender valueForKey:@"currency"];
    
    UINib *nib = [UINib nibWithNibName:@"PaymentCurrency" bundle:[NSBundle mainBundle]];
    [[self tblCurrency] registerNib:nib forCellReuseIdentifier:@"PaymentCurrency"];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tblCurrency.frame.size.height/2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrCurrency.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentCurrency *cell=[tableView dequeueReusableCellWithIdentifier:@"PaymentCurrency"];
    cell.imgCurrency.image = [UIImage imageNamed:[[arrCurrency objectAtIndex:indexPath.row]valueForKey:@"image"]];
    
    cell.lblTitle.text = [[arrCurrency objectAtIndex:indexPath.row]valueForKey:@"Title"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.transform = CGAffineTransformMakeTranslation(0.f, cell.frame.size.height);
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    //2. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.5];
    cell.transform = CGAffineTransformMakeTranslation(0.f, 0);
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long currencyId = indexPath.row +1;
    if(currencyId == 1){
     
        //DEBUG
       // patientService.paymentToken =     @"fdoa-541a6d7acb15a72a76023de33eb0689b541a6d7acb15a72a";
        
        //LIVE
        patientService.paymentToken =     @"fdoa-abe5329bdca28068fb315dbc8cec1383abe5329bdca28068";
        patientService.merchantId =  @"372275578881";
         patientService.Currencyid =@"USD";
        

        }
    else {
        patientService.paymentToken =       @"fdoa-75e0ecdcc14f37623bd69b7a9e2c529b75e0ecdcc14f3762";
        patientService.merchantId =    @"372838220880";
       patientService.Currencyid = @"INR";
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ForceUpdateLocation" object:self userInfo:@{@"pnumb":@"3",@"direction":kNext}];
 }




@end
