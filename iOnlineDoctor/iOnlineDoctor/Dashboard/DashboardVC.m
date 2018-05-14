 //
//  DashboardVC.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/27/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "DashboardVC.h"
#import "IODUtils.h"
#import "UIColor+HexString.h"
#import "UIImageView+WebCache.h"
#import "CommonServiceHandler.h"
#import "DEMONavigationController.h"
#import "LoginVC.h"
#import "PatientAppointService.h"
#import "DoctorAppointmentServiceHandler.h"
#import <AVFoundation/AVFoundation.h>
#import "HHPageView.h"
#import "UIImageView+WebCache.h"
#import "ExploreViewController.h"
#import "FileViewController.h"
#import "RegistrationService.h"
#import "SelectPatientViewController.h"


#define HORIZONTAL_SCROLLVIEW_TAG 1
#define VERTICAL_SCROLLVIEW_TAG 2

@interface DashboardVC () <HHPageViewDelegate> {
    DEMONavigationController *menu;
    PatientAppointService *patientService;
    DoctorAppointmentServiceHandler *docService;
    AVAudioPlayer *audioPlayer;
    NSTimer* myTimer, *blogTimer;
    IBOutlet HHPageView *pageController;
    NSMutableArray *arrBlogs;
    UIView *couponBackgroundV;
    RegistrationService *regisService;
    int healthRecordCount;
    int appointmentCount;
}

@property(strong) NSMutableArray *arrDashBoardImages;
@end

@implementation DashboardVC

#pragma mark - Generate Random Color (RGB)
- (float)getRandomInt
{
    return (arc4random()%255)/255.f;
}

#pragma mark - Add Pages To ScrollView (Testing)
- (void) addNoOfPagesHorizontally:(NSInteger)pages {
    for (id v in _scrollView.subviews) {
            [v removeFromSuperview];
    }
    
    NSInteger x = 0; //start X position inside scrollview
    NSInteger y = 0; //start Y position inside scrollview
    NSInteger w = _scrollView.frame.size.width; //width of page
    NSInteger h = _scrollView.frame.size.height; //height of page
    
    for(NSInteger i = 0; i< arrBlogs.count; i++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        UIImageView *imgBanner = [[UIImageView alloc] init];
        imgBanner.frame = CGRectMake(0, 0, v.frame.size.width, v.frame.size.height);
        
        UIButton *btnBanner = [[UIButton alloc] init];
        btnBanner.frame = CGRectMake(0, 0, v.frame.size.width, v.frame.size.height);
        [btnBanner setBackgroundColor:[UIColor clearColor]];
        btnBanner.tag = i;
        [btnBanner addTarget:self action:@selector(clickOnBlog:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btnBanner];
        
        UIImageView *imgTransBg = [[UIImageView alloc] init];
        imgTransBg.frame = CGRectMake(0, v.frame.size.height/2 , v.frame.size.width/1.3, 100);
        imgTransBg.image = [UIImage imageNamed:@"trans-bnr-bg"];
        
        UILabel *lblTitle = [[UILabel alloc] init];
        lblTitle.frame = CGRectMake(20, v.frame.size.height/2, imgTransBg.frame.size.width - 20,70);
        lblTitle.text = [NSString stringWithFormat:@"%@",[[arrBlogs objectAtIndex:i] valueForKey:@"post_title"]];
        lblTitle.font = [UIFont boldSystemFontOfSize:17.0];        
        lblTitle.numberOfLines = 3;
   
        NSString *strThumbnail = [[arrBlogs objectAtIndex:i] objectForKey:@"thumbnail"];
        if(strThumbnail == nil)
            strThumbnail = [[arrBlogs objectAtIndex:i] objectForKey:@"thumbnail_portrait"];
        [imgBanner sd_setImageWithURL:[NSURL URLWithString:strThumbnail] placeholderImage:[UIImage imageNamed:@"P-banner-no-img"]];
        
        [v addSubview:imgBanner];
        [v addSubview:imgTransBg];
        [v addSubview:lblTitle];
        [v bringSubviewToFront:btnBanner];
        [_scrollView addSubview:v];
        x+=_scrollView.frame.size.width;
    }
    [_scrollView setContentSize:CGSizeMake(x, _scrollView.frame.size.height)];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_wrapper addSubview:pageController];
    [pageController setImageActiveState:[UIImage  imageNamed:@"selected.png"] InActiveState:[UIImage  imageNamed:@"unselected.png"]];
}

