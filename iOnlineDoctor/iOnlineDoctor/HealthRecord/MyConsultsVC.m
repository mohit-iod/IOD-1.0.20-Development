//
//  MyConsultsVC.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 10/5/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "MyConsultsVC.h"
#import "E_VisitCell.h"
#import "CommonServiceHandler.h"
#import "IODUtils.h"
#import "DoctorAppointmentServiceHandler.h"
#import "UIColor+HexString.h"
#import "E-VisitDetailsVC.h"
#import "PatientAppointService.h"
#import "PatientVideoCallViewController.h"

@interface MyConsultsVC ()
{
     PatientAppointService *patientService;
    NSTimer *myTimer;
    NSString *visitType;
    NSString *cancelAppointmentReason;
    NSString *visitorId;
}
@end

@implementation MyConsultsVC

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    patientService = [PatientAppointService sharedManager];
    [self getAllEvisitData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tableData = [[NSMutableArray alloc]init];
    
    visitType = patientService.visit_type_id;
    //if([patientService.visit_type_id isEqualToString:@"3"]){
        self.title = @"SECOND OPINION";
  //  }
 //   else{
  //      self.title = @"SECOND OPINION";
 //       self.tabBarController.title = @"Second Opinion";
  //  }
 
    _lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, self.view.frame.size.height / 2, SCREEN_WIDTH, 30)];
    [self.view addSubview:_lblStatus];
    _lblStatus.text = kNodata;
    _lblStatus.textAlignment = NSTextAlignmentCenter;
    _lblStatus.font = [UIFont boldSystemFontOfSize:18.0];
    _lblStatus.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
    
    [_lblStatus sizeToFit];
    
    _lblStatus.hidden = YES;
    _tblEVisit.hidden = YES;
  
    _lblStatus.textAlignment = NSTextAlignmentCenter;
     patientService.visit_type_id = @"3";
    
    _tblEVisit.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAllEvisitData {
        CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
        if([patientService.visit_type_id isEqualToString:@"3"]){
        [parameter setObject:@"/pending" forKey:@"visitType"];
        }
        else {
        [parameter setObject:@"none" forKey:@"visitType"];
        }
    
    patientService.visit_type_id = @"3";

    if (reachable) {
            [service getEvisitlist:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
                if(responseCode) {
                    tableData = [[responseCode valueForKeyPath:@"data.Second Optinion"] mutableCopy];
                    if ([tableData count] > 0) {
                        _lblStatus.hidden = YES;
                        _tblEVisit.hidden = NO;
                    }else{
                        UILabel *lblNoData = [[UILabel alloc]init];
                        lblNoData.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30) ;
                        lblNoData.center = self.view.center;
                        lblNoData.text = kNodata;
                        [self.view addSubview:lblNoData];
                        lblNoData.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
                        lblNoData.font = [UIFont boldSystemFontOfSize:18.0];
                        lblNoData.textAlignment = NSTextAlignmentCenter;
                        _tblEVisit.hidden = YES;
                    }
                    [_tblEVisit reloadData];
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [_tblEVisit reloadData];
                }
            }];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        }
        
}

