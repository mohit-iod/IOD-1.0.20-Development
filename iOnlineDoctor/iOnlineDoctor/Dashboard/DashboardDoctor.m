//
//  DashboardDoctor.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 8/30/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "DashboardDoctor.h"
#import "UIColor+HexString.h"
#import "CommonServiceHandler.h"
#import "UIImageView+WebCache.h"
#import "DEMONavigationController.h"
#import "LoginVC.h"
#import "REFrostedViewController.h"
#import "PatientAppointService.h"
#import "DoctorAppointmentServiceHandler.h"
#import "HHPageView.h"
#import "ExploreViewController.h"
#import "FileViewController.h"


#define HORIZONTAL_SCROLLVIEW_TAG 1
#define VERTICAL_SCROLLVIEW_TAG 2

@interface DashboardDoctor ()<HHPageViewDelegate>{
    REFrostedViewController *menu;
    
    DoctorAppointmentServiceHandler *docService;
    NSTimer* myTimer, *blogTimer;
    IBOutlet HHPageView *pageController;
    NSMutableArray *arrBlogs;
   }
@property(strong) NSMutableArray *arrDashBoardImages;

@end

@implementation DashboardDoctor


- (float)getRandomInt
{
    return (arc4random()%255)/255.f;
}

#pragma mark - Add Pages To ScrollView (Testing)
- (void) addNoOfPagesHorizontally:(NSInteger)pages {
    
    NSInteger numberOfPages = pages;
    NSInteger x = 0; //start X position inside scrollview
    NSInteger y = 0; //start Y position inside scrollview
    NSInteger w = _scrollView.frame.size.width; //width of page
    NSInteger h = _scrollView.frame.size.height; //height of page
    
    //For testing we're adding UILabels.
    for(NSInteger i = 0; i< arrBlogs.count; i++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        //  lbl.textColor = [UIColor whiteColor];
        // [v setBackgroundColor:[UIColor colorWithRed:[self getRandomInt] green:[self getRandomInt] blue:[self getRandomInt] alpha:1.0]];
        
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
}

-(IBAction)clickOnBlog:(UIButton *) btn {
    int tag = btn.tag;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FileViewController *fileViewMe  = [sb instantiateViewControllerWithIdentifier:@"FileViewController"];
    fileViewMe.strFilePath=[[arrBlogs objectAtIndex:tag] valueForKey:@"guid"];
    fileViewMe.strTitle=[[arrBlogs objectAtIndex:tag] valueForKey:@"post_title"];
    [self.navigationController pushViewController:fileViewMe animated:YES];
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
    [pageController setBaseScrollView:_scrollView];
    
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
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.imgProfilePic.layer setBorderColor:[UIColor whiteColor].CGColor];
        self.imgProfilePic.layer.cornerRadius=self.imgProfilePic.frame.size.height/2;
        self.imgProfilePic.layer.masksToBounds=YES;
        [self.view setNeedsLayout];
        [self.collectionViewDashbaord reloadData];
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        
    }];
}

-(void)getAllBlogs{
    
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [MBProgressHUD showHUDAddedTo:_wrapper animated:YES];
    [service getAllBlogs:nil WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:_wrapper animated:YES];
        if([[responseCode objectForKey:@"status"] isEqualToString:@"success"]){
            arrBlogs = [responseCode valueForKey:@"data"];
            NSInteger numberOfPages = arrBlogs.count;
            //Horizontal Controller ScrollView
            [self addNoOfPagesHorizontally:numberOfPages];
            [self configureHorizontalControllerWithTotalPages:numberOfPages];
//            blogTimer = [NSTimer scheduledTimerWithTimeInterval: 4.0 target: self
//                                                       selector: @selector(callAfter4Second:) userInfo: nil repeats: YES];
            //    [pageController setCurrentPage:3];
        }
        else{
            if([error.localizedDescription isEqualToString:@"Request failed: forbidden (403)"]){
                [self logOut];
            }
        }
    }];
}

-(void) viewDidAppear:(BOOL)animated{
    [self getAllBlogs];
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


-(void)viewDidLayoutSubviews{
  
    _imgProfilePic.layer.cornerRadius=_imgProfilePic.frame.size.height/2;
      [self.imgProfilePic.layer setBorderColor:[UIColor whiteColor].CGColor];
    _imgProfilePic.clipsToBounds = YES;
}


-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
    UIImage *imgPro=[NSKeyedUnarchiver unarchiveObjectWithData: UDGet(@"propicdoc")];
    if (!imgPro) {
        imgPro=[UIImage imageNamed:@"P-calling-icon.png"] ;
    }
    NSDictionary  *dictUserData=[NSKeyedUnarchiver unarchiveObjectWithData: UDGet(@"userinfodoc")];
    
    if (dictUserData) {
        _lblName.text =[dictUserData objectForKey:@"namedoc"];
        _lblAddress.text = [dictUserData objectForKey:@"addressdoc"];
    }
      _imgProfilePic.image=imgPro;
     _imgProfilePic.clipsToBounds = YES;

     [self setUI];
}
-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    [super viewDidLoad];
    [self setUI];
    [self getPatientDate];
  //  [self getAllBlogs];
    [pageController setDelegate:self];
     UDSet(@"userType", @"Doctor");

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
           // NSLog(@"response code");
        }];
    }
    else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
