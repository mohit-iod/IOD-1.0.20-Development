    //
//  EVisitVC.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/21/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//set-calender

#import "EVisitVC.h"
#import "PatientEvisitDetailViewController.h"
#import "UIColor+HexString.h"
#import "DoctorAppointmentServiceHandler.h"
#import "CommonServiceHandler.h"
@interface EVisitVC ()
{
    PatientVisitServiceHandler *patientVisitHandler;
    DoctorAppointmentServiceHandler *doctorService;
}
@end

@implementation EVisitVC

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    
//    _lblStatus.hidden = YES;
//    _tblEVisit.hidden = YES;
    
    UINib *nib = [UINib nibWithNibName:@"E_VisitCell" bundle:[NSBundle mainBundle]];
    [[self tblEVisit] registerNib:nib forCellReuseIdentifier:@"E_VisitCell"];
    
    patientVisitHandler = [PatientVisitServiceHandler sharedManager];
    doctorService = [DoctorAppointmentServiceHandler sharedManager];
    NSString *selectedPatientId = patientVisitHandler.patient_id;
    [self getPatientVisit:selectedPatientId];
    _tblEVisit.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];    
}



-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"%@",patientVisitHandler.patient_name);
    
    self.tabBarController.title = patientVisitHandler.patient_name;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) getPatientVisit:(NSString *)patientId {
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:patientId forKey:@"patient_id"];
    [parameter setObject:patientVisitHandler.member_id forKey:@"member_id"];
    
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (reachable) {
        [service getAllPatienVisitData:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            //NSLog(@"Response code is %@", responseCode);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([[responseCode objectForKey:@"status"] isEqualToString:@"success"]) {
                responseCode = [responseCode valueForKey:@"data"];
                if(responseCode.count >0){
                    NSArray *arrEvisit  =[responseCode objectForKey:@"E-Visits"];
                    NSArray *arrSecondOpinion = [responseCode objectForKey:@"Second Optinion"];
                    patientVisitHandler.evisit = [arrEvisit mutableCopy];
                    patientVisitHandler.secondOpinion = [arrSecondOpinion mutableCopy];
                    if ([arrEvisit count] > 0) {
                        _lblStatus.hidden = YES;
                        _tblEVisit.hidden = NO;
                    }
                    else{
                        _lblStatus = [[UILabel alloc] init];
                        _lblStatus.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
                        _lblStatus.center = self.view.center;
                        _lblStatus.textAlignment = NSTextAlignmentCenter;
                        _lblStatus.hidden = NO;
                        _lblStatus.font = [UIFont boldSystemFontOfSize:18.0];
                        _lblStatus.text = kNodata;
                        _lblStatus.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
                        _tblEVisit.hidden = YES;
                        [self.view addSubview:_lblStatus];
                        
                    }

                }
                else{
                    _lblStatus = [[UILabel alloc] init];
                    _lblStatus.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
                    _lblStatus.center = self.view.center;
                    _lblStatus.textAlignment = NSTextAlignmentCenter;
                    _lblStatus.hidden = NO;
                    _lblStatus.font = [UIFont boldSystemFontOfSize:18.0];
                    _lblStatus.text = kNodata;
                    _lblStatus.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
                    _tblEVisit.hidden = YES;
                    [self.view addSubview:_lblStatus];
                }
        }
            [_tblEVisit reloadData];
        }];
    }
    else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return patientVisitHandler.evisit.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    E_VisitCell *cell=[tableView dequeueReusableCellWithIdentifier:@"E_VisitCell"];
    NSString *strDate = [[patientVisitHandler.evisit objectAtIndex:indexPath.row]valueForKey:@"date"];
    NSString  *dt = [IODUtils formatDateForUIFromString:strDate];
    
    cell.lblDoctorName.text =[NSString stringWithFormat:@"Dr. %@",[[patientVisitHandler.evisit objectAtIndex:indexPath.row]valueForKey:@"doctor_name"] ];
    
    [cell.btnStatus setTitle:[[patientVisitHandler.evisit objectAtIndex:indexPath.row]valueForKey:@"status"] forState:UIControlStateNormal];
    NSString *colo = [IODUtils setStatusColor :[[patientVisitHandler.evisit objectAtIndex:indexPath.row]valueForKey:@"status"]];
    [cell.btnStatus setBackgroundColor:[UIColor colorWithHexRGB:colo]];
    cell.lblDate.text = dt;
    NSString *aptTime = [IODUtils substringVisitTime:[[patientVisitHandler.evisit objectAtIndex:indexPath.row]valueForKey:@"start_time"]];
    cell.lblAptTime.text = [NSString stringWithFormat:@"Apt.Time: %@",aptTime];
    
    NSString *visitType =[NSString stringWithFormat:@"%@",[[patientVisitHandler.evisit objectAtIndex:indexPath.row]valueForKey:@"visit_type"]];
    NSString *imageNAame;
    
    if([visitType isEqualToString:@"1"]){
        visitType = @"Live Call";
        imageNAame = @"LC.png";
    }
    
    else if ([visitType isEqualToString:@"2"]){
        visitType = @"Book Appointment";
        imageNAame = @"BA.png";
        
    }
    else if([visitType isEqualToString:@"3"]){
        visitType = @"2nd Opinion";
        imageNAame = @"SO.png";
        
    }
    else {
        visitType =  @"";
        
    }
    cell.lblAppointmentType.text = [NSString stringWithFormat:@"%@",visitType];
    [cell.imgV setImage:[UIImage imageNamed:imageNAame]];
    

    
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 120;
    }
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strStatus = [[patientVisitHandler.evisit objectAtIndex:indexPath.row] valueForKey:@"status"];
     doctorService.isFromVideo = 0;
NSString *strisFilled = [NSString stringWithFormat:@"%@",[[patientVisitHandler.evisit objectAtIndex:indexPath.row] valueForKey:@"is_filled"]];    
    
    NSString *strdoctoeselectedId = [NSString stringWithFormat:@"%@",[[patientVisitHandler.evisit objectAtIndex:indexPath.row] valueForKey:@"doctor_id"]];
    
    doctorService.selctedDoctorId = strdoctoeselectedId;
    
    if([strStatus isEqualToString:@"Call drop"] || [strStatus isEqualToString:@"Missed"] || ([strStatus isEqualToString:@"Disconnected"])) {
    }
    else if([strStatus isEqualToString:@"Cancelled"]) {
        NSString *strReason = [NSString stringWithFormat:@"Patient cancelled appointment due to %@",[[patientVisitHandler.evisit objectAtIndex:indexPath.row] valueForKey:@"reason"]];
       // [IODUtils showMessage:strReason withTitle:@""];
        [IODUtils showFCAlertMessage:strReason withTitle:@"" withViewController:self with:@"error"];
    }
    //reason
    else {
        NSDictionary *dictList = [patientVisitHandler.evisit objectAtIndex:indexPath.row];
        PatientEvisitDetailViewController * viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"PatientEvisitDetailViewController"];
        doctorService.visit_id = dictList[@"patient_visit_id"];
        doctorService.visit_type = @"2";
        doctorService.status = dictList[@"status"];
        doctorService.dateAppnt = dictList[@"date"];
        doctorService.doctorName = dictList[@"doctor_name"];
        doctorService.doctorSpecialization = dictList[@"doctor_specialization"];
        doctorService.doctorGender = dictList[@"doctor_gender"];
        doctorService.doctorProfile = dictList[@"doctor_profile_pic"];
        doctorService.callEnd =@"no";
        doctorService.isFilled = strisFilled;
        
        [self.navigationController pushViewController:viewcontroller animated:YES];
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