- (void) configureHorizontalControllerWithTotalPages:(NSInteger)totalPages {
    if(pageController){
        [pageController removeFromSuperview];
    }
    pageController = [[HHPageView alloc] init];
    [pageController setFrame:CGRectMake(0, _wrapper.frame.size.height - 40, SCREEN_WIDTH, 40)];
    [_wrapper addSubview:pageController];
    [_wrapper bringSubviewToFront:pageController];
    [pageController setDelegate:self];
    [pageController setImageActiveState:[UIImage  imageNamed:@"selected.png"] InActiveState:[UIImage  imageNamed:@"unselected.png"]];
   [pageController setNumberOfPages:totalPages];
   [pageController setCurrentPage:1];
    [pageController load];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll {
    //If its not dragging
    if(!scroll.isDragging) {
        if(scroll.tag == HORIZONTAL_SCROLLVIEW_TAG) {
            //horizontal
            NSInteger pageWidth = scroll.frame.size.width;
            NSInteger page = (floor((scroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1) + 1;
         [pageController updateStateForPageNumber:page];
        }
    }
}

#pragma mark - HHPageController Delegate
- (void) HHPageView:(HHPageView *)pageView currentIndex:(NSInteger)currentIndex {
    UIScrollView *baseScrollView = (UIScrollView *) [pageView baseScrollView];
    if(baseScrollView) {
        if(baseScrollView.tag == HORIZONTAL_SCROLLVIEW_TAG)
            [baseScrollView setContentOffset:CGPointMake(currentIndex * _scrollView.frame.size.width, 0) animated:YES];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.imgProfilePic.layer setBorderColor:[UIColor whiteColor].CGColor];
        self.imgProfilePic.layer.cornerRadius=self.imgProfilePic.frame.size.height/2;
        self.imgProfilePic.layer.masksToBounds=YES;
        [self.view setNeedsLayout];
        [self.collectionViewDashbaord reloadData];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    }];
}

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)hideCouponView:(id)sender{
    [couponBackgroundV setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserPrfile];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
        NSString *fcmToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"FCMToken"];
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        [parameter setObject:fcmToken forKey:@"device_token"];
        if(fcmToken == nil)
        {
            fcmToken = @"testtoken";
        }
        CommonServiceHandler *service =[[CommonServiceHandler alloc] init];
        [service updateToken:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
          }];
    }
    
    patientService = [PatientAppointService sharedManager];
    docService = [DoctorAppointmentServiceHandler sharedManager];
    regisService = [RegistrationService sharedManager];
    patientService.documentName = [[NSMutableArray alloc] init];
    patientService.arrDocumentData =[[NSMutableArray alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    self.title=@"Home";
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];
    UINib *cellNib = [UINib nibWithNibName:@"DashboardXibCell" bundle:nil];
    [self.collectionViewDashbaord registerNib:cellNib forCellWithReuseIdentifier:@"DashboardXibCell"];
    [self.collectionViewDashbaord setContentInset:UIEdgeInsetsMake(0,0,0,0)];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    NSDictionary *dictdashboard = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"PatientDashboard" ofType:@"json"]];
    self.arrDashBoardImages  = [dictdashboard valueForKey:@"PatientDashboard"];
    // Do any additional setup after loading the view.

    UITapGestureRecognizer *tapG=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editImgClicked)];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    regisService = [RegistrationService sharedManager];
    [self getBadgeCounts];
    [self getAllSpecialization];
        [_collectionViewDashbaord reloadData];
    if([docService.isEVisit isEqualToString:@"yes"]){
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"another-hand-bell" ofType:@"mp3"]] error:&error];
        if (error) {
        } else {
            [audioPlayer prepareToPlay];
            [audioPlayer play];
            myTimer = [NSTimer scheduledTimerWithTimeInterval: 30.0 target: self
                                                              selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: YES];
        }
    }
    [self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithImage:[UIImage imageNamed:@""]
                                     style:UIBarButtonItemStylePlain
                                     target:self action:@selector(showMenu)];
    menu = [[DEMONavigationController alloc] init];
    self.navigationItem.leftBarButtonItem = logoutButton;
}

