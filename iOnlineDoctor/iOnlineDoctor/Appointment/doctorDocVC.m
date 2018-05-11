//
//  doctorDocVC.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/17/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "doctorDocVC.h"
#import "DocCellXib.h"
#import "CommonServiceHandler.h"
#import "IODUtils.h"
#import "DoctorAppointmentServiceHandler.h"
#import "FileViewerVC.h"
#import "Message.h"

#import "UIImageView+WebCache.h"
#import "UIColor+HexString.h"

@interface doctorDocVC ()
{
    DoctorAppointmentServiceHandler *docService;
    NSArray *arrDocuments;
    NSMutableArray *arrMessages;
    NSMutableArray * linkArray; // mit - 17 April
    NSString *strIstructions;
    UILabel *lblNoData;
}
@end

@implementation doctorDocVC

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    [super viewDidLoad];
    [_docView setHidden:YES];
    [_linkView setHidden:YES];
    // mit - 17 April
    
    //mit - 17 April
    self.linkTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([self.linkTable respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.linkTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        _tblDoc.rowHeight=80;
    }else{
        _tblDoc.rowHeight=70;
    }
    
    arrMessages = [[NSMutableArray alloc]init];
    dateArray = [[NSMutableArray alloc]init];
    linkArray = [[NSMutableArray alloc]init]; // mit - 17 April
    _msgView.hidden = true;
    //    if (docService.isFromVideo == 0 && ![docService.visit_type isEqualToString:@"3"]) {
    //        self.viewHeight.constant = 0;
    //        self.buttonHeight = 0;
    //    }
    // Do any additional setup after loading the view.
    docService = [DoctorAppointmentServiceHandler sharedManager];
    
    
    UINib *nib = [UINib nibWithNibName:@"DocCellXib" bundle:[NSBundle mainBundle]];
    [[self tblDoc] registerNib:nib forCellReuseIdentifier:@"DocCellXib"];
    [self setUI];
}


