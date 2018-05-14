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

#pragma mark - View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_isFirstLogin == 1 ){
        if(![_strPrice isEqualToString:@"(null)"]){
            [self showCoupon];
        }
    }
    else{
    }
    //  [self getAllBlogs];
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
            //NSLog(@"response code");
        }];
    }
    else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
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
    // [_editProfileImg setUserInteractionEnabled:YES];
    //  [_editProfileImg addGestureRecognizer:tapG];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
    //  _imgProfilePic.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
    }
    regisService = [RegistrationService sharedManager];
    [self getBadgeCounts];
    [self getAllSpecialization];
    
    [_collectionViewDashbaord reloadData];
    if([docService.isEVisit isEqualToString:@"yes"]){
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"another-hand-bell" ofType:@"mp3"]] error:&error];
        if (error) {
            // NSLog(@"Error : %@", [error localizedDescription]);
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
    //[logoutButton setTintColor:[UIColor whiteColor]];
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

-(void)viewDidDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Add Pages To ScrollView (Testing)
- (void) addNoOfPagesHorizontally:(NSInteger)pages {
    for (id v in _scrollView.subviews) {
       // if (![v isKindOfClass:[UIImageView class]]) {
            [v removeFromSuperview];
       // }
    }
    
   // [pageController removeFromSuperview];
    NSInteger numberOfPages = pages;
    NSInteger x = 0; //start X position inside scrollview
    NSInteger y = 0; //start Y position inside scrollview
    NSInteger w = _scrollView.frame.size.width; //width of page
    NSInteger h = _scrollView.frame.size.height; //height of page
    
    //For testing we're adding UILabels.
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
        
        [imgBanner setBackgroundColor:[UIColor colorWithRed:[self getRandomInt] green:[self getRandomInt] blue:[self getRandomInt] alpha:1.0]];
        
        UIImageView *imgTransBg = [[UIImageView alloc] init];
        imgTransBg.frame = CGRectMake(0, v.frame.size.height/2 , v.frame.size.width/1.3, 100);
        imgTransBg.image = [UIImage imageNamed:@"trans-bnr-bg"];
        
        UILabel *lblTitle = [[UILabel alloc] init];
        lblTitle.frame = CGRectMake(20, v.frame.size.height/2, imgTransBg.frame.size.width - 20,70);
        lblTitle.text = [NSString stringWithFormat:@"%@",[[arrBlogs objectAtIndex:i] valueForKey:@"post_title"]];
        lblTitle.font = [UIFont boldSystemFontOfSize:17.0];        
        lblTitle.numberOfLines = 3;
   
        NSString *strThumbnail = [[arrBlogs objectAtIndex:i] objectForKey:@"thumbnail"];
        if(strThumbnail == nil){
            strThumbnail = [[arrBlogs objectAtIndex:i] objectForKey:@"thumbnail_portrait"];
        }
        [imgBanner sd_setImageWithURL:[NSURL URLWithString:strThumbnail] placeholderImage:[UIImage imageNamed:@"P-banner-no-img"]];
        [v addSubview:imgBanner];
        [v addSubview:imgTransBg];
        [v addSubview:lblTitle];
        [v bringSubviewToFront:btnBanner];
        [_scrollView addSubview:v];
        x+=_scrollView.frame.size.width;
    }
    [_scrollView setContentSize:CGSizeMake(x, _scrollView.frame.size.height)];
    //set scrollview properties (needed for better work)
    [_scrollView setPagingEnabled:YES];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_wrapper addSubview:pageController];
  //  [pageController setFrame:CGRectMake(0,150,_wrapper.frame.size.width , 20)];
 //   pageController.center = self.view.center;
 //   [_scrollView addSubview:pageController];
    [pageController setImageActiveState:[UIImage  imageNamed:@"selected.png"] InActiveState:[UIImage  imageNamed:@"unselected.png"]];
}

