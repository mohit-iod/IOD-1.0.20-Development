//
//  QandADoctViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/16/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "QandADoctViewController.h"
#import "CommonServiceHandler.h"
#import "DoctorAppointmentServiceHandler.h"
#import "IODUtils.h"
#import "UIColor+HexString.h"
#import  "TabbarCategoryViewController.h"
#import "UIImageView+WebCache.h"

@interface QandADoctViewController ()
{
    DoctorAppointmentServiceHandler *docService;
    NSArray *arrVitals;
    NSArray *arrDetails;
    NSArray *arrVitalAppendText;
    NSMutableArray *arrQnadA;
    
}
@end

@implementation QandADoctViewController
{
    NSDictionary *dictData;
}

-(void)backPop{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = nil;
    [super viewDidLoad];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
     self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    [self.collv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];

    // Do any additional setup after loading the view.
    docService = [DoctorAppointmentServiceHandler sharedManager];
    [self getPatientQuestionaires];
    [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(updateTime)
                                   userInfo:nil
                                    repeats:NO];
    _ttDiagnose.layer.borderColor=[UIColor colorWithHexRGB:@"879251"].CGColor;
    _txtTreatment.layer.borderColor=[UIColor colorWithHexRGB:@"879251"].CGColor;
    _txtTreatment.layer.cornerRadius=3;
    _ttDiagnose.layer.borderWidth=1;
    _txtTreatment.layer.borderWidth=1;
    _ttDiagnose.layer.cornerRadius=3;
    dictData=[NSDictionary new];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSString *currentDate;
      currentDate=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
        currentDate = [IODUtils ChangeDateFormat:currentDate];
    _lblDate.text = currentDate;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
    
    NSString *color = [IODUtils setStatusColor :docService.status];
    [_btnStatus setBackgroundColor:[UIColor colorWithHexRGB:color]];
    [_btnStatus setTitle:docService.status forState:UIControlStateNormal];
    
    NSDictionary *userDict = UDGet(@"SelectedUser");
    if([docService.callEnd isEqualToString:@"yes"])
    {
        _lblUserName.text = [NSString stringWithFormat:@"%@",docService.patient_name];
        _lblUserGender.text = [NSString stringWithFormat:@"%@",docService.patient_gender];
        
        if([_lblUserGender.text isEqualToString:@"<null>"] || [_lblUserGender.text isEqualToString:@"2"]){
            _lblUserGender.text = @"";
        }
        _lblDocName.text = UDGet(@"uname");
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
 
    CGFloat radius = _imgView.bounds.size.width / 2;
    [_imgView.layer setCornerRadius:radius];
    _imgView.clipsToBounds = YES;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[userDict valueForKey:@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"P-calling-icon.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    [_imgView.layer setCornerRadius:_imgView.frame.size.width/2];
    _imgView.layer.masksToBounds = YES;
    
    self.constraintTreatment.constant=_txtTreatment.contentSize.height+20;
    self.constraintDiagnose.constant=_ttDiagnose.contentSize.height+20;
    
    arrVitals= [NSArray arrayWithObjects:@"Body Temperature:",@"Blood Pressure:",@"Pulse Rate:",@"Respiratory Rate:",@"Blood Glucose:", nil];
    
   arrVitalAppendText =[NSArray arrayWithObjects:@" F",@" mm",@" per Min",@" per Min",@" mg", nil];

    arrDetails= [NSArray arrayWithObjects:@"Referrel Doctor:",@"Person is:",@"Purpose:",@"Medications:",@"Allergies:",@"Pre-diagnosed:",@"Vitals:", nil];
    
    UITabBarController *tabBarController = (TabbarCategoryViewController *)self.parentViewController;
    NSMutableArray *viewControllersCopy = [[tabBarController viewControllers] mutableCopy];
    
    NSString *strName  = [NSString stringWithFormat:@"%@",UDGet(@"uid")];
     NSString *userID = UDGet(@"uid");
    
    NSString *strselectedDoctor = [NSString stringWithFormat:@"%@",docService.selctedDoctorId];
   if ([docService.status isEqualToString:@"Call interrupted"] || [docService.status isEqualToString:@"Interrupted"]){
       _ttDiagnose.editable = true;
       _txtTreatment.editable = true;
    }
    
    
    NSString *selectedDoctorid = [NSString stringWithFormat:@"%@",docService.selctedDoctorId ];
    if(  ![selectedDoctorid isEqualToString:strName] && (![docService.status isEqualToString:@"callend"]))
    {
        
        
        viewControllersCopy = [[tabBarController viewControllers] mutableCopy];
        NSArray *modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
        modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
        [tabBarController setViewControllers:modifiedViewControllers animated:NO];
        
        NSLog(@"Count %d", modifiedViewControllers.count);
        if(modifiedViewControllers.count == 2){
            
        }
        else {
            viewControllersCopy = [[tabBarController viewControllers] mutableCopy];
            [viewControllersCopy removeObjectAtIndex:2];
            
            NSArray *MViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
            [viewControllersCopy removeObjectAtIndex:2];
            MViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
            [viewControllersCopy removeObjectAtIndex:2];
            MViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
            [tabBarController setViewControllers:MViewControllers animated:NO];
            return;
        }
    }
    
    if(docService.isFromVideo == 0) {
        if([docService.status isEqualToString:@"callend"]){
            viewControllersCopy = [[tabBarController viewControllers] mutableCopy];
            NSArray *modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
            modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
            [tabBarController setViewControllers:modifiedViewControllers animated:NO];
    }
    else if([docService.status isEqualToString:@"Successful"] && [docService.isFilled isEqualToString:@"1"]) {
        
        if(![strName isEqualToString:strselectedDoctor]) {
            viewControllersCopy = [[tabBarController viewControllers] mutableCopy];
            [viewControllersCopy removeObjectAtIndex:2];
            NSArray *modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
            [viewControllersCopy removeObjectAtIndex:2];
            modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
            [viewControllersCopy removeObjectAtIndex:2];
            modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
            [tabBarController setViewControllers:modifiedViewControllers animated:NO];
            
        }
        else{
            viewControllersCopy = [[tabBarController viewControllers] mutableCopy];
            [viewControllersCopy removeObjectAtIndex:2];
            NSArray *modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
            [viewControllersCopy removeObjectAtIndex:2];
            modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
            [viewControllersCopy removeObjectAtIndex:2];
            modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
            [tabBarController setViewControllers:modifiedViewControllers animated:NO];
        }
    }
        
    else if([docService.isFilled isEqualToString:@"0"]) {
        viewControllersCopy = [[tabBarController viewControllers] mutableCopy];
        NSArray *modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
        modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
        [tabBarController setViewControllers:modifiedViewControllers animated:NO];
        
        return;
    }
        
    
    else if([docService.visit_type isEqualToString:@"3"]) {
        viewControllersCopy = [[tabBarController viewControllers] mutableCopy];
        NSArray *modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
        modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
        [tabBarController setViewControllers:modifiedViewControllers animated:NO];
        [viewControllersCopy removeObjectAtIndex:4];
        modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
        [tabBarController setViewControllers:modifiedViewControllers animated:NO];
        return;
    }
    else{
        viewControllersCopy = [[tabBarController viewControllers] mutableCopy];
        NSArray *modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
        modifiedViewControllers = [[NSArray alloc] initWithArray:viewControllersCopy];
        [tabBarController setViewControllers:modifiedViewControllers animated:NO];
        return;
    }
        
 
      
        
    
    }
}

- (void)viewWillAppear:(BOOL)animated{
    if (docService.isFromVideo == 1) {
        self.viewheight.constant = 0;
        self.buttonHeight.constant= 0;
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
    else if (![docService.status isEqualToString:@"Call interrupted"] && [docService.callEnd isEqualToString:@"no"] ) {
        if( ![docService.status isEqualToString:@"Successful"] && [docService.isFilled isEqualToString:@"0"]){
            self.viewheight.constant = 0;
            self.buttonHeight.constant= 0;
        }
        else{
            
            if([docService.status isEqualToString:@"Call interrupted"] && [docService.callEnd isEqualToString:@"no"]){
                
            }
            else{
            _txtTreatment.editable = YES;
            _ttDiagnose.editable = YES;
           
                self.viewheight.constant = 84;
                 self.buttonHeight.constant = 30;
                
            }
           // return;
        }
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
    }
    else{
        _txtTreatment.editable = YES;
        _ttDiagnose.editable = YES;
    }
    
     if([docService.status isEqualToString:@"Successful"] && [docService.isFilled isEqualToString:@"1"]){
         _txtTreatment.editable = NO;
         _ttDiagnose.editable = NO;
         self.viewheight.constant = 0;
         self.buttonHeight.constant= 0;
         return;
    }
    if([docService.visit_type isEqualToString:@"3"]  || [docService.visit_type isEqualToString:@"2"]){
        if([docService.status isEqualToString:@"Successful"] && [docService.isFilled isEqualToString:@"1"]){
            _txtTreatment.editable = NO;
            _ttDiagnose.editable = NO;
            self.viewheight.constant = 0;
            self.buttonHeight.constant= 0;
            return;
        }
        if([docService.status isEqualToString:@"Pending"]){
            _txtTreatment.editable = NO;
            _ttDiagnose.editable = NO;
            self.viewheight.constant = 0;
            self.buttonHeight.constant= 0;
            return;
        }
    }
    
    NSString *userID =[NSString stringWithFormat:@"%@", UDGet(@"uid")];
    NSString *selectedDoctor = docService.selctedDoctorId;
    
    if(![selectedDoctor isEqualToString:userID] && (![docService.status isEqualToString:@"callend"])){
        _txtTreatment.editable = NO;
        _ttDiagnose.editable = NO;
        self.viewheight.constant = 0;
        self.buttonHeight.constant= 0;
        return;
        
    }
    

   
   
[self.view updateConstraints];
[self.view layoutIfNeeded];
}// Called when the view is about to made visible. Default does nothing

-(void)viewDidAppear:(BOOL)animated {
//    if(docService.diagnosis){
//        _ttDiagnose.text = docService.diagnosis;
//    }
//    if(docService.treatment){
//        _txtTreatment.text = docService.treatment;
//    }
}
- (void)viewDidUnload:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    
    
    
}// Called after the view was dismissed, covered or otherwise hidden. Default does nothing

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateTime{
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView ==_ttDiagnose) {
        docService.diagnosis = textView.text;
    }
    
    if(textView == _txtTreatment){
        docService.treatment = textView.text;
    }
    
    if (textView.text.length>1500) {
        textView.text=[textView.text substringToIndex:1500];
    }
    if (textView.frame.size.height>SCREEN_HEIGHT*0.45)
        
        return;
    

    if (textView == _txtTreatment) {
        self.constraintTreatment.constant=textView.contentSize.height+20;
    }
    else if (textView==_ttDiagnose) {
        self.constraintDiagnose.constant=textView.contentSize.height+20;
        docService.diagnosis = textView.text;
    }
    [[(UIView *)textView.superview heightAnchor]constraintGreaterThanOrEqualToConstant:textView.frame.size.height].active=YES;
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void) getPatientQuestionaires{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSString *strVisitId = docService.visit_id;
    
    [parameter setObject:strVisitId forKey:@"visitId"];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
        [service getQuestionAnswerDetails:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            //NSLog(@"Response code %@", responseCode);
            if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]) {
                dictData = [responseCode valueForKey:@"data"];
                
                 arrQnadA  = [[NSMutableArray alloc] init];
                if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]) {
                    dictData = [responseCode valueForKey:@"data"];
                    
                    NSMutableArray  *QnadA=[[dictData valueForKey:@"question-ans"]mutableCopy];
                    for(int i = 0; i < QnadA.count ; i++){
                        
                        NSString *str = [NSString stringWithFormat:@"%@",[[QnadA  objectAtIndex: i ] valueForKey:@"answer"]];
                        
                        if(!([str isEqualToString:@"<null>"] ) && !([str isEqualToString:@",,,,"] ) && !([str isEqualToString:@" , , , , "] ) ){
                            
                            NSString *str = [NSString stringWithFormat:@"%@",[[QnadA  objectAtIndex: i ] valueForKey:@"question"]];
                            if(![str isEqualToString:@"Refferel Doctor"])
                                [arrQnadA addObject: [QnadA objectAtIndex:i]];
                        }
                    }
                    [_collv reloadData];
                    _lblCounter.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)arrQnadA.count];

                    NSDictionary *dict = [dictData valueForKey:@"details"];
                    
                     if(![[dict valueForKey:@"treatmentPlan"] isKindOfClass:[NSNull class]]){
                     self.txtTreatment.text=[dict valueForKey:@"treatmentPlan"];
                     [self.txtTreatment sizeToFit];
                     self.txtTreatment.scrollEnabled = YES;
                     [self.txtTreatment layoutIfNeeded];
                     
                     }
                     if(![[dict valueForKey:@"diagnosis"] isKindOfClass:[NSNull class]]){
                     self.ttDiagnose.text=[dict valueForKey:@"diagnosis"];
                         
                         docService.diagnosis = self.ttDiagnose.text;
                         
                         
                     self.constraintDiagnose.constant=self.ttDiagnose.contentSize.height+20;
                         
                     
                     [[(UIView *)self.ttDiagnose.superview heightAnchor]constraintGreaterThanOrEqualToConstant:self.ttDiagnose.frame.size.height].active=YES;
                     
                     [self.view updateConstraints];
                     [self.view layoutIfNeeded];
                     }
                     
                    
                    if(![[dict valueForKey:@"treatmentPlan"] isKindOfClass:[NSNull class]]){
                     self.txtTreatment.text=[dict valueForKey:@"treatmentPlan"];
                     self.txtTreatment.text=[dict valueForKey:@"treatmentPlan"];
                     self.constraintTreatment.constant=self.txtTreatment.contentSize.height+20;
                     
                     [[(UIView *)self.txtTreatment.superview heightAnchor]constraintGreaterThanOrEqualToConstant:self.txtTreatment.frame.size.height].active=YES;
                     
                     [self.view updateConstraints];
                     [self.view layoutIfNeeded];
                     }
                     if(![[dict valueForKey:@"diagnosis"] isKindOfClass:[NSNull class]]){
                     
                     self.ttDiagnose.text=[dict valueForKey:@"diagnosis"];
                     self.constraintDiagnose.constant=self.ttDiagnose.contentSize.height+20;
                     
                     [[(UIView *)self.ttDiagnose.superview heightAnchor]constraintGreaterThanOrEqualToConstant:self.ttDiagnose.frame.size.height].active=YES;
                     
                     [self.view updateConstraints];
                     [self.view layoutIfNeeded];
                     }
                     
                   
                     }
                [MBProgressHUD hideHUDForView:self.view animated:YES];

            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];
    }
    else {
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}