- (void)viewDidLayoutSubviews {
    
    [_scrollv setContentSize:CGSizeMake(_scrollv.frame.size.width, 1500)];
    
}
-(void)setUI {
    [self.btnSubmit setHidden:NO];
    _tblDoc.rowHeight=70;
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSString *currentDate;
    currentDate=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    currentDate = [IODUtils ChangeDateFormat:currentDate];
    _lblDate.text = currentDate;
    
    _lblDate.text = currentDate;
    
    // NSString *currentDate=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    _txtvInstructions.layer.borderColor=[UIColor colorWithHexRGB:@"879251"].CGColor;
    _txtvaddInstruction.layer.borderColor=[UIColor colorWithHexRGB:@"879251"].CGColor;
    _txtvInstructions.layer.cornerRadius=3;
    _txtvaddInstruction.layer.borderWidth=1;
    _txtvInstructions.layer.borderWidth=1;
    _txtvaddInstruction.layer.cornerRadius=3;
    
    NSDictionary *userDict = UDGet(@"SelectedUser");
    
    if([docService.callEnd isEqualToString:@"yes"])
    {
        _lblUserName.text = [NSString stringWithFormat:@"%@",docService.patient_name];
        _lblUserAge.text = @"";
        _lblUserGender.text = [NSString stringWithFormat:@"%@",docService.patient_gender];
        if([_lblUserGender.text isEqualToString:@"<null>"] || [_lblUserGender.text isEqualToString:@"2"]){
            _lblUserGender.text = @"";
        }
        _lblDocName.text = UDGet(@"uname");;
        _lblDocGender.text = docService.doctorSpecialization;
        _lblDoctSpecialise.text= @"";
        NSInteger sda = [IODUtils calculateAge:docService.dob];
        _lblUserAge.text = [NSString stringWithFormat:@"Age: %ld",(long)sda];
        
    }
    else {
        _lblUserName.text = [NSString stringWithFormat:@"%@",[userDict valueForKey:@"patient_name"]];
        _lblUserAge.text = [NSString stringWithFormat:@"Age: %li",(long)[IODUtils calculateAge:[userDict valueForKey:@"dob"]]];
        _lblUserGender.text = [NSString stringWithFormat:@"%@",[userDict valueForKey:@"gender"]];
        if([_lblUserGender.text isEqualToString:@"<null>"] || [_lblUserGender.text isEqualToString:@"2"]){
            _lblUserGender.text = @"";
        }
        _lblDocName.text = docService.doctorName;
        _lblDocGender.text = docService.doctorGender;
        _lblDoctSpecialise.text = docService.doctorSpecialization;
    }
    
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[userDict valueForKey:@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"P-calling-icon.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [_imgView.layer setCornerRadius:_imgView.frame.size.width/2];
        
        
    }];
    CGFloat radius = _imgView.bounds.size.width / 2;
    [_imgView.layer setCornerRadius:radius];
    _imgView.clipsToBounds = YES;
    
    [_segmentedControl addTarget:self
                        action:@selector(segmentSwitch:)
              forControlEvents:UIControlEventValueChanged];
    
    [_segmentedControl.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        [obj.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UILabel class]]) {
                UILabel *_tempLabel = (UILabel *)obj;
                [_tempLabel setNumberOfLines:0];
            }
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    
    if (docService.isFromVideo == 1 && ![docService.visit_type isEqualToString:@"3"]) {
        self.viewHeight.constant = 0;
        self.buttonHeight.constant= 0;
        [self.view updateConstraints];
        
        UIView *view =[self.view viewWithTag:33];
        
        NSMutableArray *arr=[view subviews].mutableCopy ;
        [arr addObject:view];
        
        for (UIView *v in arr) {
            for (NSLayoutConstraint *cons in v.constraints) {
                
                if (cons.firstAttribute == NSLayoutAttributeHeight) {
                    cons.active=YES;
                    cons.constant=0;
                }
            }
        }
    }
    if([docService.visit_type isEqualToString:@"3"]){
        [_txtvaddInstruction setHidden:NO];
        [_txtvInstructions setHidden:NO];
        [_btnSubmit setHidden:NO];
        [_segmentedControl setHidden:NO];
        [self getVideoLinkList]; // mit - 17 April
    }
    else {
        [_segmentedControl setHidden:YES];
        self.viewHeight.constant = 0;
        self.buttonHeight.constant = 0;
        [_txtvaddInstruction setHidden:YES];
        [_txtvInstructions setHidden:YES];
    }
    
    //get Document list of patient.
    [self getAllDocumentList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat sizeCount = 0.0;
    if(tableView == _msgTable){
        Message *message = [arrMessages objectAtIndex:indexPath.row];
        NSString * strDate = [dateArray objectAtIndex:indexPath.row];
        NSString *myString = [NSString stringWithFormat:@"%@ \n\n%@",message.message,strDate];
        
        CGSize size;
        
        if(message.avatar)
        {
            size = [myString boundingRectWithSize:CGSizeMake(self.msgTable.frame.size.width - [self minInsetForCell:nil atIndexPath:indexPath] - STBubbleImageSize - 8.0f - STBubbleWidthOffset, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                          context:nil].size;
        }
        else
        {
            size = [myString boundingRectWithSize:CGSizeMake(self.msgTable.frame.size.width - [self minInsetForCell:nil atIndexPath:indexPath] - STBubbleWidthOffset, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]}
                                          context:nil].size;
        }
        
        // This makes sure the cell is big enough to hold the avatar
        if(size.height + 25.0f < STBubbleImageSize + 4.0f && message.avatar)
        {
            sizeCount = STBubbleImageSize + 4.0f;
        }
        else{
            sizeCount = size.height + 25.0f;
        }
    }
    
    if(tableView == _msgTable)
        return sizeCount;
    else if(tableView == _linkTable)
        return 35.0;
    else
        return 55.0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _msgTable){
        return arrMessages.count;
    }
    else if (tableView == _linkTable)
        return linkArray.count;
    else
        return arrDocuments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Bubble Cell";
    
    if(tableView == _tblDoc){
        
        DocCellXib *doccell=[tableView dequeueReusableCellWithIdentifier:@"DocCellXib"];
        doccell.lblCellText.text = [[arrDocuments objectAtIndex:indexPath.row] valueForKey:@"name"];
        doccell.btnDwnload.tag = indexPath.row;
        [doccell.btnView setAlpha:1.0];
        
        [ doccell.btnDwnload addTarget:self action:@selector(btnDownloadPressed:) forControlEvents:UIControlEventTouchUpInside];
        doccell.btnView.tag = indexPath.row;
        [doccell.btnDwnload setAlpha:1.0];
        
        [ doccell.btnView addTarget:self action:@selector(viewFileClicked:) forControlEvents:UIControlEventTouchUpInside];
        [doccell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return doccell;
    }
    else if (tableView == _linkTable){
        UITableViewCell * linkCell = [tableView dequeueReusableCellWithIdentifier:@"linkCell"];
        if(linkCell == nil){
            linkCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"linkCell"];
        }
        linkCell.selectionStyle = UITableViewCellSelectionStyleNone;
        linkCell.backgroundColor = [UIColor clearColor];
        NSString * strLink = [linkArray objectAtIndex:indexPath.row];
        NSMutableAttributedString * attLink = [[NSMutableAttributedString alloc]initWithString:strLink];
        [attLink addAttribute:NSLinkAttributeName value:strLink range:NSMakeRange(0, strLink.length)];
        [attLink addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, strLink.length)];
        [attLink addAttribute:NSUnderlineColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, strLink.length)];
        linkCell.textLabel.textColor = [UIColor blueColor];
        linkCell.textLabel.attributedText = attLink;
        
        return linkCell;
    }
    else {
        
        STBubbleTableViewCell *cell = (STBubbleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[STBubbleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = self.msgTable.backgroundColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.dataSource = self;
            cell.delegate = self;
        }
        
        Message *message = [arrMessages objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"ROBOTO" size:14.0];
        // cell.textLabel.text = message.message;
        if([message.userType isEqualToString:@"me"]) {
            cell.authorType = STBubbleTableViewCellAuthorTypeSelf;
            cell.bubbleColor = STBubbleTableViewCellBubbleColorGreen;
            cell.textLabel.textColor = [UIColor whiteColor];
            
            NSString * strDate = [dateArray objectAtIndex:indexPath.row];
            NSString *myString = [NSString stringWithFormat:@"%@ \n\n%@",message.message,strDate];
            //Create Alignment for Text
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setAlignment:NSTextAlignmentRight];
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
            //Define Range of Text
            NSRange range = [myString rangeOfString:strDate];
            //Add Different Color for Text
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
            //Add Alignment for Text
            [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
            //Add Font for Text
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ROBOTO" size:10.0] range:range];
            cell.textLabel.attributedText = attString;
        }
        else{
            cell.authorType = STBubbleTableViewCellAuthorTypeOther;
            cell.bubbleColor = STBubbleTableViewCellBubbleColorGray;
            cell.textLabel.textColor = [UIColor blackColor];
            
            NSString * strDate = [dateArray objectAtIndex:indexPath.row];
            NSString *myString = [NSString stringWithFormat:@"%@ \n\n%@",message.message,strDate];
            //Create Alignment for Text
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setAlignment:NSTextAlignmentRight];
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
            //Define Range of Text
            NSRange range = [myString rangeOfString:strDate];
            //Add Different Color for Text
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
            //Add Alignment for Text
            [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
            //Add Font for Text
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ROBOTO" size:10.0] range:range];
            
            cell.textLabel.attributedText = attString;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _linkTable){
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[linkArray objectAtIndex:indexPath.row]] options:@{} completionHandler:nil];
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

#pragma mark - STBubbleTableViewCellDataSource methods

- (CGFloat)minInsetForCell:(STBubbleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        return 100.0f;
    }
    
    return 20.0f;
}