- (void) configureHorizontalControllerWithTotalPages:(NSInteger)totalPages {
    
    
    if(pageController){
        [pageController removeFromSuperview];
    }
    pageController = [[HHPageView alloc] init];
    [pageController setFrame:CGRectMake(0, _wrapper.frame.size.height - 40, SCREEN_WIDTH, 40)];
    [_wrapper addSubview:pageController];
   // pageController.center = _wrapper.center;
    
    [_wrapper bringSubviewToFront:pageController];

    //Set delegate to the page controller object. To handle page change event.
    [pageController setDelegate:self];
    
    //Set Base View
    //Note: You don't need to set baseScrollView if there's only one HHPageView per view controller.
   // [pageController setBaseScrollView:_scrollView];
    
    //Set Images for Active and Inactive state.
    [pageController setImageActiveState:[UIImage  imageNamed:@"selected.png"] InActiveState:[UIImage  imageNamed:@"unselected.png"]];
    
    //Tell PageController, the number of pages you want to show.
   [pageController setNumberOfPages:totalPages];
    
    //Tell PageController to show page from this page index.
   [pageController setCurrentPage:1];
    
    //Show when you ready!
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
        if(baseScrollView.tag == HORIZONTAL_SCROLLVIEW_TAG) {
            [baseScrollView setContentOffset:CGPointMake(currentIndex * _scrollView.frame.size.width, 0) animated:YES];
            
    } else {
        //If you've only single HHPageController for any of the view then no need to set baseScrollView.
       // NSLog(@"You forgot to set baseScrollView for the HHPageView object!");
    }
    }
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.imgProfilePic.layer setBorderColor:[UIColor whiteColor].CGColor];
        self.imgProfilePic.layer.cornerRadius=self.imgProfilePic.frame.size.height/2;
        self.imgProfilePic.layer.masksToBounds=YES;
        [self.view setNeedsLayout];
        [self.collectionViewDashbaord reloadData];
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    }];
}

#pragma mark - Void Methods

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showCoupon {
    couponBackgroundV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIView *couponV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [couponBackgroundV setBackgroundColor:[UIColor clearColor]];
    couponV.center = couponBackgroundV.center;
    [couponV setBackgroundColor:[UIColor whiteColor]];
    [couponV.layer setCornerRadius:6.0];
    [couponV.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [couponV.layer setBorderWidth:1.0];
    
    UIImageView *imgCoupon = [[UIImageView alloc] init];
    [imgCoupon setFrame:CGRectMake(40, 20, 120, 120)];
    [imgCoupon setImage:[UIImage imageNamed:@"coupon-discount.png"]];
    
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = couponBackgroundV.frame;
    [img setImage:[UIImage imageNamed:@"black-transparent-bg"]];
    
    
    UILabel *lblCoupon = [[UILabel alloc] initWithFrame:CGRectMake(70, 86,65, 20)];
    lblCoupon.text = _strCouponCode;
    lblCoupon.font = [UIFont boldSystemFontOfSize:13.0];
    lblCoupon.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lblCouponText = [[UILabel alloc] initWithFrame:CGRectMake(10, 135,180, 40)];
    lblCouponText.numberOfLines = 2;
    lblCouponText.text = [NSString stringWithFormat:@"Received a one-time-use coupon code! for worth $%@",_strPrice];
    
    lblCouponText.font = [UIFont systemFontOfSize:9.0];
    lblCouponText.textAlignment = NSTextAlignmentCenter;
    NSString *expDate = [IODUtils formatDateForUIFromString:_strExpireDate];
    UILabel *lblExpireText = [[UILabel alloc] initWithFrame:CGRectMake(10, 175,180, 20)];
    lblExpireText.text = [NSString stringWithFormat:@"Expires on %@",expDate];
    lblExpireText.font = [UIFont systemFontOfSize:9.0];
    lblExpireText.textAlignment = NSTextAlignmentCenter;
    lblExpireText.textColor = [UIColor colorWithHexRGB:@"#B84140"];
  
    int x = couponBackgroundV.center.x - 20 + couponV.frame.size.width/2;
    int y = couponBackgroundV.center.y - 15 - couponV.frame.size.width/2;
    
    UIButton *btnCloseView = [[UIButton alloc] initWithFrame: CGRectMake(x, y, 30, 30)];
    [btnCloseView setBackgroundImage:[UIImage imageNamed:@"close-icon"] forState:UIControlStateNormal];
    [btnCloseView addTarget:self action:@selector(hideCouponView:) forControlEvents:UIControlEventTouchUpInside];
    [couponV addSubview:imgCoupon];
    [couponV addSubview:lblCoupon];
    [couponV addSubview:lblCouponText];
    [couponV addSubview:lblExpireText];
    
    [self.view addSubview:couponBackgroundV];
    [couponBackgroundV addSubview:img];
    [couponBackgroundV addSubview:couponV];
    [couponBackgroundV addSubview:btnCloseView];
}

-(void)getAllBlogs{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [MBProgressHUD showHUDAddedTo:_wrapper animated:YES];
    [service getAllBlogs:nil WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:_wrapper animated:YES];
       // NSLog(@"Response is %@", responseCode);
        if([[responseCode objectForKey:@"status"] isEqualToString:@"success"]){
            arrBlogs = [responseCode valueForKey:@"data"];
            NSInteger numberOfPages = arrBlogs.count;
            //Horizontal Controller ScrollView
           // [self configureHorizontalControllerWithTotalPages:numberOfPages];
            [self addNoOfPagesHorizontally:numberOfPages];
            [self configureHorizontalControllerWithTotalPages:numberOfPages];
        }
        else{
            if([error.localizedDescription isEqualToString:@"Request failed: forbidden (403)"]){
               [self logOut];
            }
        }
    }];
}

