//
//  InternationalDoctorTypeVCViewController.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/18/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "InternationalDoctorTypeVC.h"
#import "customXibCommonCell.h"
#import "CommonServiceHandler.h"
#import "IODUtils.h"
#import "PatientAppointService.h"
#import "RegisterPageController.h"
#import "pageViewControllerVC.h"
#import "searchDoctorVC.h"
#import "SelectPatientViewController.h"
#import "CommonServiceHandler.h"

@interface InternationalDoctorTypeVC ()
{
    NSArray *arrCategory;
    PatientAppointService *patientService;
    NSString *strSeelctedCategory;
}
@end

@implementation InternationalDoctorTypeVC

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [self.navigationController setNavigationBarHidden:FALSE animated:FALSE];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    
    patientService = [PatientAppointService sharedManager];
    // Do any additional setup after loading the view.
    UINib *nib = [UINib nibWithNibName:@"customXibCommonCell" bundle:[NSBundle mainBundle]];
    [[self tblDoctors] registerNib:nib forCellReuseIdentifier:@"customXibCommonCell"];
    // Do any additional setup after loading the view.
    _tblDoctors.contentInset = UIEdgeInsetsZero;
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    strSeelctedCategory = @"";
    BOOL reachable = reach.isReachable;
    if (reachable){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self getAllSpecialization];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    patientService.doctor_id = @"";
    patientService.slot_id = @"";
}

-(void)viewWillLayoutSubviews{
    [self.view layoutIfNeeded];
    
}
-(void)viewDidAppear:(BOOL)animated{
    // self.tabBarController.title =@"Add Member";
        self.tabBarController.title = @"Select Specialization";
       [self.view layoutIfNeeded];
    
       // NSLog(@"INTERNATIONAL DOCTOR VIEW WILL APPEAR");
     //   [self performSelectorInBackground:@selector(updateDoctorStatus) withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Update Doctor satus
- (void)updateDoctorStatus{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:patientService.doctor_id forKey:kdoctor_id];
    [parameter setObject:@"" forKey:ktime_slot_id];
    [parameter setObject:patientService.visit_type_id forKey:kvisit_type_id];
    [parameter setObject:@"0" forKey:@"status"];
    [parameter setObject:[NSNumber numberWithInt:patientService.payment_mode_id] forKey:kpayment_mode_id];
    NSLog(@"Parameter %@", parameter);
    [service updateStatus:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
    }];
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
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.buttonTitle setTitle:[[arrCategory objectAtIndex:indexPath.row] valueForKey:@"lb_price"] forState:UIControlStateNormal];
    [cell.buttonTitle setHidden:YES];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    strSeelctedCategory = [NSString stringWithFormat:@"%@",[[arrCategory objectAtIndex:indexPath.row] valueForKey:@"id"]];
    patientService.amount = [[arrCategory objectAtIndex:indexPath.row] valueForKey:@"lb_price"];
    patientService.selectedCategory = strSeelctedCategory;
    patientService.selectedCategoryName = @"international";
    if ([patientService.visit_type_id isEqualToString:@"1"]) {
       // pageViewControllerVC *pageVC=[self.storyboard instantiateViewControllerWithIdentifier:@"pageViewControllerVC"];
        //pageVC.arrPageController=@[[self.storyboard instantiateViewControllerWithIdentifier:@"medicalInfoMainVC"],[self.storyboard instantiateViewControllerWithIdentifier:@"UploadDocumentsViewController"],[self.storyboard instantiateViewControllerWithIdentifier:@"searchDoctorVC"]].mutableCopy,
        
        //[self.storyboard instantiateViewControllerWithIdentifier:@"paymentViewController"];
        
       // SelectPatientViewController *pageVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SelectPatientViewController"];
      //  [self.navigationController pushViewController:pageVC animated:YES];
        
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
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"ForceUpdateLocation" object:self userInfo:@{@"pnumb":@"1",@"direction":kNext}];
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        pageViewControllerVC *pageVC=[self.storyboard instantiateViewControllerWithIdentifier:@"pageViewControllerVC"];
        pageVC.arrPageController=@[[self.storyboard instantiateViewControllerWithIdentifier:@"medicalInfoMainVC"],[mainSB instantiateViewControllerWithIdentifier:@"UploadDocumentsViewController"],[self.storyboard instantiateViewControllerWithIdentifier:@"paymentViewController"],[self.storyboard instantiateViewControllerWithIdentifier:@"searchDoctorVC"]].mutableCopy;
        //pageVC.shouldScroll=YES;searchDoctorVC
        [self.navigationController pushViewController:pageVC animated:YES];
    }
    else {
        [IODUtils showMessage:@"Please Select category to continue" withTitle:@""];
    }
}

- (void)getAllSpecialization {
    NSDictionary *parameter = [[NSDictionary alloc] initWithObjectsAndKeys:@"2",@"categoryId",nil];
    NSString *visitId = patientService.visit_type_id;

    patientService.selectedCategoryName = @"international";
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service getAllDoctorCategories:parameter andVisitID: visitId WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        //NSLog(@"DIct %@",responseCode);
        arrCategory =  [[responseCode valueForKey:@"data"] valueForKey:@"international"];
        [self.tblDoctors reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)refreshView:(NSNotification*)notification{
    [self getAllSpecialization];
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}

@end