-(void) viewDidAppear:(BOOL)animated{
    [self getAllBlogs];
     patientService.question_3 = @"";
     patientService.isFromLiveVideoCall = @"no";
     patientService.question_4 = @"";
     patientService.question_5 = @"";
     patientService.question_6 = @"";
     UDSet(@"SelectedSymptoms", @"");
}

-(void)getAllBlogs{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [MBProgressHUD showHUDAddedTo:_wrapper animated:YES];
    [service getAllBlogs:nil WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:_wrapper animated:YES];
        if([[responseCode objectForKey:@"status"] isEqualToString:@"success"]){
            arrBlogs = [responseCode valueForKey:@"data"];
            NSInteger numberOfPages = arrBlogs.count;
            [self addNoOfPagesHorizontally:numberOfPages];
            [self configureHorizontalControllerWithTotalPages:numberOfPages];
        }
        else{
            if([error.localizedDescription isEqualToString:@"Request failed: forbidden (403)"])
               [self logOut];
        }
    }];
}

-(IBAction)clickOnBlog:(UIButton *) btn {
    int tag = btn.tag;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FileViewController *fileViewMe  = [sb instantiateViewControllerWithIdentifier:@"FileViewController"];
    fileViewMe.strFilePath=[[arrBlogs objectAtIndex:tag] valueForKey:@"guid"];
    fileViewMe.strTitle=[[arrBlogs objectAtIndex:tag] valueForKey:@"post_title"];
    [self.navigationController pushViewController:fileViewMe animated:YES];
}

-(void)callAfter4Second:(NSTimer*) t {
    
    int opt1 = _wrapper.frame.size.width+1;
    int opt2 = _wrapper.frame.size.width *2 +1;
    int opt3 = 0;
    NSArray *arrobj = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:opt1],[NSNumber numberWithInt:opt2],[NSNumber numberWithInt:opt3], nil];
    int offset =[[arrobj objectAtIndex: arc4random() % [arrobj count]] intValue];
     [_scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
        NSInteger pageWidth = _scrollView.frame.size.width;
        NSInteger page = (floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1) + 1;
        [pageController updateStateForPageNumber:page];
}

-(void) callAfterSixtySecond:(NSTimer*) t
{
    [myTimer invalidate];
    [audioPlayer stop];
}

- (void) showMenu {
      [(DEMONavigationController *)self.parentViewController showMenu];
}