//    for (UIView *view in self.navigationController.navigationBar.subviews) {
//        [view setHidden:YES];
//    }
    
    [_imgProfilePic layoutIfNeeded];
    _imgProfilePic.layer.cornerRadius=_imgProfilePic.frame.size.height/2;
  
    _imgProfilePic.clipsToBounds = YES;
    
}

- (void)setUI{
    
    self.title=@"Home";
    [self.collectionViewDashbaord registerNib:[UINib nibWithNibName:@"DashboardXibCell" bundle:nil] forCellWithReuseIdentifier:@"DashboardXibCell"];
    [self.collectionViewDashbaord setContentInset:UIEdgeInsetsMake(0,0,0,0)];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    NSDictionary *dictdashboard =[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"DoctorDashboard" ofType:@"json"]];
    self.arrDashBoardImages  = [dictdashboard valueForKey:@"DoctorDashboard"];
    
    [self.imgProfilePic.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithImage:[UIImage imageNamed:@""]
                                     style:UIBarButtonItemStylePlain
                                     target:self action:@selector(showMenu)];
    //[logoutButton setTintColor:[UIColor whiteColor]];
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
//    [self.navigationController.navigationBar setAlpha:0.5];
    self.navigationItem.leftBarButtonItem = logoutButton;

    // menu = [[DEMONavigationController alloc] init];
    
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
        [self getUserPrfile];
    }
    else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}

- (void) showMenu {
    [(DEMONavigationController *)self.parentViewController showMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection view delegates
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.item ==1) {
         docService.isFromVideo = 0;
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PatientListViewController"] animated:YES];
    }
    else if (indexPath.item == 2) {
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"setBusinessHours"] animated:YES];
    }
    else if (indexPath.item == 0) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ExploreViewController  *viewTab=[self.storyboard instantiateViewControllerWithIdentifier:@"ExploreViewController"];
        viewTab.userType = @"doctor";
        [self.navigationController pushViewController:viewTab animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrDashBoardImages.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
        return CGSizeMake(self.collectionViewDashbaord.frame.size.width/3.01,self.collectionViewDashbaord.frame.size.height);
}

-(DashboardXibCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DashboardXibCell *cell=(DashboardXibCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DashboardXibCell" forIndexPath:indexPath];
    
    NSString *imgDashboardName = [[self.arrDashBoardImages objectAtIndex:indexPath.row] valueForKey:@"imageName"];
    NSString *DashboardTitle = [[self.arrDashBoardImages objectAtIndex:indexPath.row] valueForKey:@"Title"];
    cell.lblDashboardTitle.text=DashboardTitle;
    
    cell.lblDashboardTitle.textColor = [UIColor blackColor];
    
//    NSString *backgroundColor =[[self.arrDashBoardImages objectAtIndex:indexPath.row] valueForKey:@"Color"];
//    cell.backgroundColor = [[UIColor colorWithHexRGB:backgroundColor] colorWithAlphaComponent:1.0];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.imgDashboardCell.image = [UIImage imageNamed:imgDashboardName];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)getPatientDate {
  
}

- (void) getUserPrfile{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service getUserProfile:^(NSDictionary *responseCode, NSError *error) {
        if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]){
            NSDictionary *dictdata = [responseCode valueForKey:@"data"];
            NSString *strname = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"name"]];
            NSString *profilePic = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"profile_pic"]];
            UDSet(@"docprofilePic", profilePic);

            [self.imgProfilePic sd_setImageWithURL:[NSURL URLWithString:profilePic] placeholderImage:[UIImage imageNamed:@"P-calling-icon.png"]];
            UIImage *imgPro=[NSKeyedUnarchiver unarchiveObjectWithData: UDGet(@"propicdoc")];
            
            int countryId = [[dictdata valueForKey:@"country_id"] intValue];
            UDSetInt(@"cid", countryId);
            
            
            NSString *referalCode = [NSString stringWithFormat:@"%@",[dictdata valueForKey:@"referral_code"]];
            UDSet(@"referalcode", referalCode);
            
            if (!imgPro) {
                imgPro=[UIImage imageNamed:@"P-calling-icon.png"] ;
            }
            [self.imgProfilePic sd_setImageWithURL:[NSURL URLWithString:profilePic] placeholderImage:imgPro completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
            UDSet(@"propicdoc", [NSKeyedArchiver archivedDataWithRootObject:image]);
            }];
            _lblName.text =strname;
            
            NSString *strCountry =[NSString stringWithFormat:@"%@",[dictdata valueForKey:@"country"]];
            UDSet(@"country", strCountry);

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
            
            NSString *firstLetter = [strAddress substringToIndex:1];
            
            if([firstLetter isEqualToString:@","]){
                strAddress = [strAddress substringFromIndex:1];
            }
             _lblAddress.text = strAddress;
            _imgProfilePic.clipsToBounds = YES;
            UDSet(@"userinfodoc", ([NSKeyedArchiver archivedDataWithRootObject:@{@"name":strname,@"address":strAddress}]));
        }
    }];
}

- (IBAction)editButton:(id)sender {
//      [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"EditDoctorViewController"] animated:YES];
    UIViewController *viewTab=[self.storyboard instantiateViewControllerWithIdentifier:@"tabbarEdit"];
    [self.navigationController pushViewController:viewTab animated:YES];
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


@end
