//
//  addMemberVC.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/4/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "addMemberVC.h"
#import "addMemberCell.h"
#import "CommonServiceHandler.h"
#import "addMemberRegisterVC.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "UIColor+HexString.h"


@interface addMemberVC ()
{
    NSMutableArray *memberArray;
    UILabel *lblNoData;
}

@end

@implementation addMemberVC

#pragma mark - View Controller Methods

- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"addMemberCell" bundle:[NSBundle mainBundle]];
    [[self tblMember] registerNib:nib forCellReuseIdentifier:@"memberCell"];
        // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.title =@"Add Member";
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach.isReachable;
    if (reachable)
        [self getAllMembers];
    else
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    lblNoData = [[UILabel alloc]init];
    lblNoData.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30) ;
    lblNoData.center = self.view.center;
    lblNoData.text = kNodata;
    [self.view addSubview:lblNoData];
    [lblNoData setHidden:YES];
    
}

#pragma mark - Tableview Delegate & Datasource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return memberArray.count;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    addMemberCell *cell=[tableView dequeueReusableCellWithIdentifier:@"memberCell"];
    NSString *strAge =[[memberArray objectAtIndex:indexPath.row]valueForKey:@"dob"];

    cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[memberArray objectAtIndex:indexPath.row]valueForKey:@"name"]];
    NSInteger age = [IODUtils calculateAge:strAge];
    strAge = [NSString stringWithFormat:@"Age: %ld",(long)age];
    [cell.btnAge.layer setCornerRadius:15.0];
    [cell.btnAge setTitle:strAge forState:UIControlStateNormal];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    addMemberRegisterVC *addMember = [sb instantiateViewControllerWithIdentifier:@"addMemberRegisterVC"];
    addMember.isEdit = @"yes";
    addMember.dob = [IODUtils formateStringToDateForUI:[[memberArray objectAtIndex:indexPath.row] valueForKey:@"dob"]];
    addMember.fullname = [NSString stringWithFormat:@"%@",[[memberArray objectAtIndex:indexPath.row]valueForKey:@"name"]];
    
    addMember.email = [NSString stringWithFormat:@"%@",[[memberArray objectAtIndex:indexPath.row]valueForKey:@"email"]];
    
    //addMember.txtPhone.text= [NSString stringWithFormat:@"%@",[[memberArray objectAtIndex:indexPath.row]valueForKey:@"mobile"]];
    
    addMember.mobile = [[memberArray objectAtIndex:indexPath.row]valueForKey:@"mobile"];
    addMember.gender =[IODUtils getGender:[[memberArray objectAtIndex:indexPath.row]valueForKey:@"gender"]];
    addMember.mid = [[memberArray objectAtIndex:indexPath.row]valueForKey:@"id"];
    
    [self.navigationController pushViewController:addMember animated:YES];
}

#pragma mark - Void Methods

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) getAllMembers{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service getAllMembersWithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        //NSLog(@"DIct %@",responseCode);
        memberArray =  [responseCode valueForKey:@"data"];
        [self.tblMember reloadData];
     
        if(memberArray.count == 0) {
            [self.tblMember setHidden:YES];
          
            [lblNoData setHidden:NO];
            [self.view bringSubviewToFront:lblNoData];
            lblNoData.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
            lblNoData.font = [UIFont boldSystemFontOfSize:18.0];
            lblNoData.textAlignment = NSTextAlignmentCenter;
        }
        else {
            [lblNoData removeFromSuperview];
            [_tblMember setHidden:NO];
            [lblNoData setHidden: YES];
            [self.view bringSubviewToFront:_tblMember];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } ];
    
}

#pragma mark - IBAction Methods

-(IBAction)addNewMember:(id)sender {
    addMemberRegisterVC *addMember = [[addMemberRegisterVC alloc] init];
    addMember.isEdit = @"no";
    [self.navigationController pushViewController:addMember animated:YES];
}
@end
