//
//  PatientViewDetailVC.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 10/6/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "PatientViewDetailVC.h"
#import "CommonServiceHandler.h"
#import "IODUtils.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HexString.h"

@interface PatientViewDetailVC ()<UITextViewDelegate>{
    NSDictionary *dictData;
    NSArray *arrVitals;
    NSArray *arrVitalAppendText;
    
    NSArray *arrDetails;
    NSMutableArray *arrQnadA;
}
@end

@implementation PatientViewDetailVC

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    [self.collv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];

    self.title = @"View Detail";
    dictData=[NSDictionary new];
    arrVitals= [NSArray arrayWithObjects:@"Body Temperature:",@"Blood Pressure:",@"Pulse Rate:",@"Respiratory Rate:",@"Blood Glucose:", nil];
    arrDetails= [NSArray arrayWithObjects:@"Referrel Doctor:",@"Person is:",@"Purpose:",@"Medications:",@"Allergies:",@"Pre-diagnosed:",@"Vitals:", nil];
    
    arrVitalAppendText =[NSArray arrayWithObjects:@" F",@" mm",@" per Min",@" per Min",@" mg", nil];
    
    [self getPatientViewDetails];
    
    NSDictionary *userDict = UDGet(@"UserData");
    //NSLog(@"User details:%@",userDict);
    _lblUserName.text = [NSString stringWithFormat:@"%@",[userDict valueForKey:@"name"]];
    _lblUserAge.text = [NSString stringWithFormat:@"Age: %li",(long)[IODUtils calculateAge:[userDict valueForKey:@"dob"]]];
    _lblUserGender.text = [NSString stringWithFormat:@"%@",[userDict valueForKey:@"gender"]];
    if([_lblUserGender.text isEqualToString:@"Other"] || [_lblUserGender.text isEqualToString:@"2"]){
        _lblUserGender.text = @"";
    }
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"dd/MMM/YYYY"];
    //NSString *currentDate=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    _lblDate.text =  _date;
    
    _lblDocName.text = [NSString stringWithFormat:@"Dr. %@",[_listOfdata valueForKey:@"doctor_name"]];
    _lblDocGender.text = [NSString stringWithFormat:@"%@",[_listOfdata valueForKey:@"doctor_gender"]];
    _lblDoctSpecialise.text = [NSString stringWithFormat:@"%@",[_listOfdata valueForKey:@"doctor_specialization"]];
    
    NSString *color = [IODUtils setStatusColor :[_listOfdata valueForKey:@"status"]];
    [_btnStatus setBackgroundColor:[UIColor colorWithHexRGB:color]];
    [_btnStatus setTitle:[_listOfdata valueForKey:@"status"] forState:UIControlStateNormal];
  
    CGFloat radius = _imgView.bounds.size.width / 2;
    [_imgView.layer setCornerRadius:radius];
    _imgView.clipsToBounds = YES;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[_listOfdata valueForKey:@"doctor_profile"]] placeholderImage:[UIImage imageNamed:@"p-calling-icon.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    
    self.constraintTreatment.constant=_txtTreatment.contentSize.height+20;
    self.constraintDiagnose.constant=_ttDiagnose.contentSize.height+20;
    
    
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
    
    [_txtTreatment setUserInteractionEnabled:NO];
    [_ttDiagnose setUserInteractionEnabled:NO];
    _ttDiagnose.delegate = self;
    _txtTreatment.delegate = self;

   // [_collv setBackgroundColor:[UIColor clearColor]];
}

-(void)textViewDidChange:(UITextView *)textView{

    
    if (textView == _txtTreatment) {
        self.constraintTreatment.constant=textView.contentSize.height+20;
    }
    else if (textView==_ttDiagnose) {
        self.constraintDiagnose.constant=textView.contentSize.height+20;
    }
    [[(UIView *)textView.superview heightAnchor]constraintGreaterThanOrEqualToConstant:textView.frame.size.height].active=YES;
}

-(void)updateTime{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnSubmitPressed:(id)sender {
    // [self PostDiagnosisDetails];
}

-(void) getPatientViewDetails {
    CommonServiceHandler *service =[[CommonServiceHandler alloc]init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:_visitorId forKey:@"visitId"];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach.isReachable;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (reachable) {
        [service getPatientsViewDetails:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            //NSLog(@"Response code %@", responseCode);
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

                NSLog(@"%@", arrQnadA);
           
                
                
                NSDictionary *dict = [dictData valueForKey:@"details"];
                
                 if(![[dict valueForKey:@"treatmentPlan"] isKindOfClass:[NSNull class]]){
                 self.txtTreatment.text=[dict valueForKey:@"treatmentPlan"];
                 [self.txtTreatment sizeToFit];
                 self.txtTreatment.scrollEnabled = YES;
                 [self.txtTreatment layoutIfNeeded];
                 
                 }
                 if(![[dict valueForKey:@"diagnosis"] isKindOfClass:[NSNull class]]){
                 self.ttDiagnose.text=[dict valueForKey:@"diagnosis"];
                 self.constraintDiagnose.constant=self.ttDiagnose.contentSize.height+20;
                 
                 [[(UIView *)self.ttDiagnose.superview heightAnchor]constraintGreaterThanOrEqualToConstant:self.ttDiagnose.frame.size.height].active=YES;
                 
                 [self.view updateConstraints];
                 [self.view layoutIfNeeded];
                 }
                
                
               
                if(![[dict valueForKey:@"treatmentPlan"] isKindOfClass:[NSNull class]]){
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
        }];
    }
    else{
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Collection view delegates
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
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
   else if([lblTitle.text isEqualToString:@"vitals"])
   {
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
       txtv.text =strAppend;//
       txtv.text =strAppend;
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
   // [cell.contentView addSubview:imgHont];
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

-(void)refreshView:(NSNotification *) notification {
    [self getPatientViewDetails];
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}


@end
