//
//  DoctorsMessage.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 4/12/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "DoctorsMessage.h"
#import "UIImageView+WebCache.h"
#import "CommonServiceHandler.h"
#import "STBubbleTableViewCell.h"
#import "Message.h"

@interface DoctorsMessage ()

@end

@implementation DoctorsMessage
@synthesize imgView,lblDocName,lblUserAge,lblUserName,lblDocGender,lblUserGender,lblDoctSpecialise,tblView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    self.title = @"Doctor's Message";
    
    docMsgData = [[NSMutableArray alloc]init];
    dateArray = [[NSMutableArray alloc]init];
    tblView.hidden = true;
    _noMsgView.hidden = true;
    
    NSDictionary * userDic = UDGet(@"UserData");
    NSLog(@"List of data:%@",_listOfdata);
    
    lblUserName.text = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"name"]];
    lblUserAge.text = [NSString stringWithFormat:@"Age: %li",(long)[IODUtils calculateAge:[userDic objectForKey:@"dob"]]];
    lblUserGender.text = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"gender"]];
    
    imgView.layer.cornerRadius = imgView.frame.size.width / 2;
    imgView.clipsToBounds = YES;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[_listOfdata valueForKey:@"doctor_profile"]] placeholderImage:[UIImage imageNamed:@"P-calling-icon.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    lblDocName.text = [NSString stringWithFormat:@"Dr. %@",[_listOfdata valueForKey:@"doctor_name"]];
    lblDocGender.text = [NSString stringWithFormat:@"%@",[_listOfdata valueForKey:@"doctor_gender"]];
    lblDoctSpecialise.text = [NSString stringWithFormat:@"%@",[_listOfdata valueForKey:@"doctor_specialization"]];
    
    
    [IODUtils showFCAlertMessage:Limited_Message_Send withTitle:@"" withViewController:self with:@"error"];

    
}

-(void)viewWillAppear:(BOOL)animated{
    _sendMsgView.hidden = true;
    [self getMessageList];
}

#pragma mark - Void Methods

-(void)getMessageList
{
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach.isReachable;
    if(reachable){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        [parameter setObject:_visitorId forKey:@"visitId"];
        CommonServiceHandler * service = [[CommonServiceHandler alloc]init];
        [service getDoctorsMessage:parameter WithCompletionBlock:^(NSDictionary * response, NSError * error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
           // NSLog(@"Response is:-%@",response);
            if([[response objectForKey:@"status"] isEqualToString:@"success"]){
                [docMsgData removeAllObjects];
                [dateArray removeAllObjects];
                NSDictionary * tempDic = [response objectForKey:@"data"];
                NSMutableArray * tempArray = [tempDic objectForKey:@"messages"];
                NSLog(@"Data Array is:-%@",tempArray);
                if([tempArray count]>0){
                    tblView.hidden = false;
                    
                    for(int m=0;m<[tempArray count];m++){
                        NSDictionary * dataDic = [tempArray objectAtIndex:m];
                        NSString * strTempDate = [dataDic objectForKey:@"created_dt"];
                        NSString * strDate = [IODUtils changeFullDateToString:strTempDate];
                        NSString * strMsg = [dataDic objectForKey:@"message"];
                        NSLog(@"Date is:%@",strDate);
                        [dateArray addObject:strDate];
                        //     NSString * strFinal = [NSString stringWithFormat:@"%@\n\n%@",strDate,strMsg];
                        int sendByID = [[dataDic objectForKey:@"send_by"] intValue];
                        int userId = [UDGet(@"uid") intValue];
                        NSLog(@"Send by id:%d userid:%d",sendByID,userId);
                        if(sendByID == userId){
                            [Message messageWithString:strMsg usertype:@"me"];
                            [docMsgData addObject:[Message messageWithString:strMsg usertype:@"me"]];
                        }
                        else{
                            [Message messageWithString:strMsg usertype:@"other"];
                            [docMsgData addObject:[Message messageWithString:strMsg usertype:@"other"]];
                        }
                    }
                }
                NSString * strStatus = [_listOfdata objectForKey:@"status"];
                if([strStatus isEqualToString:@"Successful"] || [strStatus isEqualToString:@"Interrupted"]){
                    _noMsgView.hidden = true;
                    _sendMsgView.hidden = true;
                }
                else{
                    int msgCount = [[tempDic objectForKey:@"patient_message_count"] intValue];
                    if(msgCount >= 2){
                        _noMsgView.hidden = false;
                        _sendMsgView.hidden = true;
                    }
                    else{
                        _noMsgView.hidden = true;
                        _sendMsgView.hidden = false;
                    }
                }
                [tblView reloadData];
                if([dateArray count]>0){
                    [self.tblView
                     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:docMsgData.count-1
                                                               inSection:0]
                     atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
                
                [service doctorMessageRead:parameter WithCompletionBlock:^(NSDictionary * response, NSError* error){
                   // NSLog(@"Response is:%@",response);
                }];
                
            }
        }];
    }
    else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        _sendMsgView.hidden = true;
    }
}

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBAction Methods

- (IBAction)btnSend:(UIButton *)sender {
    
    if(_textMsg.text.length >0){
        [_textMsg resignFirstResponder];
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach.isReachable;
        if(reachable){
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
            [parameter setObject:_visitorId forKey:@"patient_visit_id"];
            [parameter setObject:_textMsg.text forKey:@"message"];
            CommonServiceHandler * service = [[CommonServiceHandler alloc]init];
            [service postInstructionForSecondOpinion:parameter WithCompletionBlock:^(NSDictionary * response, NSError * error){
                _textMsg.text = @"";
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self getMessageList];
            }];
        }
        else{
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
            _sendMsgView.hidden = true;
        }
    }
}

#pragma mark - TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [docMsgData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [docMsgData objectAtIndex:indexPath.row];
    NSString * strDate = [dateArray objectAtIndex:indexPath.row];
    NSString *myString = [NSString stringWithFormat:@"%@ \n\n%@",message.message,strDate];
    
    CGSize size;
    if(message.avatar)
    {
        size = [myString boundingRectWithSize:CGSizeMake(self.tblView.frame.size.width - [self minInsetForCell:nil atIndexPath:indexPath] - STBubbleImageSize - 8.0f - STBubbleWidthOffset, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                      context:nil].size;
    }
    else
    {
        size = [myString boundingRectWithSize:CGSizeMake(self.tblView.frame.size.width - [self minInsetForCell:nil atIndexPath:indexPath] - STBubbleWidthOffset, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]}
                                      context:nil].size;
    }
    
    // This makes sure the cell is big enough to hold the avatar
    if(size.height + 25.0f < STBubbleImageSize + 4.0f && message.avatar)
    {
        return STBubbleImageSize + 4.0f;
    }
    
    return size.height + 25.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Bubble Cell";
    
    STBubbleTableViewCell *cell = (STBubbleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[STBubbleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = self.tblView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.dataSource = self;
        cell.delegate = self;
    }
    
    Message *message = [docMsgData objectAtIndex:indexPath.row];
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

#pragma mark - STBubbleTableViewCellDataSource methods

- (CGFloat)minInsetForCell:(STBubbleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        return 100.0f;
    }
    
    return 20.0f;
}

#pragma mark - STBubbleTableViewCellDelegate methods

- (void)tappedImageOfCell:(STBubbleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [docMsgData objectAtIndex:indexPath.row];
    NSLog(@"%@", message.message);
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

@end