-(IBAction)btnSubmitPressed:(id)sender {
    
    if (_ttDiagnose.text.length == 0) {
        [IODUtils showFCAlertMessage:ENTER_DIAGNOSIS withTitle:@"" withViewController:self with:@"error"];
    }
    else {
    [self PostDiagnosisDetails];
    }
}

-(void)PostDiagnosisDetails{
    
    if(_ttDiagnose.text.length > 0) {
        CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        [parameter setObject:docService.visit_id forKey:@"patient_visit_id"];
        [parameter setObject:_txtTreatment.text forKey:@"treatment_plan"];
        [parameter setObject:_ttDiagnose.text forKey:@"diagnosis"];
        docService.diagnosis = _ttDiagnose.text;
        
        BOOL reachable = reach.isReachable;
        if (reachable) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service postCallDetails:parameter WithVisitId:docService.visit_id WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
                
                docService.treatment = @"";
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]) {
                    // [IODUtils showMessage:@"Data Saved!!, Do you want to continue ?" withTitle:@""];
                  //  [self.navigationController popToRootViewControllerAnimated:YES];
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kGotoNextPage message:@"" preferredStyle:UIAlertControllerStyleAlert];
                 
                    //We add buttons to the alert controller by creating UIAlertActions:
                    UIAlertAction *yesPressed = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        UITabBarController *tabBarController = (TabbarCategoryViewController *)self.parentViewController;
                        NSMutableArray *viewControllersCopy = [[tabBarController viewControllers] mutableCopy];
                        
                      [tabBarController setSelectedIndex:2];
                    }];

                    UIAlertAction *noPressed = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    [alertController addAction:noPressed];
                    [alertController addAction:yesPressed];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }];
        }
        else {
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        }
    }
    else {
        [IODUtils showAlertView:@"Please fill details"];
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
}


