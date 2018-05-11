//
//  PatientListViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/30/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "PatientListViewController.h"
#import "CommonServiceHandler.h"
#import "invoiceCell.h"
#import "UIImageView+WebCache.h"
#import "PatientVisitServiceHandler.h"
#import "E_VisitCell.h"
#import "PatientListCell.h"
#import "UIColor+HexString.h"


@interface PatientListViewController ()
{
    NSArray *arrPatientList, *searchResultsArray;
    PatientVisitServiceHandler *patientServiceHandler;
    
    //UILabel *headerLabel;
    
}
@property (nonatomic, strong) NSMutableArray *isShowingList;
@property (nonatomic, assign) NSInteger openSectionIndex;

@end

@implementation PatientListViewController

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    [self.navigationController setNavigationBarHidden:FALSE animated:FALSE];
    [super viewDidLoad];
    self.openSectionIndex = NSNotFound;
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    
    // Do any additional setup after loading the view.
    searchResultsArray = [[NSArray alloc]init];
    [self getAllPatientList];
    _lblStatus.hidden = YES;
    _tblPatientlist.hidden = YES;
    self.title=@"My Patients";
    UINib *nib = [UINib nibWithNibName:@"PatientListCell" bundle:[NSBundle mainBundle]];
    [[self tblPatientlist] registerNib:nib forCellReuseIdentifier:@"PatientListCell"];
    patientServiceHandler = [PatientVisitServiceHandler sharedManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:FALSE animated:FALSE];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mrk Tableview
#pragma mark - Tableview Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 70;
    }
    return 60;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return searchResultsArray.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   UIView  *headerView = [[UILabel alloc]init];
    
    headerView.tag = section;
    headerView.userInteractionEnabled = YES;
    headerView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
    headerView.frame = CGRectMake(-30, 0, tableView.tableHeaderView.frame.size.width, tableView.tableHeaderView.frame.size.height);
  
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,40, 40)];
    NSString *strProfilePic = [[searchResultsArray objectAtIndex:section] valueForKey:@"profile_pic"];
     [img setImage:[UIImage imageNamed: @"D-calling-icon.png"]];
    if(![strProfilePic isKindOfClass:[NSNull class]]){
        [img sd_setImageWithURL:[NSURL URLWithString:strProfilePic] placeholderImage:[UIImage imageNamed:@"D-calling-icon.png"]];

    }
    [img.layer setCornerRadius:img.frame.size.height/2];
    img.clipsToBounds = YES;
    [img setBackgroundColor:[UIColor redColor]];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(60, 14,240, 20)];
    lblName.text = [[searchResultsArray objectAtIndex:section] valueForKey:@"patient_name"];
    
    NSString *str = [[[searchResultsArray objectAtIndex:section]valueForKey:@"appointment_date"] substringWithRange:NSMakeRange(0, 10)];
    NSString *strSub = [IODUtils formatDateForUIFromString:str];
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(60, 34, 240, 20)];
    lblDate.text = [NSString stringWithFormat:@"Apt. Date: %@",strSub];
    lblDate.textColor = [UIColor brownColor];
    lblDate.font = [UIFont systemFontOfSize:13.0];
    
    UIButton *btnStatus = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- 60, 20, 30, 30)];
    [btnStatus setTag:section];
    [btnStatus setBackgroundImage:[UIImage imageNamed:@"down-arrow-icon.png"] forState:UIControlStateNormal];
    [btnStatus addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnDetail = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 60)];
    [btnDetail setTag:section];
    [btnDetail addTarget:self action:@selector(headerSelect:) forControlEvents:UIControlEventTouchUpInside];

    [headerView addSubview:img];
    [headerView addSubview:lblDate];
    [headerView addSubview:lblName];
    [headerView addSubview:btnStatus];
    [headerView addSubview:btnDetail];

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  60;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if ([[self.isShowingList objectAtIndex:section] boolValue]) {
        NSArray *arr = [[searchResultsArray objectAtIndex:section] valueForKey:@"member_array"];
        NSLog(@"MEMBER ARRAY IS %lu",(unsigned long)arr.count);
        return arr.count;
    } else {
        return 0;
    }
    return 0;
    
   
}



-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

