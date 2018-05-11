//
//  E-VisitDetailsVC.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/30/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "E-VisitDetailsVC.h"
#import "CommonServiceHandler.h"
#import "IODUtils.h"
#import "UIColor+HexString.h"
#import "E-VisitDetailCell.h"
#import "UIImageView+WebCache.h"
#import "PatientDocVC.h"
#import "PatientViewDetailVC.h"
#import "FileViewerVC.h"
#import "PatientAppointService.h"
#import "DoctorsMessage.h"
#import "ShareVideoLink.h"

@interface E_VisitDetailsVC ()
{
    PatientAppointService *patientService;
}
@end

@implementation E_VisitDetailsVC

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    [super viewDidLoad];
    self.title = _date;
    isReadDocument = false;
    UINib *nib = [UINib nibWithNibName:@"E-VisitDetailCell" bundle:[NSBundle mainBundle]];
    [[self tblView] registerNib:nib forCellReuseIdentifier:@"E_VisitDetailCell"];
    
    NSDictionary *userDict = UDGet(@"UserData");
  //  NSLog(@"User details:%@",userDict);
    _lblUserName.text = [NSString stringWithFormat:@"%@",[userDict valueForKey:@"name"]];
    _lblUserAge.text = [NSString stringWithFormat:@"Age: %li",(long)[IODUtils calculateAge:[userDict valueForKey:@"dob"]]];
    _lblUserGender.text = [NSString stringWithFormat:@"%@",[userDict valueForKey:@"gender"]];
        CGFloat radius = _imgView.bounds.size.width / 2;
    [_imgView.layer setCornerRadius:radius];
    _imgView.clipsToBounds = YES;
    patientService = [PatientAppointService sharedManager];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[_listOfdata valueForKey:@"doctor_profile"]] placeholderImage:[UIImage imageNamed:@"P-calling-icon.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    
   // NSLog(@"Pat %@",patientService.isFrom);
    
    _lblDocName.text = [NSString stringWithFormat:@"Dr. %@",[_listOfdata valueForKey:@"doctor_name"]];
    _lblDocGender.text = [NSString stringWithFormat:@"%@",[_listOfdata valueForKey:@"doctor_gender"]];
    _lblDoctSpecialise.text = [NSString stringWithFormat:@"%@",[_listOfdata valueForKey:@"doctor_specialization"]];
    // Do any additional setup after loading the view.
    
    [self getDownLoadedDocuments];
    
}

- (void)getDownLoadedDocuments{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:_visitorId forKey:@"patient_visit_id"];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (reachable) {
        [service GetDownloadDocuments:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            //    NSLog(@"responseCode:%@",responseCode);
            if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]) {
                dictlistdata = [responseCode valueForKey:@"data"];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSString *strvisitType = [NSString stringWithFormat:@"%@",patientService.visit_type_id];
                
                if([patientService.visit_type_id isEqualToString: @"3"]){
                    arrayData = [[NSArray alloc]initWithObjects:@"E-Rx",@"LAB WORK",@"DOCUMENT",@"VIEW DETAILS",@"DOCTOR'S MESSAGE",@"UPLOAD VIDEO LINK", nil];
                    arrayImages = [[NSArray alloc]initWithObjects:@"E-rx.png",@"lab.png",@"document.png",@"view-detail.png",@"doc-msg-72X72.png",@"share-circle.png", nil];
                    
                }
                else {
                    arrayData = [[NSArray alloc]initWithObjects:@"E-Rx",@"LAB WORK",@"LEAVE NOTE",@"DOCUMENT",@"VIEW DETAILS", nil];
                    arrayImages = [[NSArray alloc]initWithObjects:@"E-rx.png",@"lab.png",@"document.png",@"document.png",@"view-detail.png", nil];
                }
                [_tblView reloadData];
                
            }
        }];
    }else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    
    if (isReadDocument) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict addEntriesFromDictionary:_listOfdata];
        [dict setValue:@"" forKey:@"msg_cnt"];
        _listOfdata = dict;
        // [tableData removeObjectAtIndex:indexPath];
        [_tblView reloadData];
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayData count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    E_VisitDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:@"E_VisitDetailCell" forIndexPath:indexPath];
    
   [cell.btnDisplay setAlpha: 1.0];
    [cell.btnDownload setAlpha: 1.0];
//    
    [cell.btnDownload setHidden:NO];
    [cell.btnDisplay setHidden:NO];