#pragma mark - Collection view delegates
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    [collectionView.collectionViewLayout invalidateLayout];
    return arrQnadA.count;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    // return CGSizeMake(collectionView.frame.size.width/4.1,collectionView.frame.size.height/4.1);
    return CGSizeMake(collectionView.frame.size.width,collectionView.frame.size.height);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    UIImageView *imgHont = [[UIImageView alloc] init];
    imgHont.image = [UIImage imageNamed:@"Qus-icon"];
    imgHont.frame = CGRectMake(10, 10, 25,25);
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(40, 15, cell.frame.size.width-20, 20);
    lblTitle.text = [NSString stringWithFormat:@"%@",[[arrQnadA objectAtIndex:indexPath.item] valueForKey:@"question"]];
    [cell.contentView addSubview:lblTitle];
    
    
    UIImageView *imgLine = [[UIImageView alloc] init];
    imgLine.backgroundColor = [UIColor colorWithHexRGB:kBorderColor];
    imgLine.frame = CGRectMake(0, 45,cell.frame.size.width ,1);
    
    
    UITextView *txtv = [[UITextView alloc] init];
    txtv.frame = CGRectMake(10, 50, cell.frame.size.width, cell.frame.size.height-60);
    
    if([lblTitle.text isEqualToString:@"Allergies"])
    {
        NSArray * items = [[arrQnadA objectAtIndex:indexPath.item] valueForKey:@"answer"];
        NSMutableString * bulletList = [NSMutableString stringWithCapacity:items.count*60];
        
        
        for (NSDictionary  * s in items)
        {
            [bulletList appendFormat:@"\u2022 %@ present since %@ \n \n", [s valueForKey:@"allergy"],[s valueForKey:@"how_long"]];
        }
        txtv.text = bulletList;
        
    }
    else if([lblTitle.text isEqualToString:@"vitals"])
    {
       /* NSString *data =  [[arrQnadA objectAtIndex:indexPath.item] valueForKey:@"answer"];
        NSArray * items = [data componentsSeparatedByString:@","];
        
        NSMutableString * bulletList = [NSMutableString stringWithCapacity:items.count*60];
        for (NSString  * s in items)
        {
            [bulletList appendFormat:@"\u2022  %@ \n \n", s];
        }
        txtv.text = bulletList;*/
        
        
        NSString *data =  [[arrQnadA objectAtIndex:indexPath.item] valueForKey:@"answer"];
        NSArray * items = [data componentsSeparatedByString:@","];
                           
        NSMutableString *strAppend = [NSMutableString string];
       NSMutableString * bulletList = [NSMutableString stringWithCapacity:items.count*60];
        for (int j=0; j<items.count; j++) {
            NSString *strVitals = [items objectAtIndex:j];
            
            if (strVitals.length > 0) {
                if (![strVitals isEqualToString:@" "]) {
                    [strAppend appendString:[NSString stringWithFormat:@"%@%@%@\n\n",[arrVitals objectAtIndex:j],strVitals,[arrVitalAppendText objectAtIndex:j]]];
                }
            }
        }
        txtv.text =strAppend;
        
    
    }
    else if([lblTitle.text isEqualToString:@"Current Medication"])
    {
        NSArray * items = [[arrQnadA objectAtIndex:indexPath.item] valueForKey:@"answer"];
        NSMutableString * bulletList = [NSMutableString stringWithCapacity:items.count*60];
        for (NSDictionary  * s in items)
        {
            [bulletList appendFormat:@"\u2022 %@ have been taking since %@ \n \n", [s valueForKey:@"medication"],[s valueForKey:@"how_long"]];
        }
        txtv.text = bulletList;
        
    }
    
    else if([lblTitle.text isEqualToString:@"Current Health conditions"])
    {
        
        NSString *data =  [[arrQnadA objectAtIndex:indexPath.item] valueForKey:@"answer"];
        NSArray * items = [data componentsSeparatedByString:@","];
        
        NSMutableString * bulletList = [NSMutableString stringWithCapacity:items.count*60];
        for (NSString  * s in items)
        {
            [bulletList appendFormat:@"\u2022  %@ \n \n", s];
        }
        txtv.text = bulletList;
        
    }
    else if([lblTitle.text isEqualToString:@"Symptoms"])
    {
        NSString *data =  [[arrQnadA objectAtIndex:indexPath.item] valueForKey:@"answer"];
        NSArray * items = [data componentsSeparatedByString:@","];
        
        NSMutableString * bulletList = [NSMutableString stringWithCapacity:items.count*60];
        for (NSString  * s in items)
        {
            [bulletList appendFormat:@"\u2022  %@ \n \n", s];
        }
        txtv.text = bulletList;
    }
    else if([lblTitle.text isEqualToString:@"Vitals"])
    {
        NSString *data =  [[arrQnadA objectAtIndex:indexPath.item] valueForKey:@"answer"];
        NSArray * items = [data componentsSeparatedByString:@","];
        
        NSMutableString * bulletList = [NSMutableString stringWithCapacity:items.count*60];
        for (NSString  * s in items)
        {
            [bulletList appendFormat:@"\u2022  %@ \n \n", s];
        }
        txtv.text = bulletList;
    }
    
    else if([lblTitle.text isEqualToString:@"Patient is"])
    {
        NSDictionary *dictSub =  [arrQnadA objectAtIndex:indexPath.item];
         NSString *ans = [[arrQnadA objectAtIndex:indexPath.item] valueForKey:@"answer"];
        
        
        if (![[dictSub objectForKey:@"dob"] isKindOfClass:[NSNull class]] && ![[dictSub objectForKey:@"gender"] isKindOfClass:[NSNull class]] ) {
            txtv.text = [NSString stringWithFormat:@"Family Member \n\nName: %@\n \n Gender: %@\n \n DOB: %@",ans,[dictSub objectForKey:@"gender"], [IODUtils formateStringToDateForUI:[dictSub objectForKey:@"dob"]]];
        }
        else{
            txtv.text = ans ;
        }
        
    }
    
    else{
        txtv.text = [NSString stringWithFormat:@"%@",[[arrQnadA objectAtIndex:indexPath.item] valueForKey:@"answer"]];
    }
    
    txtv.font = [UIFont systemFontOfSize:15.0];
    [cell.contentView addSubview:txtv];
    
    txtv.editable = NO;
    
    
    for (UILabel *lbl in cell.contentView.subviews)
    {
        if ([lbl isKindOfClass:[UILabel class]])
        {
            [lbl removeFromSuperview];
        }
    }
    
    [cell.contentView addSubview:lblTitle];
  //  [cell.contentView addSubview:imgHont];
    [cell.contentView addSubview:imgLine];
    
    [cell.layer setCornerRadius:5.0];
    [cell.layer setBorderWidth:1];
    [cell.layer setBorderColor:[UIColor colorWithHexRGB:kBorderColor].CGColor];
    
    cell.clipsToBounds = YES;
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGRect visibleRect = (CGRect){.origin = self.collv.contentOffset, .size = self.collv.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.collv indexPathForItemAtPoint:visiblePoint];
    _lblCounter.text = [NSString stringWithFormat:@"%ld/%lu",(long)visibleIndexPath.item +1,(unsigned long)arrQnadA.count];
}


-(void)refreshView:(NSNotification*)notification{
    [self getPatientQuestionaires];
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}



@end

