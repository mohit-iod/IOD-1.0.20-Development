//
//  localDoctorTypeVC.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/9/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "localDoctorTypeVC.h"
#import "customXibCommonCell.h"
#import "CommonServiceHandler.h"
#import "IODUtils.h"
#import "PatientAppointService.h"
#import "pageViewControllerVC.h"
#import "searchDoctorVC.h"
#import "SelectPatientViewController.h"

@interface localDoctorTypeVC ()
{
    NSArray *arrCategory;
    PatientAppointService *patientService;
    NSString *strSeelctedCategory;
}

@end

@implementation localDoctorTypeVC {
    
}

-(void)viewWillLayoutSubviews{
    [self.view layoutIfNeeded];
    
}


-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    
    //Mohit
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    [self.navigationController setNavigationBarHidden:FALSE animated:FALSE];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINib *nib = [UINib nibWithNibName:@"customXibCommonCell" bundle:[NSBundle mainBundle]];
    [[self tblDoctors] registerNib:nib forCellReuseIdentifier:@"customXibCommonCell"];
    patientService = [PatientAppointService sharedManager];
    _tblDoctors.contentInset = UIEdgeInsetsZero;
        [self.view layoutIfNeeded];

    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    strSeelctedCategory = @"";
    BOOL reachable = reach.isReachable;
    if (reachable){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self getAllSpecialization];
    }
    
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    // Do any additional setup after loading the view.
    
    //Sanjay
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        self.tblDoctors.rowHeight = UITableViewAutomaticDimension;
//        self.tblDoctors.estimatedRowHeight = 70;
//    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    patientService.doctor_id = @"";
    patientService.slot_id = @"";
    
}
-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.title =@"Select Specialization";
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
     //NSLog(@"LOCAL DOCTOR VIEW WILL APPEAR");
   // [self performSelectorInBackground:@selector(updateDoctorStatus) withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 50;
    }else{
        return 45;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrCategory.count;
}

-(customXibCommonCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    customXibCommonCell *cell=[tableView dequeueReusableCellWithIdentifier:@"customXibCommonCell" ];
    cell.imageV.image = [UIImage imageNamed:@"doc-icon.png"];
    cell.titleLAbel.text =[[arrCategory objectAtIndex:indexPath.row] valueForKey:@"name"];
//    [cell.buttonTitle setTitle:[[arrCategory objectAtIndex:indexPath.row] valueForKey:@"lb_price"] forState:UIControlStateNormal];

    [cell.buttonTitle setHidden:YES];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
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




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    strSeelctedCategory = [NSString stringWithFormat:@"%@",[[arrCategory objectAtIndex:indexPath.row] valueForKey:@"id"]];
    patientService.selectedCategory = strSeelctedCategory;
    patientService.selectedCategoryName = @"local";
    
    if ([patientService.visit_type_id isEqualToString:@"1"]) {
        searchDoctorVC *searchDoctor = [self.storyboard instantiateViewControllerWithIdentifier:@"searchDoctorVC"];
        [self.navigationController pushViewController:searchDoctor animated:YES];
    
    }
    else if ([patientService.visit_type_id isEqualToString:@"2"]) {
        searchDoctorVC *searchDoctor = [self.storyboard instantiateViewControllerWithIdentifier:@"searchDoctorVC"];
        [self.navigationController pushViewController:searchDoctor animated:YES];
    }
    else if ([patientService.visit_type_id isEqualToString:@"3"]) {
        searchDoctorVC *searchDoctor = [self.storyboard instantiateViewControllerWithIdentifier:@"searchDoctorVC"];
        [self.navigationController pushViewController:searchDoctor animated:YES];
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
- (IBAction)btnNext:(id)sender {
    if(strSeelctedCategory.length > 0) {
    }
    else {
        [IODUtils showFCAlertMessage:SELECT_CATEGORY withTitle:@"" withViewController:self with:@"error"];
    }
}

- (void)getAllSpecialization {
    NSString *visitId = patientService.visit_type_id;
    NSDictionary *parameter = [[NSDictionary alloc] initWithObjectsAndKeys:visitId,@"categoryId",nil];
        CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service getAllDoctorCategories:parameter andVisitID:visitId WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        arrCategory =  [[responseCode valueForKey:@"data"] valueForKey:@"local"];
        
        int isPracticeCallDone = [[[responseCode valueForKey:@"data"] valueForKey:@"is_practice_call_done"] intValue];
        patientService.isPracticeCallDone = isPracticeCallDone;
        [self.tblDoctors reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//Update Doctor satus
- (void)updateDoctorStatus{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:patientService.doctor_id forKey:@"doctor_id"];
    [parameter setObject:@"" forKey:@"slot_id"];
    [parameter setObject:patientService.visit_type_id forKey:@"visit_type_id"];
    [parameter setObject:@"0" forKey:@"status"];
    [parameter setObject:[NSNumber numberWithInt:patientService.payment_mode_id] forKey:kpayment_mode_id];
    NSLog(@"Parameter %@", parameter);
    [service updateStatus:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
    }];
}

//Mohit
-(void)refreshView:(NSNotification *) notification {
    [self getAllSpecialization];
}

-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}



@end