#pragma mark - STBubbleTableViewCellDelegate methods

- (void)tappedImageOfCell:(STBubbleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [arrMessages objectAtIndex:indexPath.row];
    NSLog(@"%@", message.message);
}

#pragma mark - IBAction Methods

-(IBAction)SegmentChangeViewValueChanged:(UISegmentedControl *)SControl
{
    if (SControl.selectedSegmentIndex==0){
        [_msgView setHidden:YES];
        [_linkView setHidden:YES];
        if([arrDocuments count]>0){
            [_docView setHidden:NO];
            [_tblDoc reloadData];
            [self hideNoDataLabel];
        }
        else{
            [_docView setHidden:YES];
            lblNoData.hidden = false;
            [self showNoDataLabel];
        }
        NSLog(@"Document Clicked");
    }
    else if (SControl.selectedSegmentIndex==1){
        [_msgView setHidden:NO];
        [_docView setHidden:YES];
        [_linkView setHidden:YES];
        [_msgTable reloadData];
        [self hideNoDataLabel];
        NSLog(@"Message Clicked");
    }
    else if (SControl.selectedSegmentIndex==2){
        [_msgView setHidden:YES];
        [_docView setHidden:YES];
        [_linkView setHidden:NO];
        if([linkArray count]>0){
            [_linkTable reloadData];
            [self hideNoDataLabel];
        }
        else{
            [self showNoDataLabel];
        }
        NSLog(@"Message Clicked");
    }
}

