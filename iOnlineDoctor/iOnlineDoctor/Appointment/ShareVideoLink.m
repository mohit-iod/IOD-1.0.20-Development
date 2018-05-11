//
//  ShareVideoLink.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 4/16/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "ShareVideoLink.h"
#import "UIImageView+WebCache.h"
#import "CommonServiceHandler.h"
#import "NSString+Validation.h"

@interface ShareVideoLink ()

@end

@implementation ShareVideoLink
@synthesize imgView,lblDocName,lblUserAge,lblUserName,lblDocGender,lblUserGender,lblDoctSpecialise,tblView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    self.title = @"Upload Video Link";
    
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([self.tblView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tblView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    dataArray = [[NSMutableArray alloc]init];
    tempLinkArray = [[NSMutableArray alloc]init];
  //  tblView.hidden = true;
    
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getLinkList];
}

-(void)getLinkList{
    
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach.isReachable;
    if(reachable){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        [parameter setObject:_visitorId forKey:@"visitId"];
        CommonServiceHandler * service = [[CommonServiceHandler alloc]init];
        [service getVideoLinkList:parameter WithCompletionBlock:^(NSDictionary * response, NSError * error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([[response objectForKey:@"status"] isEqualToString:@"success"]){
                NSMutableArray * tempArray = [[NSMutableArray alloc]init];
                tempArray = [[[response valueForKey:@"data"] valueForKey:@"video_link"] mutableCopy];
                if([tempArray count]>0)
                    dataArray = tempArray.mutableCopy;
                
                NSLog(@"Data array is %@", dataArray);
                [tblView reloadData];
                
                
            }
        }];
    }
    else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[[dataArray objectAtIndex:indexPath.row] valueForKey:@"link"] attributes:nil];
    NSRange linkRange = NSMakeRange(0, attributedString.length); // for the word "link" in the string above
    
    NSDictionary *linkAttributes = @{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0],
                                      NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
    [attributedString setAttributes:linkAttributes range:linkRange];
    
    // Assign attributedText to UILabel
    cell.textLabel.attributedText = attributedString;
    return cell;
}

#pragma mark - IBAction Methods

- (IBAction)addLink:(id)sender {
    if(dataArray.count < 5 ){
        
        if(_linkText.text.length >0){
            
            BOOL isValidUrl =  [_linkText.text isValidURL];
            if(isValidUrl == YES) {
                NSString *videoLink  = [NSString stringWithFormat:@"%@",_linkText.text];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:videoLink forKey:@"link"];
                [tempLinkArray addObject:dict];
                [dataArray addObject:dict];
                [tblView reloadData];
                tblView.hidden = false;
                _linkText.text = @"";
            }
            else{
                [IODUtils showFCAlertMessage:VALID_LINK withTitle:@"" withViewController:self with:@"error" ];
            }
            [_linkText resignFirstResponder];
                   }
        else{
            [IODUtils showFCAlertMessage:EMPTY_LINK withTitle:@"" withViewController:self with:@"error" ];
        }
    }
    else{
        [IODUtils showFCAlertMessage:MAX_LINK withTitle:@"" withViewController:self with:@"error" ];        
    }
}

- (IBAction)addLinksToAPI:(id)sender {
    if(tempLinkArray.count == 0){
        
    }
    else{
        
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach.isReachable;
        if(reachable){
            
            NSMutableDictionary * tempDic = [[NSMutableDictionary alloc]init];
            CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
            NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
            NSError *error;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:tempLinkArray options:kNilOptions error:&error];
            NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [parameter setObject:dataString forKey:@"video_link"];
            [parameter setObject:_visitorId forKey:@"patient_visit_id"];
            [MBProgressHUD showHUDAddedTo:self.view animated:true];
            
            [service addVideoLink:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [tempLinkArray removeAllObjects];
            }];
        }
        else{
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        }
    }
}

#pragma mark - Textfield Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [IODUtils setPlaceHolderLabelforTextfield:textField];
    return true;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *videoLink = [NSString stringWithFormat:@"%@", [[dataArray objectAtIndex:indexPath.row]valueForKey:@"link"]];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:videoLink];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
        }
    }];
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
