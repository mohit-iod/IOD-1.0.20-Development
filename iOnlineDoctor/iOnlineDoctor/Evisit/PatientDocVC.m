
//
//  PatientDocVC.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 10/4/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "PatientDocVC.h"
#import "DocCellXib.h"
#import "CommonServiceHandler.h"
#import "IODUtils.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extra.h"
#import "UIColor+HexString.h"
#import "PatientAppointService.h"
#import "RegistrationService.h"
#import "FileViewerVC.h"


@interface PatientDocVC (){
    NSArray *arrDocuments;
    NSArray *arrMessages;
    PatientAppointService *patientservice;
    RegistrationService *regServCall;
}
@end

@implementation PatientDocVC

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    
    NSLog(@"Self child view controllers %@", self.childViewControllers);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        _tblDoc.rowHeight=80;
    }else{
        _tblDoc.rowHeight=70;
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Document";
    self.viewDocument.hidden = YES;
    _lblStatus.hidden = YES;
    
    [self getAllDocumentList];
    regServCall = [RegistrationService sharedManager];

    NSDictionary *userDict = UDGet(@"UserData");
   // NSLog(@"User details:%@",userDict);
    NSLog(@"User id:%@",UDGet(@"uid"));
    _lblUserName.text = [NSString stringWithFormat:@"%@",[userDict valueForKey:@"name"]];
    _lblUserAge.text = [NSString stringWithFormat:@"Age: %li",(long)[IODUtils calculateAge:[userDict valueForKey:@"dob"]]];
    _lblUserGender.text = [NSString stringWithFormat:@"%@",[userDict valueForKey:@"gender"]];
    if([_lblUserGender.text isEqualToString:@"<null>"] || [_lblUserGender.text isEqualToString:@"2"]){
        _lblUserGender.text = @"";
    }
    // Do any additional setup after loading the view.
    UINib *nib = [UINib nibWithNibName:@"DocCellXib" bundle:[NSBundle mainBundle]];
    
    [[self tblDoc] registerNib:nib forCellReuseIdentifier:@"DocCellXib"];
    
    _tblDoc.rowHeight=70;
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"dd/MMM/YYYY"];
    NSString *currentDate=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    _lblDate.text =  currentDate;
    
    _lblDocName.text = [NSString stringWithFormat:@"Dr. %@",[_listOfdata valueForKey:@"doctor_name"]];
    _lblDocGender.text = [NSString stringWithFormat:@"%@",[_listOfdata valueForKey:@"doctor_gender"]];
    _lblDoctSpecialise.text = [NSString stringWithFormat:@"%@",[_listOfdata valueForKey:@"doctor_specialization"]];
    
    NSString *color = [IODUtils setStatusColor :[_listOfdata valueForKey:@"status"]];
    [_btnStatus setBackgroundColor:[UIColor colorWithHexRGB:color]];
    [_btnStatus setTitle:[_listOfdata valueForKey:@"status"] forState:UIControlStateNormal];
 
    CGFloat radius = _imgView.bounds.size.width / 2;
    [_imgView.layer setCornerRadius:radius];
    _imgView.clipsToBounds = YES;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[_listOfdata valueForKey:@"doctor_profile"]] placeholderImage:[UIImage imageNamed:@"P-calling-icon.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
     _tblDoc.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

-(void)viewWillAppear:(BOOL)animated{

    patientservice = [PatientAppointService sharedManager];
    
    if ([patientservice.visit_type_id isEqualToString:@"3"]){
        [_documentContainerView setHidden:NO];
        [_txtInstructions setHidden:NO];
    }
    else {
        [_documentContainerView setHidden:YES];
        [_txtInstructions setHidden:YES];
        _viewHeight.constant = 0;
        [_btnSubmit setHidden:YES];
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    // Do any additional setup after loading the view.
    self.title = @"Document";
    self.viewDocument.hidden = YES;
    _lblStatus.hidden = YES;
    
  //  [self getAllDocumentList];
    regServCall = [RegistrationService sharedManager];
    
    NSDictionary *userDict = UDGet(@"UserData");
    _lblUserName.text = [NSString stringWithFormat:@"%@",[userDict valueForKey:@"name"]];
    _lblUserAge.text = [NSString stringWithFormat:@"Age: %li",(long)[IODUtils calculateAge:[userDict valueForKey:@"dob"]]];
    _lblUserGender.text = [NSString stringWithFormat:@"%@",[userDict valueForKey:@"gender"]];
    if([_lblUserGender.text isEqualToString:@"<null>"] || [_lblUserGender.text isEqualToString:@"2"]){
        _lblUserGender.text = @"";
    }
    // Do any additional setup after loading the view.
    UINib *nib = [UINib nibWithNibName:@"DocCellXib" bundle:[NSBundle mainBundle]];
    
    [[self tblDoc] registerNib:nib forCellReuseIdentifier:@"DocCellXib"];
    
    _tblDoc.rowHeight=70;
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"dd/MMM/YYYY"];
    NSString *currentDate=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    _lblDate.text =  currentDate;
    
    _lblDocName.text = [NSString stringWithFormat:@"Dr. %@",[_listOfdata valueForKey:@"doctor_name"]];
    _lblDocGender.text = [NSString stringWithFormat:@"%@",[_listOfdata valueForKey:@"doctor_gender"]];
    _lblDoctSpecialise.text = [NSString stringWithFormat:@"%@",[_listOfdata valueForKey:@"doctor_specialization"]];
    
    NSString *color = [IODUtils setStatusColor :[_listOfdata valueForKey:@"status"]];
    [_btnStatus setBackgroundColor:[UIColor colorWithHexRGB:color]];
    [_btnStatus setTitle:[_listOfdata valueForKey:@"status"] forState:UIControlStateNormal];
    
    CGFloat radius = _imgView.bounds.size.width / 2;
    [_imgView.layer setCornerRadius:radius];
    _imgView.clipsToBounds = YES;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[_listOfdata valueForKey:@"doctor_profile"]] placeholderImage:[UIImage imageNamed:@"P-calling-icon.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    _tblDoc.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrDocuments.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DocCellXib *cell=[tableView dequeueReusableCellWithIdentifier:@"DocCellXib"];
    cell.lblCellText.text = [[arrDocuments objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.lblCellText.textColor = [UIColor darkGrayColor];
    [ cell.btnDwnload addTarget:self action:@selector(btnDownloadPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnView addTarget:self action:@selector(viewFileClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDwnload.tag = indexPath.row;
    cell.btnView.tag = indexPath.row;
    
    cell.btnDwnload.alpha = 1;
    cell.btnView.alpha = 1;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

-(IBAction)btnDownloadPressed:(UIButton*)sender {
    NSLog(@"Download Pressed");
    CommonServiceHandler *service =[[CommonServiceHandler alloc]init];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (reachable) {
        [service downloadFilePath:[[arrDocuments objectAtIndex:sender.tag] valueForKey:@"path"] imagePath:@"Test" finished:^(NSString *filePath, NSError *errro) {
            if (filePath != nil) {

                [IODUtils showFCAlertMessage:@"File is successfully downloaded! Click view to view file" withTitle:@"" withViewController:self with:@"error"];

            } else{
                
                [IODUtils showFCAlertMessage:@"File is currently not available." withTitle:@"" withViewController:self with:@"error"];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
    
}

- (void)viewFileClicked:(UIButton*)sender {
    
    NSString *fileName = [[arrDocuments objectAtIndex:sender.tag] valueForKey:@"path"];
    NSString  *fName = [fileName lastPathComponent];
    
    NSString *fileExistAtPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileExistAtPath];
    if (fileExists) {
        
    }
    FileViewerVC *fileviewervc = [self.storyboard instantiateViewControllerWithIdentifier:@"FileViewerVC"];
    fileviewervc.strTitle = @"Document";
    if (fileExists) {
        fileviewervc.strFilePath = [[arrDocuments objectAtIndex:sender.tag] valueForKey:@"path"];
    }
    else {
        fileviewervc.strFilePath = [[arrDocuments objectAtIndex:sender.tag] valueForKey:@"path"];
    }
    [self.navigationController pushViewController:fileviewervc animated:YES];
}

-(void) getAllDocumentList {
    CommonServiceHandler *service =[[CommonServiceHandler alloc]init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:_visitorId forKey:@"visitId"];
    NSLog(@"Visit id:%@",_visitorId);
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (reachable) {
        [service getDocumentsPatients:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            //NSLog(@"Response code %@", responseCode);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]) {
                arrDocuments = [[responseCode valueForKey:@"data"] valueForKey:@"document"];
                arrMessages = [[[responseCode objectForKey:@"data"] valueForKey:@"messages"] valueForKey:@"message"];
                NSLog(@"Documents array is:%@",arrDocuments);
                if([arrDocuments count] == 0){
                     _tableHeight.constant = 800;
                    _documentContainerView.frame = CGRectMake(_documentContainerView.frame.origin.x,_tblDoc.frame.origin.y + _tblDoc.frame.size.height , _documentContainerView.frame.size.width, _documentContainerView.frame.size.height);
                }
                if(arrDocuments.count <= 10){
                    _tableHeight.constant = arrDocuments.count *80;
                }
                else {
                        _tableHeight.constant = 800;
                }
                if([patientservice.visit_type_id isEqualToString:@"3"] || [patientservice.visit_type_id isEqualToString:@"4"]) {
                    [_txtInstructions setHidden:NO];
                    NSString *strMessages = [arrMessages description];
                    strMessages = [strMessages stringByReplacingOccurrencesOfString:@"(" withString:@""];
                    strMessages = [strMessages stringByReplacingOccurrencesOfString:@")" withString:@""];
                    strMessages = [strMessages stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    strMessages = [strMessages stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    if([strMessages containsString:@"\n"]){
                        strMessages = [strMessages stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
                    }
                    
                    strMessages = [strMessages stringByReplacingOccurrencesOfString:@"\n" withString:@""];

                    _lblStatus.hidden = YES;
                    _txtInstructions.text = strMessages;
                    
                    NSArray * items = [strMessages componentsSeparatedByString:@","];
                    NSArray *arrVitals;
                    NSMutableString *strAppend = [NSMutableString string];
                    NSMutableString * bulletList = [NSMutableString stringWithCapacity:items.count*60];
                    for (int j=0; j<items.count; j++) {
                        NSString *strVitals = [items objectAtIndex:j];
                        
                        if (strVitals.length > 0) {
                            if (![strVitals isEqualToString:@" "]) {
                                
                                [bulletList  appendString:[NSString stringWithFormat:@"\u2022 %@\n\n",strVitals]];
                            }
                        }
                    }
                    _txtInstructions.text = bulletList;
                    
                    _txtInstructions.layer.borderColor=[UIColor colorWithHexRGB:@"879251"].CGColor;
                    _txtInstructions.layer.cornerRadius=3;
                    _txtInstructions.layer.borderWidth=1;
                    [_documentContainerView setHidden:NO];
                    [_txtInstructions setHidden:NO];
                    }
                    else {
                        [_txtInstructions setHidden:YES];
                        if(arrDocuments.count == 0){
                            self.viewDocument.hidden = YES;
                            _viewHeight.constant = 0;
                            _buttonHeight.constant = 0;
                            _tblDoc.hidden = YES;
                            [_btnSubmit setHidden:YES];
                           _lblStatus.hidden = YES;
                            _lblStatus.center = self.view.center;
                            [_txtInstructions setHidden:YES];
                        }
                    }
                }
                else{
                    self.viewDocument.hidden = NO;
                    _tblDoc.hidden = NO;
                    _lblStatus.hidden = YES;
                    [_btnSubmit setHidden:NO];
                    
                }
                [_tblDoc reloadData];
            _txtInstructions.editable = NO;
            
        }];
    }
    else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}

- (IBAction)btnsubmitPressed:(id)sender {
    
    //mit - doc New
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:_visitorId forKey:@"patient_visit_id"];
    RegistrationService *service = [[RegistrationService alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   // NSLog(@"type array is:%@",regServCall.arrDocType);
    [service postSecondOpinionDocuments:parameter andImageName:regServCall.nameArray andImages:regServCall.imageData dataType:regServCall.arrDocType WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        if (responseCode){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
          //  NSLog(@"Response Code is:%@",responseCode);
            if([[responseCode objectForKey:@"status"] isEqualToString:@"success"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCollectionview" object:nil];
                
                patientservice.arrDocumentData = [[NSMutableArray alloc]init];
                patientservice.documentName =[[NSMutableArray alloc]init];
                [regServCall.nameArray removeAllObjects];
                [regServCall.imageData removeAllObjects];
                [regServCall.arrDocType removeAllObjects];
                [IODUtils showFCAlertMessage:@"Documents saved succssfully" withTitle:@"" withViewController:self with:@"error"];
                [self getAllDocumentList];
            }
        }
    }];
    
}

-(void)refreshView:(NSNotification *) notification {
    [self getAllDocumentList];
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}


@end