-(IBAction)btnDownloadPressed:(UIButton*)sender
{
    // NSLog(@"Download Pressed");
    CommonServiceHandler *service =[[CommonServiceHandler alloc]init];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    
    NSString *fileName = [[[arrDocuments objectAtIndex:sender.tag] valueForKey:@"path"] lastPathComponent];
    
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (reachable) {
        [service downloadFilePath:[[arrDocuments objectAtIndex:sender.tag] valueForKey:@"path"] imagePath:imagePath finished:^(NSString *filePath, NSError *error) {
            if (filePath != nil) {
                //  NSLog(@"File path:%@",filePath);
                [IODUtils showFCAlertMessage:kFileDownloaded withTitle:@"" withViewController:self with:@"error"];
            } else{
                [IODUtils showFCAlertMessage:kFileNotAvailable withTitle:@"" withViewController:self with:@"error"];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }else{
         // [IODUtils showFCAlertMessage:INTERNET_ERROR withTitle:@"" withViewController:self with:@"error"];
    }
}

- (IBAction)viewFileClicked:(UIButton*)sender {
    NSString *fileName = [[arrDocuments objectAtIndex:sender.tag] valueForKey:@"path"];
    fileName = [fileName lastPathComponent];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FileViewerVC *fileviewervc = [sb instantiateViewControllerWithIdentifier:@"FileViewerVC"];
    fileviewervc.strTitle = @"Document";
    if (fileExists) {
        fileviewervc.strFilePath = [[arrDocuments objectAtIndex:sender.tag] valueForKey:@"path"];;
    }
    else {
        fileviewervc.strFilePath = [[arrDocuments objectAtIndex:sender.tag] valueForKey:@"path"];
    }
    //    [self presentViewController:fileviewervc animated:YES completion:^{
    //
    //    }];
    
    [self.navigationController pushViewController:fileviewervc animated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)showNoDataLabel
{
    lblNoData = [[UILabel alloc]init];
    lblNoData.frame = CGRectMake(0, 140, SCREEN_WIDTH, 30) ;
    
    lblNoData.center = self.view.center;
    lblNoData.text = kNodata;
    [self.view addSubview:lblNoData];
    lblNoData.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
    lblNoData.font = [UIFont boldSystemFontOfSize:18.0];
    lblNoData.textAlignment = NSTextAlignmentCenter;
    
    //               // if([docService.visit_type isEqualToString:@"3"]){
    //                    [lblNoData setHidden: YES];
    //                //}
    [self.view bringSubviewToFront:lblNoData];
}

-(void)hideNoDataLabel
{
    [lblNoData removeFromSuperview];
}

-(void) getAllDocumentList {
    CommonServiceHandler *service =[[CommonServiceHandler alloc]init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:docService.visit_id forKey:@"visitId"];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service getDocuments:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            //NSLog(@"Response code %@", responseCode);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]) {
                [arrMessages removeAllObjects];
                [dateArray removeAllObjects];
                arrDocuments = [[responseCode valueForKey:@"data"] valueForKey:@"document"];
                [_tblDoc reloadData];
                NSMutableArray * tempArray = [[responseCode objectForKey:@"data"] objectForKey:@"messages"];
                //mit
                if([tempArray count]>0){
                    for(int m=0;m<[tempArray count];m++){
                        NSDictionary * dataDic = [tempArray objectAtIndex:m];
                        NSString * strTempDate = [dataDic objectForKey:@"created_dt"];
                        NSString * strDate = [IODUtils changeFullDateToString:strTempDate];
                        NSString * strMsg = [dataDic objectForKey:@"message"];
                        //  NSString * strFinal = [NSString stringWithFormat:@"%@\n\n%@",strDate,strMsg];
                        [dateArray addObject:strDate];
                        int sendByID = [[dataDic objectForKey:@"send_by"] intValue];
                        int userId = [UDGet(@"uid") intValue];
                        if(sendByID == userId){
                            [Message messageWithString:strMsg usertype:@"me"];
                            [arrMessages addObject:[Message messageWithString:strMsg usertype:@"me"]];
                        }
                        else{
                            [Message messageWithString:strMsg usertype:@"other"];
                            [arrMessages addObject:[Message messageWithString:strMsg usertype:@"other"]];
                        }
                    }
                }
                NSString * strStatus = docService.status;
                if([strStatus isEqualToString:@"Successful"] || [strStatus isEqualToString:@"Interrupted"]){
                    _sendMsgView.hidden = true;
                }
                
                if(arrDocuments.count == 0) {
                    
                    _tablevHeight.constant = 0;
                    _docView.hidden = true;
                    
                    [self showNoDataLabel];
                }
                
                if([arrMessages count]>0){
                    [_msgTable reloadData];
                    [self hideNoDataLabel];
                    
                    [self.msgTable
                     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrMessages.count-1
                                                               inSection:0]
                     atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
                
                else if (arrDocuments.count <= 10 ){
                    _tablevHeight.constant = arrDocuments.count *80;
                    
                }
                else {
                    _tablevHeight.constant =800;
                }
                if(arrMessages.count == 0) {
                    //[_txtvInstructions setHidden:YES];
                }
                else{
                    
                    int yaxis = _tblDoc.frame.origin.y + _tblDoc.frame.size.height + 10;
                    
                    _txtvInstructions.scrollEnabled = YES;
                    [self.view layoutSubviews];
                    
                    
                    strIstructions = [arrMessages description];
                    strIstructions = [strIstructions stringByReplacingOccurrencesOfString:@"(" withString:@""];
                    strIstructions = [strIstructions stringByReplacingOccurrencesOfString:@")" withString:@""];
                    _txtvInstructions.text = strIstructions;
                    
                    [_txtvInstructions setHidden:NO];
                    
                }
                
                if([arrDocuments count]>0){
                    [_docView setHidden:NO];
                }
                
            }
        }];
    }
    else{
    }
}

-(void)getVideoLinkList
{
    CommonServiceHandler *service =[[CommonServiceHandler alloc]init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:docService.visit_id forKey:@"visitId"];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach.isReachable;
    if (reachable) {
        //  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service getVideoLinkListDRSide:parameter WithCompletionBlock:^(NSDictionary * response, NSError * error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([[response valueForKey:@"status"] isEqualToString:@"success"]) {
                NSMutableArray * tempArray = [[response valueForKey:@"data"] valueForKey:@"video_link"];
                for(int m=0;m<[tempArray count];m++){
                    NSDictionary * tempDic = [tempArray objectAtIndex:m];
                    [linkArray addObject:[tempDic objectForKey:@"link"]];
                }
                if([linkArray count]>0)
                    [_linkTable reloadData];
            }
        }];
    }
}


-(IBAction)btnSubmitPressed:(id)sender {
    if(_msgText.text.length > 0)
    {
        [_msgText resignFirstResponder];
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach.isReachable;
        if (reachable) {
            [MBProgressHUD showHUDAddedTo:self.view animated:true];
            CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
            NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
            [parameter setObject:_msgText.text forKey:@"message"];
            [parameter setObject:docService.visit_id forKey:@"patient_visit_id"];
            [service postInstructionForSecondOpinion:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
                NSLog(@"data %@", responseCode);
                [MBProgressHUD hideHUDForView:self.view animated:true];
                _msgText.text = @""; // mit - 18 april
                [self getAllDocumentList];
                
            }];
        }
        else
        {
           // //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
            //[IODUtils showFCAlertMessage:INTERNET_ERROR withTitle:@"" withViewController:self with:@"error"];
 
        }
    }
    
}
@end