-(PatientListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PatientListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PatientListCell"];
  
    NSArray *section = [searchResultsArray [indexPath.section] valueForKey:@"member_array"];
    
    NSLog(@"SECTION ARRAY IS %@",section.description);
    NSString *strProfilePic = [[section objectAtIndex:indexPath.row] valueForKey:@"profile_pic"];
    
 if ([strProfilePic isEqual:[NSNull null]])
    strProfilePic = @"";
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:strProfilePic] placeholderImage:[UIImage imageNamed:@"D-calling-icon.png"]];
    
    [cell.imgV.layer setCornerRadius:cell.imgV.frame.size.height/2];
    cell.imgV.clipsToBounds = YES;
    
    cell.btnStatus.tag = indexPath.row;
    cell.lblDoctorName.text = [[section objectAtIndex:indexPath.row]valueForKey:@"name"];
    NSString *str = [[[section objectAtIndex:indexPath.row]valueForKey:@"appointment_date"] substringWithRange:NSMakeRange(0, 10)];
    NSString *strSub = [IODUtils formatDateForUIFromString:str];
    cell.lblDate.text = [NSString stringWithFormat:@"Apt. Date: %@",strSub];
    cell.lblDate.textColor = [UIColor brownColor];
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
    NSArray *section = [searchResultsArray [indexPath.section] valueForKey:@"member_array"];
    patientServiceHandler.patient_id =[searchResultsArray [indexPath.section] valueForKey:@"patient_id"];
    
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //patientServiceHandler.patient_name = [searchResultsArray [indexPath.section]valueForKey:@"name"];
    patientServiceHandler.member_id = [[section objectAtIndex:indexPath.row]valueForKey:@"id"];;
    
   patientServiceHandler.patient_name =   [[section objectAtIndex:indexPath.row]valueForKey:@"name"];
    
    NSDictionary *dict = [section objectAtIndex:indexPath.row];
    NSMutableDictionary *dictNew = [[NSMutableDictionary alloc] init];
    [dictNew addEntriesFromDictionary:dict];
    for( NSString *aKey in [dictNew allKeys] )
    {
        if ([[dictNew valueForKey:aKey] isKindOfClass:[NSNull class]]){
            [dictNew setValue:@"" forKey:aKey];
        }
    }
    
    UDSet(@"SelectedUser", dictNew);
   // UIStoryboard *sb = [UIStoryboard storyboardWithName:@"StoryboardDoctor" bundle:nil];
   // UIViewController *viewTab=[sb instantiateViewControllerWithIdentifier:@"tabbarEdit"];
   // [self.navigationController pushViewController:viewTab animated:YES];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"StoryboardDoctor" bundle:nil];
    UIViewController *viewTab=[sb instantiateViewControllerWithIdentifier:@"TabbarCategoryViewController"];
    [self.navigationController pushViewController:viewTab animated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // called when text ends editing
    [searchBar setShowsCancelButton:NO animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    searchResultsArray = arrPatientList;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length ==0) {
        searchResultsArray=arrPatientList;
        [_tblPatientlist reloadData];
        return;
    }
    else {
        NSMutableArray *terms = (NSMutableArray *)[searchText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        BOOL WordFOund=true;
        NSMutableArray *results = [NSMutableArray new];
        //        for (NSString *str in [arrPatientList valueForKey:@"patient_name"])
        for (NSDictionary *dict in arrPatientList )
            
        {
            WordFOund=true;
            NSArray *arr=[[dict valueForKey:@"patient_name"]  componentsSeparatedByString:@" "];
            for (int i=0 ;i<terms.count;i++) {
                if (![[terms objectAtIndex:i] isEqualToString:@""])
                    if([[arr filteredArrayUsingPredicate: [NSPredicate predicateWithFormat:@"SELF contains[c] %@", [terms objectAtIndex:i]] ]count]==0)
                        WordFOund=false;
            }
            if (WordFOund)
                [results addObject:dict];
        }
        
        searchResultsArray=results.copy;
        [_tblPatientlist reloadData];
        return;
    }
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0){
    return  YES;
} // called before text changes
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // called when keyboard search button pressed
    [self.view endEditing:YES];
}


