//
//  ExploreViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 1/18/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "ExploreViewController.h"
#import "UIColor+HexString.h"
#import "UIImageView+WebCache.h"
#import "IODUtils.h"
#import "UIColor+HexString.h"
#import "LoginVC.h"
#import "CommonServiceHandler.h"
#import "FileViewerVC.h"
#import "FileViewController.h"
#include "ContactUsViewController.h"
#include "BlogsViewController.h"
#import "ReferalViewController.h"
#import "ExploreCell.h"

@interface ExploreViewController ()<UITableViewDataSource,UITableViewDataSource>
{
    NSMutableArray *arrListMenu;
    FileViewController *fileViewMe ;
    NSDictionary *dictData;
    NSString *strProfile;
    NSString *fileName;
}
@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"ExploreCell" bundle:[NSBundle mainBundle]];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"exploreCell"];
    
    [self.navigationController setNavigationBarHidden:FALSE animated:FALSE];
    if([_userType isEqualToString:@"patient"]){
        dictData=[NSKeyedUnarchiver unarchiveObjectWithData: UDGet(@"userinfo")];
        strProfile = [NSString stringWithFormat:@"%@",UDGet(@"profilePic")];
        fileName = @"sidePanel";
    }
    else{
        dictData=[NSKeyedUnarchiver unarchiveObjectWithData: UDGet(@"userinfodoc")];
        strProfile = [NSString stringWithFormat:@"%@",UDGet(@"docprofilePic")];
         fileName = @"sidePanelDoctor";
    }
    
    _lblName.text = [NSString stringWithFormat:@"%@",[dictData valueForKey:@"name"]];
    _lblLocation.text = [NSString stringWithFormat:@"%@",[dictData valueForKey:@"address"]];
    [_imgProfile.layer setCornerRadius:_imgProfile.frame.size.height/2];
    _imgProfile.clipsToBounds = YES;
    [_imgProfile.layer setBorderWidth:2.0];
    [_imgProfile.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.navigationController setNavigationBarHidden:FALSE animated:FALSE];
    
    NSDictionary *dictSidePanel = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:fileName ofType:@"json"]];
    arrListMenu = [dictSidePanel valueForKey:@"sidePanel"];
    NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

-(void)viewDidAppear:(BOOL)animated{
    [self getUserPrfile];
    _lblName.text = [NSString stringWithFormat:@"%@",[dictData valueForKey:@"name"]];
    _lblLocation.text = [NSString stringWithFormat:@"%@",[dictData valueForKey:@"address"]];
    [_imgProfile.layer setCornerRadius:_imgProfile.frame.size.height/2];
    _imgProfile.clipsToBounds = YES;
    [_imgProfile.layer setBorderWidth:2.0];
    [_imgProfile.layer setBorderColor:[UIColor whiteColor].CGColor];
}

#pragma mark - UITableView Datasource & Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex{
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:17];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==  arrListMenu.count){
        return 40;
    }
    else {
        return 54;
    }
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return arrListMenu.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExploreCell * expell = [tableView dequeueReusableCellWithIdentifier:@"exploreCell"];
    expell.lblText.tintColor=[UIColor blackColor];
    
    if(indexPath.row == arrListMenu.count){
        expell.lblText.text = kversion;
        expell.imgView.image = nil;
        expell.backgroundColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
        expell.lblText.textColor = [UIColor whiteColor];
        [expell.contentView setBackgroundColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
        
    }
    else{
        [expell.contentView setBackgroundColor:[UIColor clearColor]];
        expell.lblText.text =   [[arrListMenu objectAtIndex:indexPath.row] valueForKey:@"Title"];
        expell.lblText.textColor =[UIColor grayColor];
        expell.selectionStyle=UITableViewCellSelectionStyleGray;
        expell.imgView.image = [UIImage imageNamed:[[arrListMenu objectAtIndex:indexPath.row] valueForKey:@"imageName"]];
        expell.selectionStyle = UITableViewCellSelectionStyleNone;
        expell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        expell.selectedBackgroundView.backgroundColor = [UIColor redColor];
    }
    return expell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.row == 0)
        [self homePressed]; //Home
    
    else  if( indexPath.row == 1)
        [self myProfile]; //Profile
    
    else if( indexPath.row == 2)
        [self shareReferal]; // Share Referal
    
    else if( indexPath.row == 3)
        [self Faq]; // FAQ
    
    else if(indexPath.row == 4)
        [self Blogs]; // Blogs
    
    else if( indexPath.row == 5){
        //share
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *url=@"https://itunes.apple.com/us/app/i-online-doc/id1299763701?ls=1&mt=8";
        NSString * title =[NSString stringWithFormat:@"I am excited to share %@ link for I Online Doctor Mobile App. Download and Video Call Doctor from your Mobile!",url];
        
        NSArray* dataToShare = @[title];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
        activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
        {
            activityViewController.popoverPresentationController.sourceView = cell.contentView;
            CGRect frame = cell.contentView.frame;
            frame.origin.x = frame.origin.x-150;
            activityViewController.popoverPresentationController.sourceRect =frame;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:activityViewController animated:YES completion:nil];
            });
        }
        else{
            [self presentViewController:activityViewController
                               animated:YES
                             completion:nil];
        }
    }else if( indexPath.row == 6)
        [self whatWeTreat]; // Services
    
    else if( indexPath.row == 7)
        [self HowItWorks]; // How it works
    
    else if( indexPath.row == 8)
        [self Terms]; // Terms and Conditions
    
    else if( indexPath.row == 9)
        [self ContactUs]; // Contact us
    
    else if(indexPath.row == 10)
        [self logOut]; // Logout
}