#pragma mark - Tableview Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 110;
    }else{
        return 90;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"E_VisitCell";
    
    E_VisitCell *cell = (E_VisitCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"E_VisitCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *dictList = [tableData objectAtIndex:indexPath.row];
    
    cell.lblDate.text = [NSString stringWithFormat:@"%@",[dictList valueForKey:@"date"]];
    ;
    
    
    if ([[NSString stringWithFormat:@"%@",[dictList valueForKey:@"total_count"]] isEqualToString:@"0"]){
        [cell.btnBadge setHidden:YES];
        [cell.btnBadge setTitle:[NSString stringWithFormat:@"%@",[dictList valueForKey:@"total_count"]] forState:UIControlStateNormal];
    }
    else{
        [cell.btnBadge setHidden:NO];
        [cell.btnBadge setTitle:[NSString stringWithFormat:@"%@",[dictList valueForKey:@"total_count"]] forState:UIControlStateNormal];
    }
    
    if ([[NSString stringWithFormat:@"%@",[dictList valueForKey:@"status"]] isEqualToString:@"Pending"])
    {
        cell.btnStatus.backgroundColor = [[UIColor colorWithHexRGB:@"#d7c223"] colorWithAlphaComponent:1.0];
    }
    else if([[NSString stringWithFormat:@"%@",[dictList valueForKey:@"status"]] isEqualToString:@"Cancelled"])
    {
        cell.btnStatus.backgroundColor = [[UIColor colorWithHexRGB:@"#646564"] colorWithAlphaComponent:1.0];
    }
    else if([[NSString stringWithFormat:@"%@",[dictList valueForKey:@"status"]] isEqualToString:@"Call drop"])
    {
        cell.btnStatus.backgroundColor = [[UIColor colorWithHexRGB:@"#df1b1d"] colorWithAlphaComponent:1.0];
    }
    else if([[NSString stringWithFormat:@"%@",[dictList valueForKey:@"status"]] isEqualToString:@"Disconnected"])
    {
        cell.btnStatus.backgroundColor = [[UIColor colorWithHexRGB:@"#df1b1d"] colorWithAlphaComponent:1.0];
    }
    else if([[NSString stringWithFormat:@"%@",[dictList valueForKey:@"status"]] isEqualToString:@"Missed"])
    {
        cell.btnStatus.backgroundColor = [[UIColor colorWithHexRGB:@"#1FBDE4"] colorWithAlphaComponent:1.0];
    }
    
    else
    {
        cell.btnStatus.backgroundColor = [[UIColor colorWithHexRGB:@"#51a53d"] colorWithAlphaComponent:1.0];
    }
    NSString *strdata = [NSString stringWithFormat:@"%@ %@",[dictList valueForKey:@"date"],[dictList valueForKey:@"start_time"]];
    NSString *typeOfdisplaybtn = [IODUtils DisplayCallbutton:strdata :[dictList valueForKey:@"status"]];

    
    if ([typeOfdisplaybtn isEqualToString:@"cancel"] || [typeOfdisplaybtn isEqualToString:@"nandisplay"]) {
         [cell.btncall setHidden:YES];

    }
    else if([typeOfdisplaybtn isEqualToString:@"CALL NOW"]) {
        [cell.btncall setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [cell.btncall setHidden:NO];
        [cell.btncall setUserInteractionEnabled:true];
        [cell.btncall setTitle:@"CALL NOW" forState:UIControlStateNormal];

    }
    else
    {
        [cell.btncall setHidden:NO];
    }
    [cell.btncall addTarget:self action:@selector(BtnCallPress:) forControlEvents:UIControlEventTouchUpInside];
    cell.btncall.tag = indexPath.row;
    
    [cell.btnStatus setTitle:[NSString stringWithFormat:@"%@",[dictList valueForKey:@"status"]] forState:UIControlStateNormal];
    cell.lblDate.text = [self ChangeDateFormat:[NSString stringWithFormat:@"%@",[dictList valueForKey:@"date"]]];
    NSString *aptTime = [IODUtils substringVisitTime:[dictList valueForKey:@"start_time"]];
    cell.lblAptTime.text = [NSString stringWithFormat:@"Apt.Time: %@",aptTime];
    cell.lblDoctorName.text = [NSString stringWithFormat:@"Dr. %@",[dictList valueForKey:@"doctor_name"]];
    cell.lblAppointmentType.text = @"2nd Opinion";
    [cell.imgV setImage:[UIImage imageNamed:@"SO.png"]];
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
    NSDictionary *dictList = [tableData objectAtIndex:indexPath.row];
    
    if(([[dictList valueForKey:@"status"] isEqualToString:@"Call drop"]) ||([[dictList valueForKey:@"status"] isEqualToString:@"Missed"]) || ([[dictList valueForKey:@"status"] isEqualToString:@"Cancelled"]) || [[dictList valueForKey:@"status"] isEqualToString:@"Disconnected"] ){
    }
    else{
        E_VisitDetailsVC * viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"E_VisitDetailsVC"];
        viewcontroller.date = [self ChangeDateFormat:[NSString stringWithFormat:@"%@",[dictList valueForKey:@"date"]]];
        viewcontroller.visitorId = dictList[@"patient_visit_id"];
        viewcontroller.listOfdata = dictList;
        [self.navigationController pushViewController:viewcontroller animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
    //        bundle: nil];
   
    //    if (indexPath.section == 0 && indexPath.row == 0) {
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictList = [tableData objectAtIndex:indexPath.row];
    NSString *strdata = [NSString stringWithFormat:@"%@ %@",[dictList valueForKey:@"date"],[dictList valueForKey:@"start_time"]];
    NSString *typeOfdisplaybtn = [IODUtils DisplayCallbutton:strdata :[dictList valueForKey:@"status"]];
    if ([typeOfdisplaybtn isEqualToString:@"cancel"]) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        NSDictionary *dictList = [tableData objectAtIndex:indexPath.row];
        visitorId = [NSString stringWithFormat:@"%@",[dictList valueForKey:@"patient_visit_id"]];
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:nil
                                     message:kAskCancelAppointment
                                     preferredStyle:UIAlertControllerStyleAlert];
        //Add Buttons
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                    //[self CancelBooking:visitorId : indexPath.row];
                                        [self setCancelAppointmentReason];
                                    }];
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        //Add your buttons to alert controller
        [alert addAction:yesButton];
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)setCancelAppointmentReason{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Choose Reason" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:kBusy style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        cancelAppointmentReason  = kBusy;
        [self CancelBooking:visitorId];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:kNoConsultation style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        cancelAppointmentReason  = kNoConsultation;
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
   
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Other" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.CancelAppointmentView =[ [UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        UIView *v = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, 280, 180)];
        v.center = self.CancelAppointmentView.center;
        [self.CancelAppointmentView addSubview:v];
        [v.layer setBorderWidth:2.0];
        v.backgroundColor = [UIColor whiteColor];
        [v.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [v.layer setCornerRadius:4.0];
        
        UILabel *reason = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 240, 20)];
        reason.text = kCancelApptReason;
        [v addSubview:reason];
        
        _txtv = [[UITextView alloc] initWithFrame:CGRectMake(20, 55, 240, 70)];
        [v addSubview:_txtv];
        [_txtv.layer setBorderWidth:1.0];
        [v bringSubviewToFront:reason];
        [v bringSubviewToFront:_txtv];
        
        
        UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(30, 140, 100, 30)];
        
        [btnSubmit setBackgroundColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
        [btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
        [v addSubview:btnSubmit];
        
        
        UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(150, 140, 100, 30)];
        
        [btnCancel setBackgroundColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
        [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [v addSubview:btnCancel];
        
        
        [btnCancel addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnSubmit addTarget:self action:@selector(submitPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.CancelAppointmentView.center = self.view.center;
        [self.view addSubview:self.CancelAppointmentView];
        [self.view bringSubviewToFront:self.CancelAppointmentView];
        [self initialDelayEnded];
        
        [self dismissViewControllerAnimated:YES completion:^{
            //   [self initialDelayEnded];
        }];
    }]];
      
        // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}



-(IBAction)cancelPressed:(id)sender{
    [self.CancelAppointmentView removeFromSuperview];
}

-(IBAction)submitPressed:(id)sender{
    if(_txtv.text.length == 0){
        
        [IODUtils showFCAlertMessage:@"Please mention reason" withTitle:@"" withViewController:self with:@"error"];

    }
    else if(_txtv.text.length > 140){
        
        [IODUtils showFCAlertMessage:@"Allows only 140 characters" withTitle:@"" withViewController:self with:@"error"];
    }
    else{
        
        cancelAppointmentReason = _txtv.text;
        [self CancelBooking:visitorId];
        [_CancelAppointmentView removeFromSuperview];
    }
}

-(void)initialDelayEnded {
    self.CancelAppointmentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    self.CancelAppointmentView.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.CancelAppointmentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    }completion:^(BOOL complete){
        [UIView animateWithDuration:0.3 animations:^{
            self.CancelAppointmentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        }completion:^(BOOL complete){
            [UIView animateWithDuration:0.3 animations:^{
                self.CancelAppointmentView.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}


- (NSString *) ChangeDateFormat : (NSString *) toDate
{
    NSString *toDateCheck;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString: toDate]; // here you can fetch date from string with define format
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MMM/yyyy"];// here set format which you want...
    toDateCheck = [dateFormatter stringFromDate:date]; //here convert date in NSString
    return toDateCheck;
}

-(void)BtnCallPress:(UIButton*)sender
{
    NSDictionary *dictList = [tableData objectAtIndex:sender.tag];
    visitorId = [NSString stringWithFormat:@"%@",[dictList valueForKey:@"patient_visit_id"]];
    NSString *strdata = [NSString stringWithFormat:@"%@ %@",[dictList valueForKey:@"date"],[dictList valueForKey:@"start_time"]];
    NSString *typeOfdisplaybtn = [IODUtils DisplayCallbutton:strdata :[dictList valueForKey:@"status"]];
    if ([typeOfdisplaybtn isEqualToString:@"CALL NOW"]) {
        [self postCallSessionInformation:visitorId index:(int)sender.tag];
    }else{
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:nil
                                    message:kTimeover
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        //Add your buttons to alert controller
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)postCallSessionInformation:(NSString*)visit_id index:(int)index{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:visit_id forKey:@"patient_visit_id"];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (reachable) {
        [service getCallSessionInformation:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            patientService.res_call_duration = [[responseCode valueForKey:@"data"] valueForKey:@"call_duration"];
            patientService.res_doctor_address = [[responseCode valueForKey:@"data"] valueForKey:@"doctor_address"];
            patientService.res_doctor_id = [[responseCode valueForKey:@"data"] valueForKey:kdoctor_id];
            patientService.res_doctor_name = [[responseCode valueForKey:@"data"] valueForKey:@"doctor_name"];
            patientService.res_profile_pic = [[responseCode valueForKey:@"data"] valueForKey:@"profile_pic"];
            patientService.res_session_id = [[responseCode valueForKey:@"data"] valueForKey:@"session_id"];
            patientService.res_session_token = [[responseCode valueForKey:@"data"] valueForKey:@"session_token"];
            patientService.res_visit_id = [[responseCode valueForKey:@"data"] valueForKey:@"visit_id"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            PatientVideoCallViewController *patientVideoCallVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PatientVideoCallViewController"];
            [self.navigationController pushViewController:patientVideoCallVC animated:YES];
        }];
    }else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}


- (void) CancelBooking : (NSString *) visit{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:visitorId forKey:@"visitId"];
    patientService.visit_type_id = @"4";
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    NSMutableDictionary *reason = [[NSMutableDictionary alloc] init];
    [reason setObject:cancelAppointmentReason forKey:@"reason"];

    BOOL reachable = reach. isReachable;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (reachable) {
   [service getCancelAppointment:parameter andReason:reason WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
       
       if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]) {
           //[responseCode valueForKey:@"message"];
           UIAlertController *alert = [UIAlertController
                                       alertControllerWithTitle:nil
                                       message:[responseCode valueForKey:@"message"]
                                       preferredStyle:UIAlertControllerStyleAlert];
           UIAlertAction* okButton = [UIAlertAction
                                      actionWithTitle:@"OK"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action) {
                                          //Handle no, thanks button
                                      }];
           
           //Add your buttons to alert controller
           [alert addAction:okButton];
           [self presentViewController:alert animated:YES completion:nil];
           [self getAllEvisitData];
       }
       [MBProgressHUD hideHUDForView:self.view animated:YES];
       
   }];

    }else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    myTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(reloadTable) userInfo:nil repeats:YES];
}


-(void)viewDidAppear:(BOOL)animated{
        self.tabBarController.title = @"Second Opinion";
}

- (void)reloadTable {
    [_tblEVisit reloadData];
}

-(void)viewDidDisappear:(BOOL)animated{
    [myTimer invalidate];
}

-(void)refreshView:(NSNotification *) notification {
    [self getAllEvisitData];
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}


@end