#pragma mark API
-(void)getAllPatientList {
    CommonServiceHandler *service = [[CommonServiceHandler alloc]init];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (reachable) {
        
        _lblStatus = [[UILabel alloc]init];
        _lblStatus.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30) ;
        _lblStatus.center = self.view.center;
        _lblStatus.text = kNodata;
        [self.view addSubview:_lblStatus];
        _lblStatus.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
        _lblStatus.font = [UIFont boldSystemFontOfSize:18.0];
        _lblStatus.textAlignment = NSTextAlignmentCenter;
       // [_lblStatus setHidden:YES];
        [service getAllPatienVisit:nil WithCompletionBlock:^(NSArray *array, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
      
        
        if(array.count > 0){
            arrPatientList = [NSArray arrayWithArray:array];
            //NSLog(@"arrPatientList is %@",arrPatientList);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            searchResultsArray=arrPatientList;
            if ([arrPatientList count] > 0) {
                _lblStatus.hidden = YES;
                _tblPatientlist.hidden = NO;
            }else{
                _lblStatus.hidden = NO;
                _tblPatientlist.hidden = YES;
            }
            [_tblPatientlist reloadData];
        }
        else{
            _lblStatus.hidden = NO;
            _tblPatientlist.hidden = YES;
        }
        self.isShowingList = [NSMutableArray array];
        for (int i = 0; i < arrPatientList.count; i++) {
            [self.isShowingList addObject:[NSNumber numberWithBool:NO]];
        }
        
    }];
    }else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}

-(void)headerClicked:(UIButton *)sender {
    UIButton *btn = (UIButton*)sender;
    
    NSInteger tag = btn.tag;
    if ([[self.isShowingList objectAtIndex:tag] boolValue]) {
       [self closeSection:sender.tag];
    } else {
        [self openSection:sender.tag];
    }
}

-(void)headerSelect:(UIButton *)sender{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    patientServiceHandler.patient_id = [[searchResultsArray objectAtIndex:tag]valueForKey:@"patient_id"];
    patientServiceHandler.patient_name = [[searchResultsArray objectAtIndex:tag]valueForKey:@"patient_name"];
    patientServiceHandler.member_id = @"";
    
    NSDictionary *dict = [searchResultsArray objectAtIndex:tag];
    NSMutableDictionary *dictNew = [[NSMutableDictionary alloc] init];
    [dictNew addEntriesFromDictionary:dict];
    for( NSString *aKey in [dictNew allKeys] )
    {
        if ([[dictNew valueForKey:aKey] isKindOfClass:[NSNull class]]){
            [dictNew setValue:@"" forKey:aKey];
        }
    }
    UDSet(@"SelectedUser", dictNew);
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"StoryboardDoctor" bundle:nil];
    UIViewController *viewTab=[sb instantiateViewControllerWithIdentifier:@"TabbarCategoryViewController"];
    [self.navigationController pushViewController:viewTab animated:YES];

}

//methods for expanding and collapsing sections
- (void)openSection:(NSInteger)section {
    
    [self.isShowingList replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:YES]];
    NSArray *arr =[[arrPatientList objectAtIndex:section] valueForKey:@"member_array"];
    NSInteger countOfRowsToInsert = arr.count;
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tblPatientlist reloadSections:[NSIndexSet indexSetWithIndex:previousOpenSectionIndex] withRowAnimation:UITableViewRowAnimationNone];
        });
        [self.isShowingList replaceObjectAtIndex:previousOpenSectionIndex withObject:[NSNumber numberWithBool:NO]];
        
        NSArray *arr =[[arrPatientList objectAtIndex:previousOpenSectionIndex] valueForKey:@"member_array"];

        NSInteger countOfRowsToDelete = [arr count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    // Apply the updates.
    [self.tblPatientlist beginUpdates];
    [self.tblPatientlist insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tblPatientlist deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tblPatientlist endUpdates];
    self.openSectionIndex = section;
}

- (void)closeSection:(NSInteger)section {
    [self.isShowingList replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:NO]];
    NSInteger countOfRowsToDelete = [self.tblPatientlist numberOfRowsInSection:section];
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        [self.tblPatientlist deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}

-(void)refreshView:(NSNotification*)notification{
    [self getAllPatientList];
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}




@end