-(void)editImgClicked{
    UIViewController *viewTab=[self.storyboard instantiateViewControllerWithIdentifier:@"tabbarEdit"];
    [self.navigationController pushViewController:viewTab animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection view delegates
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    patientService.payment_mode_id = 0;
    if(indexPath.item == 0 ) {
            patientService.visit_type_id = @"1";
            patientService.isFromliveCall = @"no";
            patientService.slot_id = @"";
            patientService.documentName = [[NSMutableArray alloc] init];
            patientService.arrDocumentData = [[NSMutableArray alloc] init];

        UIStoryboard *medicalInfoStoryBoard = [UIStoryboard storyboardWithName:@"MedicalInfo" bundle:nil];
         SelectPatientViewController *selectPatientVC = [medicalInfoStoryBoard instantiateViewControllerWithIdentifier:@"SelectPatientViewController"];
            [self.navigationController pushViewController:selectPatientVC animated:YES];
    }
    if(indexPath.item == 1) {
            patientService.visit_type_id = @"2";
            patientService.isFromliveCall = @"no";
            patientService.documentName = [[NSMutableArray alloc] init];
            patientService.arrDocumentData = [[NSMutableArray alloc] init];
            UIViewController *viewTab=[self.storyboard instantiateViewControllerWithIdentifier:@"TabbarCategoryViewController"];
            [self.navigationController pushViewController:viewTab animated:YES];
            patientService.isFromliveCall = @"no";
    }
    if(indexPath.item == 2) {
            patientService.visit_type_id = @"3";
            patientService.documentName = [[NSMutableArray alloc] init];
            patientService.arrDocumentData = [[NSMutableArray alloc] init];
            patientService.documentName = [[NSMutableArray alloc]init];
            patientService.fromDashboard = 0;
             UIViewController *viewTab=[self.storyboard instantiateViewControllerWithIdentifier:@"TabbarCategoryViewController"];
           [self.navigationController pushViewController:viewTab animated:YES];
    }
    if (indexPath.item == 5) {
            patientService.visit_type_id = @"4";
            patientService.isFrom = @"MyAppointment";
            UIViewController *viewTab=[self.storyboard instantiateViewControllerWithIdentifier:@"E_VisitPage"];
            [self.navigationController pushViewController:viewTab animated:YES];
    }
    if (indexPath.item == 3){
            ExploreViewController *viewTab=[self.storyboard instantiateViewControllerWithIdentifier:@"ExploreViewController"];
            viewTab.userType = @"patient";
            [self.navigationController pushViewController:viewTab animated:YES];
    }
    if (indexPath.item == 4){
            patientService.selectedTab = @"1";
            patientService.visit_type_id = @"5";
            patientService.isFrom = @"healthrecord";
            [_collectionViewDashbaord reloadData];
         DashboardXibCell *cell = (DashboardXibCell *)[_collectionViewDashbaord cellForItemAtIndexPath:indexPath];
            [cell.lblDashboardTitle.layer removeAllAnimations];
            docService.isEVisit = @"no";
            [_collectionViewDashbaord reloadData];
            UIViewController *viewTab=[self.storyboard instantiateViewControllerWithIdentifier:@"tabbarHealthRecord"];
            [self.navigationController pushViewController:viewTab animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrDashBoardImages.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.collectionViewDashbaord.frame.size.width/3.01,self.collectionViewDashbaord.frame.size.height/2);
}

-(DashboardXibCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DashboardXibCell *cell=(DashboardXibCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DashboardXibCell" forIndexPath:indexPath];
    [cell layoutIfNeeded];
    NSString *imgDashboardName = [[self.arrDashBoardImages objectAtIndex:indexPath.row] valueForKey:@"imageName"];
    NSString *DashboardTitle = [[self.arrDashBoardImages objectAtIndex:indexPath.row] valueForKey:@"Title"];
    cell.lblDashboardTitle.text=DashboardTitle;
    cell.lblCount.layer.masksToBounds = YES;
    cell.lblCount.layer.cornerRadius = cell.lblCount.frame.size.height / 2;
    if ([DashboardTitle containsString:@"Health"]){
        if(healthRecordCount >0){
            cell.lblCount.hidden = false;
            cell.lblCount.text = [NSString stringWithFormat:@"%d",healthRecordCount];
        }
    }
    else if ([DashboardTitle containsString:@"My"]){
        if(appointmentCount > 0){
            cell.lblCount.hidden = false;
            cell.lblCount.text = [NSString stringWithFormat:@"%d",appointmentCount];
        }
    }
    else
        cell.lblCount.hidden = true;
    NSString *backgroundColor =[[self.arrDashBoardImages objectAtIndex:indexPath.row] valueForKey:@"Color"];
    cell.backgroundColor = [UIColor clearColor];
    cell.lblDashboardTitle.textColor  = [UIColor blackColor];
    cell.lblDashboardTitle.font = [UIFont systemFontOfSize:14.0];
    cell.imgDashboardCell.image = [UIImage imageNamed:imgDashboardName];
        if([DashboardTitle containsString:@"Health"]){
            if ([docService.isEVisit isEqualToString:@"yes"]){
                [cell.imgbellIcon setHidden:NO];
            }
            else{
             cell.lblDashboardTitle.textColor  = [UIColor blackColor];
             [cell.imgbellIcon setHidden:YES];
            }
        }
        else
            [cell.imgbellIcon setHidden:YES];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)animateLabel:(UILabel *)lbl {
    lbl.text = [[self.arrDashBoardImages objectAtIndex:4] valueForKey:@"Title"];
    lbl.alpha = 1;
    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        lbl.alpha = 0;
    } completion:nil];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (void) getUserPrfile{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service getUserProfile:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]){
            NSMutableDictionary *dictdata = [[responseCode objectForKey:@"data"] mutableCopy];
            UDSet(@"UserData", dictdata);
            NSString *strname = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"name"]];
            NSString *profilePic = [NSString stringWithFormat:@"%@", [dictdata valueForKey:@"profile_pic"]];
             UDSet(@"profilePic", profilePic);
              UIImage *imgPro=[NSKeyedUnarchiver unarchiveObjectWithData: UDGet(@"propic")];
            if (!imgPro)
                imgPro=[UIImage imageNamed:@"D-calling-icon.png"] ;
            
            NSString *strCountry =[NSString stringWithFormat:@"%@",[dictdata valueForKey:@"country"]];
            NSString *strState =[NSString stringWithFormat:@"%@, ",[dictdata valueForKey:@"state"]];
            NSString *strCity =[NSString stringWithFormat:@"%@, ",[dictdata valueForKey:@"city"]];
         
            if([strCity isEqualToString:@", "])
                strCity = @"";
            
            if([strState isEqualToString:@", "])
                strState = @"";
            
            if([strCountry isEqualToString:@""])
                strCountry = @"";
            
            NSString *strAddress = [NSString stringWithFormat:@"%@%@%@",strCity,strState,strCountry];
            UDSet(@"userinfo", ([NSKeyedArchiver archivedDataWithRootObject:@{@"name":strname,@"address":strAddress}]));
             UDSet(@"userType", @"Patient");
        }
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//Logout Event
-(void)logOut{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
    [service logoutWithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        if (responseCode){
            UDSet(@"userinfodoc",nil);
            UDSet(@"propicdoc",nil);
            UDSet(@"propic", nil);
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


//Get specialization list of doctors
- (void)getAllSpecialization {
    NSString *visitId = patientService.visit_type_id;
    NSDictionary *parameter = [[NSDictionary alloc] initWithObjectsAndKeys:visitId,@"categoryId",nil];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service getAllDoctorCategories:parameter andVisitID:visitId WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        if([[responseCode objectForKey:@"status"] isEqualToString:@"succes"]){
            int isPracticeCallDone = [[[responseCode valueForKey:@"data"] valueForKey:@"is_practice_call_done"] intValue];
            patientService.isPracticeCallDone = isPracticeCallDone;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//Get Total Badge Counts in Health Record
-(void)getBadgeCounts{
    CommonServiceHandler * service = [[CommonServiceHandler alloc]init];
    [service getBadgeCounts:nil WithCompletionBlock:^(NSDictionary * responseData, NSError* error){
        if([[responseData valueForKey:@"status"] isEqualToString:@"success"]){
            healthRecordCount = [[[responseData objectForKey:@"data" ] objectForKey:@"totalcount"] intValue];
            appointmentCount = [[[responseData objectForKey:@"data" ] objectForKey:@"totalmessagesCount"] intValue];
            if(appointmentCount > 0 || healthRecordCount >0){
                [self.collectionViewDashbaord reloadData];
            }
        }
    }];
}

/*Refresh the page when internet connects.*/
-(void)refreshView:(NSNotification*)notification{
    [self getUserPrfile];
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}

@end