#pragma mark - Eplore Click Methods

-(IBAction)editImgClicked:(id)sender{
    //Edit Profile
    UIViewController *viewTab=[self.storyboard instantiateViewControllerWithIdentifier:@"tabbarEdit"];
    [self.navigationController pushViewController:viewTab animated:YES];
}

-(void)logout {
    //Logout
    
    //NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    // [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [service logoutWithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        if (responseCode){
            UDSet(@"userinfodoc",nil);
            UDSet(@"propicdoc",nil);
            UDSet(@"propic", nil);
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([[responseCode objectForKey:@"status"] isEqualToString:@"success"]){
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedIn"];
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *navController = [[UINavigationController alloc] init];
                UDSet(@"auth", AuthKey);
                UDSet(@"userinfodoc", nil);

                LoginVC *dashDoc = [sb instantiateViewControllerWithIdentifier:@"LoginVC"];
                [navController addChildViewController:dashDoc];
                [[[UIApplication sharedApplication] delegate] window].rootViewController = navController;
                [[[UIApplication sharedApplication] delegate] window].backgroundColor = [UIColor whiteColor];
            }
        }
    }];
}

-(void)homePressed{
    // Home
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)myProfile{
    // My Profile
    UIViewController *viewTab=[self.storyboard instantiateViewControllerWithIdentifier:@"tabbarEdit"];
    [self.navigationController pushViewController:viewTab animated:YES];
}

-(void)Faq{
    //FAQ
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    fileViewMe  = [sb instantiateViewControllerWithIdentifier:@"FileViewController"];
    
    fileViewMe.strFilePath= kFaq;
    fileViewMe.strTitle=@"FAQ";
    [self.navigationController pushViewController:fileViewMe animated:YES];
}

-(void)Blogs{
    //Blogs
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *blogsView=[sb instantiateViewControllerWithIdentifier:@"BlogsViewController"];
    [self.navigationController pushViewController:blogsView animated:YES];
}

-(void)Share{
    //Share
    NSString *url=@"https://itunes.apple.com/us/app/i-online-doc/id1299763701?ls=1&mt=8";
    NSString * title =[NSString stringWithFormat:@"I am excited to share %@ link for I Online Doctor Mobile App. Download and Video Call Doctor from your Mobile!",url];
    
    NSArray* dataToShare = @[title];
    UIActivityViewController* activityViewController =[[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [self presentViewController:activityViewController animated:YES completion:^{}];
}

-(void)whatWeTreat{
    //Services
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    fileViewMe  = [sb instantiateViewControllerWithIdentifier:@"FileViewController"];
    fileViewMe.strFilePath = kWhatWeTreat;
    fileViewMe.strTitle=@"Services";
    [self.navigationController pushViewController:fileViewMe animated:YES];
}

-(void)HowItWorks{
    //How it works
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    fileViewMe  = [sb instantiateViewControllerWithIdentifier:@"FileViewController"];
    fileViewMe.strFilePath= kHowItWorks;
    fileViewMe.strTitle=@"How it Works";
    [self.navigationController pushViewController:fileViewMe animated:YES];
}

-(void)Terms{
    //Terms and Conditions
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    fileViewMe  = [sb instantiateViewControllerWithIdentifier:@"FileViewController"];
    fileViewMe.strFilePath= kTermsLink;
    fileViewMe.strTitle = kTermsConditions;
    [self.navigationController pushViewController:fileViewMe animated:YES];
}

-(void)ContactUs{
    //Contact us
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContactUsViewController *contactUs  = [sb instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
    [self.navigationController pushViewController:contactUs animated:YES];
}

-(void)logOut{
    //Logout Alert Dialouge
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kLogoutMessage message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *yesPressed = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        if (reachable) {
            [self logout];
        }
        else{
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        }
    }];
    UIAlertAction *noPressed = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:noPressed];
    [alertController addAction:yesPressed];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)shareReferal{
    //Share Referal
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReferalViewController *referral  = [sb instantiateViewControllerWithIdentifier:@"ReferalViewController"];
    [self.navigationController pushViewController:referral animated:YES];
}

-(void)getUserPrfile{
    //Get User Profile
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
     [MBProgressHUD showHUDAddedTo:_imgProfile animated:YES];
    [service getUserProfile:^(NSDictionary *responseCode, NSError *error) {
        if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]){
            NSMutableDictionary *dictdata = [[responseCode objectForKey:@"data"] mutableCopy];
            NSString *profilePic = [NSString stringWithFormat:@"%@", [dictdata valueForKey:@"profile_pic"]];
            [_imgProfile sd_setImageWithURL:[NSURL URLWithString:profilePic] placeholderImage:[UIImage imageNamed:@"D-calling-icon"]];
            [MBProgressHUD hideHUDForView:_imgProfile animated:YES];
        }
        else{
            [MBProgressHUD hideHUDForView:_imgProfile animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