-(void)callAfter4Second:(NSTimer*) t {
    
    int opt1 = _wrapper.frame.size.width+1;
    int opt2 = _wrapper.frame.size.width *2 +1;
    int opt3 = 0;
    NSArray *arrobj = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:opt1],[NSNumber numberWithInt:opt2],[NSNumber numberWithInt:opt3], nil];
    int offset =[[arrobj objectAtIndex: arc4random() % [arrobj count]] intValue];
    
     [_scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
        //horizontal
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

-(void)animateLabel:(UILabel *)lbl {
    
    lbl.text = [[self.arrDashBoardImages objectAtIndex:4] valueForKey:@"Title"];
    lbl.alpha = 1;
    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        lbl.alpha = 0;
    } completion:nil];
}

- (void) getUserPrfile{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    //  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service getUserProfile:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]){
            NSMutableDictionary *dictdata = [[responseCode objectForKey:@"data"] mutableCopy];
            [dictdata removeObjectForKey:@"weightt"];
            [dictdata removeObjectForKey:@"blood_group"];
            [dictdata removeObjectForKey:@"height"];
            UDSet(@"UserData", dictdata);
            
            NSString *strname = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"name"]];
            UDSet(@"usname", strname);
            
            NSString *profilePic = [NSString stringWithFormat:@"%@", [dictdata valueForKey:@"profile_pic"]];
            UDSet(@"profilePic", profilePic);
            UIImage *imgPro=[NSKeyedUnarchiver unarchiveObjectWithData: UDGet(@"propic")];
            
            if (!imgPro) {
                imgPro=[UIImage imageNamed:@"D-calling-icon.png"] ;
            }
            
            //        [self.imgProfilePic sd_setImageWithURL:[NSURL URLWithString:profilePic] placeholderImage:imgPro completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            //            UDSet(@"propic", [NSKeyedArchiver archivedDataWithRootObject:image]);
            //        }];
            //            _lblName.text =strname;
            //
            
            NSString *strCountry =[NSString stringWithFormat:@"%@",[dictdata valueForKey:@"country"]];
            
            NSString *strState =[NSString stringWithFormat:@"%@, ",[dictdata valueForKey:@"state"]];
            NSString *strCity =[NSString stringWithFormat:@"%@, ",[dictdata valueForKey:@"city"]];
            
            if([strCity isEqualToString:@", "]){
                strCity = @"";
            }
            
            if([strState isEqualToString:@", "]){
                strState = @"";
            }
            
            if([strCountry isEqualToString:@""]){
                strCountry = @"";
            }
            NSString *strAddress = [NSString stringWithFormat:@"%@%@%@",strCity,strState,strCountry];
            
            UDSet(@"userinfo", ([NSKeyedArchiver archivedDataWithRootObject:@{@"name":strname,@"address":strAddress}]));
            UDSet(@"userType", @"Patient");
        }
    }];
}

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
//Mohit
-(void)getBadgeCounts{
    CommonServiceHandler * service = [[CommonServiceHandler alloc]init];
    [service getBadgeCounts:nil WithCompletionBlock:^(NSDictionary * responseData, NSError* error){
        //NSLog(@"Response data is:-%@",responseData);
        if([[responseData valueForKey:@"status"] isEqualToString:@"success"]){
            healthRecordCount = [[[responseData objectForKey:@"data" ] objectForKey:@"totalcount"] intValue];
            // NSLog(@"Health Count is:-%d",healthRecordCount);
            appointmentCount = [[[responseData objectForKey:@"data" ] objectForKey:@"totalmessagesCount"] intValue];
            
            
            if(appointmentCount > 0 || healthRecordCount >0){
                [self.collectionViewDashbaord reloadData];
            }
        }
        else{
        }
    }];
}


