//
//  DEMOMenuViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "DEMOHomeViewController.h"
#import "DEMOSecondViewController.h"
#import "DEMONavigationController.h"
#import "UIViewController+REFrostedViewController.h"
#import "DashboardDoctor.h"
#import "DashboardVC.h"
#import "IODUtils.h"
#import "UIColor+HexString.h"
#import "LoginVC.h"
#import "CommonServiceHandler.h"
#import "FileViewerVC.h"
#import "FileViewController.h"
#include "ContactUsViewController.h"

@implementation DEMOMenuViewController
{
    NSMutableArray *arrListMenu;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *dictSidePanel = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"sidePanel" ofType:@"json"]];
    arrListMenu = [dictSidePanel valueForKey:@"sidePanel"];
    
    NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [[UIColor colorWithHexRGB:@"#2e323e"] colorWithAlphaComponent:1.0];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 60.0f)];
        view;
    });
    [self.frostedViewController hideMenuViewController];
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FileViewController *fileViewMe  = [sb instantiateViewControllerWithIdentifier:@"FileViewController"];
    if ( indexPath.row == 0) {
        DashboardVC *homeViewController;
        if (UDGetBool(@"isdoctor")) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"StoryboardDoctor" bundle:nil];
            homeViewController  = [sb instantiateViewControllerWithIdentifier:@"DashboardDoctor"];
        }
        else{
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            homeViewController  = [sb instantiateViewControllerWithIdentifier:@"DashboardVC"];
        }
        
        DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:homeViewController];
        self.frostedViewController.contentViewController = navigationController;
    } else if( indexPath.row == 1){
        //FAQ
     
        fileViewMe.strFilePath=@"https://www.ionlinedoctor.com/faqm.html";
                fileViewMe.strTitle=@"FAQ";
        DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:fileViewMe];
        self.frostedViewController.contentViewController = navigationController;
        
    }
    else if( indexPath.row == 2){
        //FAQ
        
        fileViewMe.strFilePath=@"https://www.ionlinedoctor.com/faqm.html";
        fileViewMe.strTitle=@"FAQ";
        DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:fileViewMe];
        self.frostedViewController.contentViewController = navigationController;
        
    }
    
    else if( indexPath.row == 3){
        NSString *url=@"https://itunes.apple.com/us/app/i-online-doc/id1299763701?ls=1&mt=8";
        NSString * title =[NSString stringWithFormat:@"I am excited to share %@ link for I Online Doctor Mobile App. Download and Video Call Doctor from your Mobile!",url];
        
        NSArray* dataToShare = @[title];
        UIActivityViewController* activityViewController =[[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
        activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
        [self presentViewController:activityViewController animated:YES completion:^{}];
        
        } else if( indexPath.row == 4){
        
        //what we treat
            fileViewMe.strFilePath=@"https://www.ionlinedoctor.com/servicesm.html";
                fileViewMe.strTitle=@"Services";
        DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:fileViewMe];
        self.frostedViewController.contentViewController = navigationController;
        
    } else if( indexPath.row == 5){
        // how it works
       
        fileViewMe.strFilePath=@"https://www.ionlinedoctor.com/how_it_worksm.html";
                fileViewMe.strTitle=@"How it Works";
        DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:fileViewMe];
        self.frostedViewController.contentViewController = navigationController;
    }
    else if( indexPath.row == 6){
     
        fileViewMe.strFilePath=@"https://www.ionlinedoctor.com/terms-and-conditionsm.html";
        fileViewMe.strTitle=@"Terms and Conditions";
        DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:fileViewMe];
        self.frostedViewController.contentViewController = navigationController;
        
    }else if( indexPath.row == 7){
        //Contact us
        ContactUsViewController *contactUs  = [sb instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
        DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:contactUs];
        self.frostedViewController.contentViewController = navigationController;
    }
    else if( indexPath.row == 8){
        //logout us
        //[self logout];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to logout?"message:@"" preferredStyle:UIAlertControllerStyleAlert];
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

    
    
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sampleView = [[UIView alloc] init];
    sampleView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 40);
    sampleView.backgroundColor = [UIColor blackColor];
    
    UILabel *lblVersion = [[UILabel alloc] init];
    lblVersion.text = kversion;
    lblVersion.frame = sampleView.frame ;
    lblVersion.textAlignment = NSTextAlignmentCenter;
    lblVersion.textColor = [UIColor whiteColor];
    [sampleView addSubview: lblVersion];
    return sampleView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return arrListMenu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.tintColor=[UIColor whiteColor];
    
    cell.textLabel.text =   [[arrListMenu objectAtIndex:indexPath.row] valueForKey:@"Title"];
    cell.textLabel.textColor =[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    cell.imageView.image= [UIImage imageNamed:[[arrListMenu objectAtIndex:indexPath.row] valueForKey:@"imageName"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
    return cell;
}

-(void)logout {
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
   // [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
 
    [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
   // NSLog(@"=================================");
   // NSLog(@"LOGOUT");
  //  NSLog(@"=================================");

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

                
                //NSLog(@"=================================");
                //NSLog(@"LOGOUT RESPIONSE %@",responseCode);
                //NSLog(@"=================================");

                LoginVC *dashDoc = [sb instantiateViewControllerWithIdentifier:@"LoginVC"];
                [navController addChildViewController:dashDoc];
                [[[UIApplication sharedApplication] delegate] window].rootViewController = navController;
                [[[UIApplication sharedApplication] delegate] window].backgroundColor = [UIColor whiteColor];
            }
        }
    }];
}
@end