//    
    if (indexPath.row == 0) {
        if (![[dictlistdata objectForKey:@"prescription"] isEqualToString:@""]) {
            cell.btnDisplay.tag = indexPath.row;
            cell.btnDownload.tag = indexPath.row;
            
            [cell.btnDownload addTarget:self action:@selector(downloadPressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDisplay addTarget:self action:@selector(viewPressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDownload setBackgroundImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
            [cell.btnDisplay setBackgroundImage:[UIImage imageNamed:@"view.png"] forState:UIControlStateNormal];
        }
       
    }
    else if (indexPath.row == 1)
    {
        if (![[dictlistdata objectForKey:@"lab-work"] isEqualToString:@""]) {
           // [cell.btnDisplay setHidden:false];
           // [cell.btnDownload setHidden:false];
            cell.btnDisplay.tag = indexPath.row;
            cell.btnDownload.tag = indexPath.row;
            [cell.btnDownload addTarget:self action:@selector(downloadPressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDisplay addTarget:self action:@selector(viewPressed:) forControlEvents:UIControlEventTouchUpInside];
          
            [cell.btnDownload setBackgroundImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
            [cell.btnDisplay setBackgroundImage:[UIImage imageNamed:@"view.png"] forState:UIControlStateNormal];
        }
    }
    
    else if (indexPath.row == 2)
    {
        if([patientService.visit_type_id isEqualToString:@"3"]){
            NSInteger visitType = [[_listOfdata valueForKey:@"visit_type"] integerValue];
            if (visitType == 3 && ![[_listOfdata valueForKey:@"msg_cnt"] isEqualToString:@""]){
            }
        }
        else {
            if (![[dictlistdata objectForKey:@"leave-note"]isEqualToString:@""]) {
             //   [cell.btnDisplay setHidden:false];
              //  [cell.btnDownload setHidden:false];
                cell.btnDisplay.tag = indexPath.row;
                cell.btnDownload.tag = indexPath.row;
                [cell.btnDownload addTarget:self action:@selector(downloadPressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnDisplay addTarget:self action:@selector(viewPressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnDownload setBackgroundImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
                [cell.btnDisplay setBackgroundImage:[UIImage imageNamed:@"view.png"] forState:UIControlStateNormal];
            }
           
        }
      
    }
    else if (indexPath.row == 3)
    {

        if([patientService.visit_type_id isEqualToString:@"3"]){
        }
        else {
            NSInteger visitType = [[_listOfdata valueForKey:@"visit_type"] integerValue];
            if (visitType == 3 && ![[_listOfdata valueForKey:@"msg_cnt"] isEqualToString:@""]){
                [cell.btnDownload setHidden:NO];
                [cell.btnDisplay setHidden:YES];
                [cell.btnDownload setBackgroundImage:nil forState:UIControlStateNormal];
                [cell.btnDownload.layer setCornerRadius:cell.btnDownload.frame.size.height/2];
                [cell.btnDownload setTitle:[_listOfdata valueForKey:@"msg_cnt"] forState:UIControlStateNormal];
                [cell.btnDownload setBackgroundColor:[UIColor colorWithHexRGB:@"#bed661"]];
                [cell.btnDownload setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else{
            }
        }
      

    
    }else if (indexPath.row == 4) {
        //Mohit
        
        if([patientService.visit_type_id isEqualToString:@"3"]){
            NSInteger visitType = [[_listOfdata valueForKey:@"visit_type"] integerValue];
            if (visitType == 3 && ![[_listOfdata valueForKey:@"msg_cnt"] isEqualToString:@""]){
                NSInteger count = [[_listOfdata valueForKey:@"msg_cnt"] integerValue];
                if(count>0){
                    [cell.btnDownload setBackgroundImage:nil forState:UIControlStateNormal];
                    [cell.btnDownload.layer setCornerRadius:cell.btnDownload.frame.size.height/2];
                    [cell.btnDownload setTitle:[_listOfdata valueForKey:@"msg_cnt"] forState:UIControlStateNormal];
                    [cell.btnDownload setBackgroundColor:[UIColor colorWithHexRGB:@"#bed661"]];
                    [cell.btnDownload setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
            }
        }
        else{
            [cell.btnDownload setHidden:YES];
            [cell.btnDisplay setHidden:YES];
        }
    }
    else
    {
        [cell.imgView setImage:[UIImage imageNamed:@""]];
    }
    
    cell.lblDetails.text = [arrayData objectAtIndex:indexPath.row];
    cell.imgView.image = [UIImage imageNamed:[arrayImages objectAtIndex:indexPath.row]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor lightGrayColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //msg_cnt


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 55;
    }else{
        return 45;
    }
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *prescription = [dictlistdata valueForKey:@"prescription"];
    NSString *labWork = [dictlistdata valueForKey:@"lab-work"];
    NSString *leaveNote = [dictlistdata valueForKey:@"leave-note"];
    NSString *docCnt = [dictlistdata valueForKey:@"doc-cnt"];
    
  //  NSLog(@"Length = %lu",(unsigned long)prescription.length);
    
    NSString *message = @"";
    
    switch (indexPath.item) {
        case 0:
            if (prescription.length == 0) {
                message = @"No prescription available";
            }else{
                //NSLog(@"Prescription: %@",prescription);
            }
            break;
        case 1:
            if (labWork.length == 0) {
                message = @"No lab work available";
            }else{
               // NSLog(@"Lab Work: %@",labWork);
            }
            break;
        case 2:
            if([patientService.visit_type_id isEqualToString:@"3"]){
                isReadDocument = true;
                
                PatientDocVC * viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"PatientDocVC"];
                viewcontroller.visitorId = _visitorId;
                viewcontroller.date = _date;
                viewcontroller.listOfdata = _listOfdata;
                [self.navigationController pushViewController:viewcontroller animated:YES];

            }
            else{
                if (leaveNote.length == 0) {
                    message = @"No leave note available";
                }else{
                    //  NSLog(@"Leave Note: %@",leaveNote);
                    
                }
            }
          
            break;
        case 3:
           
            if ([patientService.visit_type_id isEqualToString:@"3"]) {
                PatientViewDetailVC * viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"PatientViewDetailVC"];
                viewcontroller.visitorId = _visitorId;
                viewcontroller.date = _date;
                viewcontroller.listOfdata = _listOfdata;
                [self.navigationController pushViewController:viewcontroller animated:YES];
            }
            else {
                isReadDocument = true;
                
                PatientDocVC * viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"PatientDocVC"];
                viewcontroller.visitorId = _visitorId;
                viewcontroller.date = _date;
                viewcontroller.listOfdata = _listOfdata;
                [self.navigationController pushViewController:viewcontroller animated:YES];
            }
        
            break;
        case 4:
        {
            //Mohit
            if ([patientService.visit_type_id isEqualToString:@"3"]) {
                //                NSInteger count = [[_listOfdata valueForKey:@"msg_cnt"] integerValue];
                //                if(count>0){
                DoctorsMessage * docMsgVC = [self.storyboard instantiateViewControllerWithIdentifier:@"doctorMSG"];
                docMsgVC.visitorId = _visitorId;
                docMsgVC.date = _date;
                docMsgVC.listOfdata = _listOfdata;
                [self.navigationController pushViewController:docMsgVC animated:YES];
                // }
            }
            else{
                PatientViewDetailVC * viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"PatientViewDetailVC"];
                viewcontroller.visitorId = _visitorId;
                viewcontroller.date = _date;
                viewcontroller.listOfdata = _listOfdata;
                [self.navigationController pushViewController:viewcontroller animated:YES];
            }
            break;
        }
          case 5:
        {
            ShareVideoLink *ShareVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareVideoLink"];
            ShareVC.visitorId = _visitorId;
            ShareVC.date = _date;
            ShareVC.listOfdata = _listOfdata;
            
            [self.navigationController pushViewController:ShareVC animated:YES];
        }
        default:
            break;
    }
    
    if (message.length > 0) {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:nil
                                    message:message
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
        message = @"";
        
    }
}


-(IBAction)downloadPressed:(UIButton *)sender {
    NSString *filepath = @"";
    if(sender.tag == 0)
        filepath = [dictlistdata valueForKey:@"prescription"];
    else if (sender.tag == 1)
        filepath = [dictlistdata valueForKey:@"lab-work"];
    else
        filepath = [dictlistdata valueForKey:@"leave-note"];
    CommonServiceHandler *service =[[CommonServiceHandler alloc]init];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:filepath.lastPathComponent];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (reachable) {
        [service downloadFilePath:filepath imagePath:imagePath finished:^(NSString *filePath, NSError *error) {
            if (filePath != nil) {
              //  NSLog(@"File path:%@",filePath);
                [IODUtils showFCAlertMessage:kFileDownloaded withTitle:@"" withViewController:self with:@"error"];
            } else{
                [IODUtils showFCAlertMessage:kFileNotAvailable withTitle:@"" withViewController:self with:@"error"];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }else{
    }
    
}


-(IBAction)viewPressed:(UIButton *)sender {
    int tag = (int)sender.tag;
    
    FileViewerVC *fileviewervc = [self.storyboard instantiateViewControllerWithIdentifier:@"FileViewerVC"];
    if(tag == 0) {
        fileviewervc.strTitle = @"E-RX";
        fileviewervc.strFilePath = [dictlistdata valueForKey:@"prescription"];
    }
    else if (tag == 1) {
        fileviewervc.strTitle = @"Lab Work";
        fileviewervc.strFilePath = [dictlistdata valueForKey:@"lab-work"];
    }
    else {
        fileviewervc.strTitle = @"Leave Note";

        fileviewervc.strFilePath = [dictlistdata valueForKey:@"leave-note"];
    }
    [self.navigationController pushViewController:fileviewervc animated:YES];
}


-(void)refreshView:(NSNotification *) notification {
    [self getDownLoadedDocuments];
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}

@end