#pragma mark - IBAction Methods

-(IBAction)hideCouponView:(id)sender{
    [couponBackgroundV setHidden:YES];
}

-(IBAction)clickOnBlog:(UIButton *) btn {
    int tag = btn.tag;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FileViewController *fileViewMe  = [sb instantiateViewControllerWithIdentifier:@"FileViewController"];
    fileViewMe.strFilePath=[[arrBlogs objectAtIndex:tag] valueForKey:@"guid"];
    fileViewMe.strTitle=[[arrBlogs objectAtIndex:tag] valueForKey:@"post_title"];
    [self.navigationController pushViewController:fileViewMe animated:YES];
}

#pragma mark - Collectionview Delegate & Datasource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrDashBoardImages.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    return CGSizeMake(self.collectionViewDashbaord.frame.size.width/3.01,self.collectionViewDashbaord.frame.size.height/2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

-(DashboardXibCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DashboardXibCell *cell=(DashboardXibCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DashboardXibCell" forIndexPath:indexPath];
    [cell layoutIfNeeded];
    NSString *imgDashboardName = [[self.arrDashBoardImages objectAtIndex:indexPath.row] valueForKey:@"imageName"];
    NSString *DashboardTitle = [[self.arrDashBoardImages objectAtIndex:indexPath.row] valueForKey:@"Title"];
    
    cell.lblDashboardTitle.text=DashboardTitle;
    
    //---------------- Mohit---------
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
    else{
        cell.lblCount.hidden = true;
    }
    
    
//----------------------------------------------------
    
    NSString *backgroundColor =[[self.arrDashBoardImages objectAtIndex:indexPath.row] valueForKey:@"Color"];
    cell.backgroundColor = [UIColor clearColor];
    cell.lblDashboardTitle.textColor  = [UIColor blackColor];
    cell.lblDashboardTitle.font = [UIFont systemFontOfSize:14.0];
    
    cell.imgDashboardCell.image = [UIImage imageNamed:imgDashboardName];
        if([DashboardTitle containsString:@"Health"]){
            if ([docService.isEVisit isEqualToString:@"yes"])
            {
                [cell.imgbellIcon setHidden:NO];
            }
            else{
             cell.lblDashboardTitle.textColor  = [UIColor blackColor];
                [cell.imgbellIcon setHidden:YES];
            }
        }
        else{
            [cell.imgbellIcon setHidden:YES];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    patientService.payment_mode_id = 0;
    
    
    if(indexPath.item == 0 ) {
        patientService.visit_type_id = @"1";
        patientService.isFromliveCall = @"no";
        patientService.slot_id = @"";
        patientService.documentName = [[NSMutableArray alloc] init];
        patientService.arrDocumentData = [[NSMutableArray alloc] init];
        //  UIViewController *viewTab=[self.storyboard instantiateViewControllerWithIdentifier:@"TabbarCategoryViewController"];
        
        SelectPatientViewController *selectPatientVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectPatientViewController"];
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
        
        //   UIViewController *viewTab=[self.storyboard instantiateViewControllerWithIdentifier:@"tabbarEditView"];
        //   [self.navigationController pushViewController:viewTab animated:YES];
    }
    if (indexPath.item == 5) {
        
        //        patientService.visit_type_id = @"4";
        //        patientService.selectedTab = @"0";
        //
        //        UIViewController *viewTab=[self.storyboard instantiateViewControllerWithIdentifier:@"tabbarEdit"];
        //        [self.navigationController pushViewController:viewTab animated:YES];
        
        patientService.visit_type_id = @"4";
        patientService.isFrom = @"MyAppointment";
        UIViewController *viewTab=[self.storyboard instantiateViewControllerWithIdentifier:@"E_VisitPage"];
        [self.navigationController pushViewController:viewTab animated:YES];
        
        
    }
    if (indexPath.item == 3){
        
        //        patientService.visit_type_id = @"4";
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

#pragma mark - RefreshView Methods If Internet Connection Lost

-(void)refreshView:(NSNotification*)notification{
    [self getUserPrfile];
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}


@end
