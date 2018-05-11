//
//  BookAppointmentVC.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 10/4/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "BookAppointmentVC.h"
#import "FSCalendar.h"
#import "CommonServiceHandler.h"
#import "IODUtils.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "UIColor+HexString.h"
#import "PatientAppointService.h"
#import "pageViewControllerVC.h"
#import "PayeezySDK.h"
#import "CommonServiceHandler.h"
#import "SuccessfulPaymentViewController.h"
#import "PaymentViewController.h"
#import "SymptomsViewController.h"
#import "SelectPatientViewController.h"

@interface BookAppointmentVC ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>
{
    NSMutableArray *arrSlots;
    NSMutableArray *arrSlotsStatus;
    NSMutableArray *arrDoctorBusinessSlots;
    int selectdScheduleId;
    BOOL isFromCheckbox;
    NSString *strSlots;
    NSString *selectedDate;
    NSString *selectedSlotId;
    NSDate *appointmentDate;
    NSArray *arrayWithEvents;
    UIBarButtonItem *Save;
    int next;
    int  pre;
    int buttonPressed;
    int lastStatus;
    NSString *status;
    
    PatientAppointService *patientService;
     NSDate *lastSavedDate;
}
@property (nonatomic,strong) AppDelegate *appDelegate;
@property (retain, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSMutableArray *datesWithEvent;
@property (strong, nonatomic) NSMutableArray *slotsWithBookedEvent;
@property (strong, nonatomic) NSDateFormatter *dateFormatter2;

- (void)previousClicked:(id)sender;
- (void)nextClicked:(id)sender;

@end

@implementation BookAppointmentVC

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        [self.view setNeedsLayout];
        [self.calendar layoutIfNeeded];
        [self.calendar setFrame: CGRectMake(0, 0,self.view.frame.size.width,self.calendarContainer.frame.size.height)];
  
        [self.calendar reloadData];
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
    }];
}

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    BookSecondOpinionVC *bookVC = [[BookSecondOpinionVC alloc] init];
    bookVC.delegate = self;
    
    patientService = [PatientAppointService sharedManager];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
}


-(void) viewWillAppear:(BOOL)animated{
    
    if([patientService.visit_type_id isEqualToString:@"3"]) {
        self.title = @"Second opinion";
        [IODUtils showFCAlertMessage:kSecondopinionMessage  withTitle:@"" withViewController:self with:@"error"];
    }
    else {
        self.title = @"Book An Appointment";
    }
    [self addcal];
    self.dateFormatter2 = [[NSDateFormatter alloc] init];
    self.dateFormatter2.dateFormat = @"yyyy-MM-dd";
    [self.businessHourSlots registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    _calendar.delegate = self;
    NSString *currentDate = [IODUtils formatDateForServer:_calendar.today];
    selectedDate = currentDate;
    [self getAvailabeleDates : selectedDate];
    if([patientService.visit_type_id isEqualToString:@"2"]) {
        [self getSlotForCurrentDate:currentDate];
    }
    _datesWithEvent = [[NSMutableArray alloc] init];
    _slotsWithBookedEvent = [[NSMutableArray alloc] init];
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
    appointmentDate = [IODUtils formatDateAndTimeForServer:_calendar.today];
    
    // Do any additional setup after loading the view.
    strSlots = [[NSString alloc] init];
    
    Save = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(btnSubmitPressed:)];
    self.navigationItem.rightBarButtonItem = Save;
    NSDate *currentPage = _calendar.currentPage;
    
    pre = 0;
    next = 0;
    selectedSlotId = @"";
    strSlots = @"";
    status = @"0";
    lastStatus = 1;
    if(patientService.slot_id.length > 0 ){
        NSLog(@"UPDATE STATUS VIEW WILL APPEAR BOOK APPOINTMENT");
        [self updateDoctorStatus];
       // patientService.doctor_id = @"";
       patientService.slot_id = @"";
    }
}


//Update Doctor satus
- (void)updateDoctorStatus{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:patientService.doctor_id forKey:kdoctor_id];
    [parameter setObject:patientService.slot_id forKey:ktime_slot_id];
    [parameter setObject:patientService.visit_type_id forKey:kvisit_type_id];
    [parameter setObject:status forKey:@"status"];
    [parameter setObject:[NSNumber numberWithInt:8] forKey:kpayment_mode_id];
    if(patientService.slot_id.length == 0){
    }
    else{
        [service updateStatus:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            
         //   NSLog(@"RESPONSE is %@", responseCode);

            if(error){
                [MBProgressHUD hideHUDForView:self.view animated:NO];

                if([[error valueForKey:@"status"] isEqualToString:@"fail"]){
                   
                    [IODUtils showFCAlertMessage:@"This time slot is not available now"  withTitle:@"" withViewController:self with:@"error"];

                    
                   
                    NSString *currentDate = [IODUtils formatDateForServer:_calendar.today];
                    selectedDate = currentDate;
                    [self getAvailabeleDates : selectedDate];
                    if([patientService.visit_type_id isEqualToString:@"2"]) {
                        [self getSlotForCurrentDate:currentDate];
                    }
                  //  _datesWithEvent = [[NSMutableArray alloc] init];
                  //  _slotsWithBookedEvent = [[NSMutableArray alloc] init];
                    appointmentDate = [IODUtils formatDateAndTimeForServer:_calendar.today];
                    return;
                }
            }
            else{
                if([[responseCode objectForKey:@"status"] isEqualToString:@"success"])
                {
                    NSString *currentDate = [IODUtils formatDateForServer:_calendar.today];
                    selectedDate = currentDate;
                    [self getAvailabeleDates : selectedDate];
                    if([patientService.visit_type_id isEqualToString:@"2"]) {
                        [self getSlotForCurrentDate:currentDate];
                    }
                    //  _datesWithEvent = [[NSMutableArray alloc] init];
                    //  _slotsWithBookedEvent = [[NSMutableArray alloc] init];
                    appointmentDate = [IODUtils formatDateAndTimeForServer:_calendar.today];
                    if(lastStatus == 0){
                        [MBProgressHUD hideHUDForView:self.view animated:NO];
                        [self setPageController];
                }
             }
            }
        }];
    }
}


-(void)getAvailabeleDates :(NSString *)date {
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSString *visitTypeId = [NSString stringWithFormat:@"%@", patientService.visit_type_id];
    [parameter setObject:date forKey:@"date"];
    [parameter setObject:patientService.doctor_id forKey:@"doctor_id"];
    [parameter setObject:patientService.visit_type_id forKey:@"visit_type_id"];

    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service getAllDoctorEventDates:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        if ([[responseCode objectForKey:@"status"] isEqualToString:@"success"]){
            _datesWithEvent = [[responseCode valueForKey:@"data"] valueForKey:@"date"];
        }
        [_calendar reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addcal
{
    // 450 for iPad and 300 for iPhone
    self.calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.calendarContainer.frame.size.height)];
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
    self.calendar.backgroundColor = [UIColor whiteColor];
    self.calendar.appearance.headerMinimumDissolvedAlpha = 0;
    self.calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    [self.calendarContainer addSubview: self.calendar];
    
    self.calendar =  self.calendar;
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(0, 5, 30, 34);
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[self.calendarContainer addSubview:previousButton];
    self.previousButton = previousButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(SCREEN_WIDTH-40, 5, 30, 34);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setImage:[UIImage imageNamed:@"icon_prev"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
   // [self.calendarContainer addSubview:nextButton];
    self.nextButton = nextButton;
    self.calendar.appearance.headerTitleColor = [UIColor blackColor];
    self.calendar.appearance.weekdayTextColor = [UIColor blackColor];
    self.calendar.scrollEnabled = NO;
    self.calendar.pagingEnabled = NO;
}

- (IBAction)previousClicked:(id)sender
{
    if(next >= 1) {
        next = next -1;
        NSDate *currentMonth = self.calendar.currentPage;
        NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
        [self.calendar setCurrentPage:previousMonth animated:YES];
        NSString *newDate = [self.dateFormatter2 stringFromDate:previousMonth] ;
    }
}

- (IBAction)nextClicked:(id)sender
{
    if(next <2)
    {
        next = next +1;
        NSDate *currentMonth = self.calendar.currentPage;
        NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
        [self.calendar setCurrentPage:nextMonth animated:YES];
        NSString *newDate = [self.dateFormatter2 stringFromDate:nextMonth] ;
    }
}


#pragma mark - <FSCalendarDelegateAppearance>
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter2 stringFromDate:date];
    if ([_datesWithEvent containsObject:dateString]) {
        return 1;
    }
    return 0;
}

#pragma mark - <FSCalendarDelegateAppearance>

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter2 stringFromDate:date];
   
    if ([_datesWithEvent containsObject:dateString]) {
        return [UIColor purpleColor];
    }
    return nil;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
{
    
    
    self.dateFormatter2 = [[NSDateFormatter alloc] init];
    self.dateFormatter2.dateFormat = @"yyyy-MM-dd";
    NSString *currentDate = [IODUtils formatDateForServer:_calendar.today];
    
    
    
    NSString *dateString = [self.dateFormatter2 stringFromDate:date];
    if ([_datesWithEvent containsObject:dateString]) {
        if([dateString isEqualToString:currentDate]){
            return [UIColor colorWithHexRGB:@"19bdb3"];
        }
        else{
            return [UIColor lightGrayColor];
        }
    }
    
    return nil;
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
    
    return arrSlots.count;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    // return CGSizeMake(collectionView.frame.size.width/4.1,collectionView.frame.size.height/4.1);
    return CGSizeMake(collectionView.frame.size.width/4.1,40);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIButton *btntitle = [[UIButton alloc] initWithFrame:cell.bounds];
    NSString *title =[[arrSlots objectAtIndex:indexPath.item] valueForKey:@"caption"];
    [btntitle.titleLabel  setTextAlignment: NSTextAlignmentCenter];
    [btntitle setTitle:title forState:UIControlStateNormal];
    [btntitle setBackgroundColor:[UIColor whiteColor]];
    
    [btntitle.layer setBorderWidth:1.0];
    [btntitle.layer setBorderColor:[UIColor colorWithHexRGB:kNavigatinBarColor].CGColor];
    [btntitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btntitle.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
    [btntitle addTarget:self action:@selector(selectSlot:) forControlEvents:UIControlEventTouchUpInside];
    
    [btntitle setTag:indexPath.row];
    if ([[[arrSlotsStatus objectAtIndex:indexPath.row] valueForKey:@"isselected"] isEqualToString:@"YES"]) {
        selectedSlotId = [NSString stringWithFormat:@"%@",[[arrSlots objectAtIndex:indexPath.row] valueForKey:@"id"]];
        [btntitle setBackgroundColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
        [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    else {
        [btntitle setBackgroundColor:[UIColor whiteColor]];
        [btntitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btntitle.layer setBorderWidth:1.0];
        [btntitle.layer setBorderColor:[UIColor colorWithHexRGB:kNavigatinBarColor].CGColor];
    }
    [btntitle.layer setCornerRadius:15.0];
    [cell.contentView addSubview:btntitle];
    cell.backgroundColor = [UIColor clearColor];
    cell.layer.masksToBounds = YES;

    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

#pragma mark -- FSCalendar Delegate methods

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    // self.eventLabel.frame = CGRectMake(0, CGRectGetMaxY(calendar.frame)+10, self.view.frame.size.width, 50);
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    if(date < [NSDate date])
        return NO;
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    NSDate *today = [NSDate date]; // it will give you current date
    NSDate *sDate  = date; // your date
    
    today = [IODUtils toLocalTime:today];
    sDate = [IODUtils toLocalTime:sDate];
    
    NSCalendar *calendar2 = [NSCalendar currentCalendar];
    NSInteger comps = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
    
    NSDateComponents *date1Components = [calendar2 components:comps
                                                     fromDate: today];
    NSDateComponents *date2Components = [calendar2 components:comps
                                                     fromDate: sDate];
    
    today = [calendar2 dateFromComponents:date1Components];
    sDate = [calendar2 dateFromComponents:date2Components];
    
    NSComparisonResult result;
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
    

    //Check for  second opinion
    if([patientService.visit_type_id isEqualToString:@"3"]){
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 5;
        date = [IODUtils toLocalTime:date];
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
        nextDate = [IODUtils toLocalTime:nextDate];
        
        if (([date compare:nextDate] == NSOrderedDescending) || ([date compare:nextDate] == NSOrderedSame) )
        {
            selectedDate = [self.dateFormatter2 stringFromDate:date] ;
            [self getSlotForCurrentDate:selectedDate];
        }
        else {
           // NSString *str = [NSString stringWithFormat:@"Please select %@",selectedDate];
            //[IODUtils showMessage:str withTitle:@""];
        }
    }
    else {
        selectedDate = [self.dateFormatter2 stringFromDate:date] ;
        [self getSlotForCurrentDate:selectedDate];
    }
    
    
    result = [today compare:sDate]; // comparing two dates
    
    if(result==NSOrderedAscending)
        [_businessHourSlots setHidden:NO];
    
    else if(result==NSOrderedDescending)
        [_businessHourSlots setHidden:YES];
    else
        [_businessHourSlots setHidden:NO];
    
    

    
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    if(next == 0) {
    NSString *currentDate = [IODUtils formatDateForServer:_calendar.today];
    [self getSlotForCurrentDate:currentDate];
        [self getAvailabeleDates:currentDate];
    }
    else {
    NSString *newDate = [self.dateFormatter2 stringFromDate:calendar.currentPage] ;
    [self getSlotForCurrentDate:newDate];
    [self getAvailabeleDates:newDate];
    }
}

#pragma API CALLS
//selection of slots

- (void) getSlotForCurrentDate:(NSString *) sDate {
    
    int visitTypeId =  [patientService.visit_type_id intValue];
    patientService.date = [IODUtils formatDateForServer:[IODUtils str2date:sDate]];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDate =[dateFormatter stringFromDate:[NSDate date]];
    [parameter setObject:patientService.doctor_id forKey:@"doctor_id"];
    [parameter setObject:sDate forKey:@"date"];
    [parameter setObject:currentDate forKey:@"current_date"];
    [parameter setObject:[NSNumber numberWithInt:visitTypeId] forKey:@"visit_type_id"];
    arrSlots = [[NSMutableArray alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service getAppointmentSlots:parameter WithCompletionBlock:^(NSArray *array, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        arrSlots = [NSMutableArray arrayWithArray:array];
        if([patientService.visit_type_id isEqualToString:@"2"]){
            [self slotsGreaterThanCurrentDate:arrSlots];
        }
        arrSlotsStatus = [[NSMutableArray alloc] init];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"NO" forKey:@"isƒselected"];
        for(int i =0; i< arrSlots.count; i++) {
            [arrSlotsStatus addObject:dict];
        }
        [_businessHourSlots reloadData];
    }];
}

- (void) slotsGreaterThanCurrentDate: (NSMutableArray *)slotsarray {
    NSMutableArray *dates = [NSMutableArray array];
    NSDate *now = [NSDate date];
    NSDate *startDate = [IODUtils toLocalTime:[now dateByAddingTimeInterval:60*60]] ;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    NSDate *endDate = [calendar dateFromComponents:components];
    endDate = [IODUtils toLocalTime:endDate];
    
    if([startDate timeIntervalSinceDate:endDate]){
        components.day = 1;
        
        endDate = [calendar dateByAddingComponents:components toDate:endDate options:0];
        endDate = [IODUtils toLocalTime:endDate];

    }
    for (id obj in slotsarray) {
        NSDate *dt = [IODUtils formatDateAndTimeForBusinessSlots:[obj valueForKey:@"from_time"]];
        BOOL isDateBetween = [self date:dt isBetweenDate:startDate andDate:endDate];
        if (isDateBetween) {
         [dates  addObject:obj];
        }
    }
    arrSlots = dates;
}



- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
        return YES;
}

- (IBAction)selectSlot:(UIButton *)sender {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if([[[arrSlotsStatus objectAtIndex:sender.tag] valueForKey:@"isselected"] isEqualToString:@"NO"])
        [dict setObject:@"YES" forKey:@"isselected"];
   else
        [dict setObject:@"NO" forKey:@"isselected"];
    int tag = (int)sender.tag;
    for ( int i=0; i < [arrSlotsStatus count]; i++) {
        [[arrSlotsStatus objectAtIndex:i] setObject:@"NO" forKey:@"isselected"];
        if(i == tag)
            [arrSlotsStatus replaceObjectAtIndex:i withObject:dict];
            selectedSlotId = [NSString stringWithFormat:@"%@",[[arrSlots objectAtIndex:i] valueForKey:@"id"]];
        patientService.slot_id = selectedSlotId;
        if([[[arrSlotsStatus objectAtIndex:sender.tag] valueForKey:@"isselected"] isEqualToString:@"NO"])
            selectedSlotId = @"";
    }
    [_businessHourSlots reloadData];
}



-(void)getToken {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Test credit card info
      //  NSDictionary* tokenizer = @{
                                   // @"type":@"FDToken",  // you can change to Amex/Discover/Master Card here
                                   // @"auth":@"true",
                                  //  @"ta_token":@"NOIW"   // to fetch ta_token please refer developer.payeezy
                                   // };
    //LIVE
    NSDictionary* tokenizer = @{
                               @"type":@"FDToken",  // you can change to Amex/Discover/Master Card here
                                @"auth":@"true",
                               @"ta_token":@"NIQE"   // to fetch ta_token please refer developer.payeezy
                            };
    //NIQE
    
    NSDictionary* credit_card = [[NSUserDefaults standardUserDefaults]objectForKey:@"ccdetails"] ;
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:patientService.paymentToken url:KURL];
    [myClient submitPostFDTokenForCreditCard:credit_card[@"type"] cardHolderName:credit_card[@"cardholder_name"] cardNumber:credit_card[@"card_number"] cardExpirymMonthAndYear:credit_card[@"exp_date"] cardCVV:credit_card[@"cvv"] type:tokenizer[@"type"] auth:tokenizer[@"auth"] ta_token:tokenizer[@"ta_token"] completion:^(NSDictionary *dict, NSError *error)
     {
         NSString *authStatusMessage = nil;
         if([[dict valueForKey:@"status"] isEqualToString:@"success"]) {
             NSDictionary *result = [dict objectForKey:@"token"];
             self.fdTokenValue =[result objectForKey:@"value"];
             [[NSUserDefaults standardUserDefaults] setValue:self.fdTokenValue forKey:@"fdtoken"];
             [[NSUserDefaults standardUserDefaults]setObject:credit_card forKey:@"ccdetails"];
             [self creditCardPayment];
         }
         else {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             //NSLog(@"Error.description %@", error.description);
             authStatusMessage = [NSString stringWithFormat:@"%@",[[[error.userInfo valueForKey:@"Error"] valueForKey:@"messages"]valueForKey:@"description"]];
             authStatusMessage = [authStatusMessage stringByReplacingOccurrencesOfString:@"(" withString:@""];
             authStatusMessage = [authStatusMessage stringByReplacingOccurrencesOfString:@")" withString:@""];
             
             if([authStatusMessage containsString:@"GATEWAY:CVV2/CID/CVC2 Data not Verified"]) {
                 authStatusMessage = @"Incorrect CVV / Expiry date. Please re-enter.";
             }
             
             [IODUtils showFCAlertMessage:authStatusMessage  withTitle:@"" withViewController:self with:@"error"];
         }
     }];
}

-(IBAction)btnSubmitPressed:(id)sender {
    
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        patientService.slot_id = selectedSlotId;
        status = @"1";
        lastStatus = 0;
        
        if(selectedSlotId.length > 0) {
            if([patientService.visit_type_id isEqualToString:@"3"]) {
                [self updateDoctorStatus];
            }
            else {
                if([patientService.isFromliveCall isEqualToString:@"yes"])
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    PaymentViewController *pvc =  [self.storyboard instantiateViewControllerWithIdentifier:@"paymentViewController"];
                    [self.navigationController pushViewController:pvc animated:YES];
                }
                else
                {
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self updateDoctorStatus];
                }
            }
        }
        else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [IODUtils showFCAlertMessage:@"Please select time slot"  withTitle:@"" withViewController:self with:@"error"];
        }
}


-(void)setPageController {
  //  SymptomsViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SymptomsViewController"];
    SelectPatientViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectPatientViewController"];
    [self.navigationController pushViewController:svc animated:YES];
}

-(void)creditCardPayment{
    // Test credit card info
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
        NSDictionary* credit_card = [[NSUserDefaults standardUserDefaults]objectForKey:@"ccdetails"] ;
        
        NSString *strtoken = [[NSUserDefaults standardUserDefaults]valueForKey:@"fdtoken"];
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:patientService.paymentToken  url:PURL];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:2];
        [formatter setRoundingMode: NSNumberFormatterRoundUp];
        NSString *numberString = [NSString stringWithFormat:@"%@", patientService.amount];
        float amt = [numberString floatValue];
        int   amount = amt * 100;
        NSString *stramt = [NSString stringWithFormat:@"%df",amount];
        
        //patientService.amount
        [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:strtoken cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:patientService.Currencyid totalAmount:stramt merchantRef:patientService.merchantId   transactionType:@"purchase" token_type:@"FDToken" method:@"token" completion:^(NSDictionary *dict, NSError *error)
         {
             NSString *authStatusMessage = nil;
             if (error == nil)
             {
                 authStatusMessage = [NSString stringWithFormat:@"Transaction Details \rType:%@ \rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@ \rTransaction Status:%@",
                                      [dict objectForKey:@"transaction_type"],
                                      [dict objectForKey:@"transaction_tag"],
                                      [dict objectForKey:@"correlation_id"],
                                      [dict objectForKey:@"bank_resp_code"],
                                      [dict objectForKey:@"transaction_status"] ];
                 
                 patientService.payment_status=@"Authorize";
                 patientService.correlation_id =[dict objectForKey:@"correlation_id"];
                 patientService.transaction_status = [dict objectForKey:@"transaction_status"];
                 patientService.transaction_type =[dict objectForKey:@"transaction_type"];
                 patientService.correlation_id  = [dict objectForKey:@"correlation_id"];
                 patientService.transaction_id = [dict objectForKey:@"transaction_id"];
                 patientService.validation_status = [dict objectForKey:@"validation_status"];
                 patientService.transaction_tag = [dict objectForKey:@"transaction_tag"];
                 patientService.method = [dict objectForKey:@"method"];
                 patientService.amount = patientService.amount;
                 patientService.currency = [dict objectForKey:@"currency"];
                 patientService.bank_resp_code = [dict objectForKey:@"bank_resp_code"];
                 patientService.bank_message = [dict objectForKey:@"bank_message"];
                 patientService.gateway_resp_code = [dict objectForKey:@"gateway_resp_code"];
                 patientService.gateway_message = [dict objectForKey:@"gateway_message"];
                 
                 if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                   //  [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"ccdetails"];
                   //  [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"fdtoken"];
                 }
                 if(![[dict objectForKey:@"bank_message"] isEqualToString:@"Approved"]) {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment fail"
                                                                     message:[dict objectForKey:@"bank_message"] delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                     alert.tag = 0;
                     [alert show];
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                 }
                 else {
                     if([patientService.visit_type_id isEqualToString:@"2"])
                         [self PostDataForApppointment];
                     // [self.navigationController popToRootViewControllerAnimated:YES];
                 }
             }
             else
             {
                 authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
                 if([authStatusMessage containsString:@"GATEWAY:CVV2/CID/CVC2 Data not Verified"]) {
                     authStatusMessage = @"Incorrect CVV / Expiry date. Please re-enter.";
                 }
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                                 message:authStatusMessage delegate:self
                                                       cancelButtonTitle:@"Dismiss"
                                                       otherButtonTitles:nil];
                 [alert show];
                 [MBProgressHUD hideHUDForView:self.view animated:YES];

             }
         }];
    }
    else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }
}


//book an appointment
-(void)PostDataForApppointment{
    NSString *strSymptom = UDGet(@"SelectedSymptoms");

    NSString *numberString = [NSString stringWithFormat:@"%@", patientService.amount];
   // NSLog(@"Result...%@",numberString);//Result 22.37
    float amt = [numberString floatValue];
    int   amount = amt * 100;
    NSString *stramt = [NSString stringWithFormat:@"%d",amount];
    
    int slotid =[patientService.slot_id intValue];
    
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:patientService.doctor_id forKey:kdoctor_id];
    [parameter setObject:[NSNumber numberWithInt:slotid] forKey:ktime_slot_id];
    [parameter setObject:@"" forKey:kappointment_slot_id];

    [parameter setObject:patientService.visit_type_id forKey:kvisit_type_id];
    [parameter setObject:patientService.date forKey:kdate];
    [parameter setObject:patientService.question_1 forKey:kquestion_1];
    [parameter setObject:strSymptom forKey:kquestion_2];
    [parameter setObject:patientService.couponCode forKey:@"coupan"];

    [parameter setObject:patientService.question_1_option_value forKey:kquestion_1_option_value];
    [parameter setObject:patientService.selectedCategoryName forKey:@"category"];
    
    [parameter setObject:patientService.member_name forKey:knew_member_name];
    [parameter setObject:[NSNumber numberWithInt:patientService.member_gender] forKey:knew_member_gender];
    [parameter setObject:patientService.member_dob forKey:knew_member_dob];
    [parameter setObject:patientService.question_3 forKey:kquestion_3];
    [parameter setObject:patientService.question_4 forKey:kquestion_4];
    [parameter setObject:patientService.question_5 forKey:kquestion_5];
    [parameter setObject:patientService.question_6 forKey:kquestion_6];
    [parameter setObject:patientService.question_7 forKey:kquestion_7];
    [parameter setObject:[NSNumber numberWithInt:patientService.payment_mode_id] forKey:kpayment_mode_id];
    [parameter setObject:patientService.payment_status forKey:kpayment_status];
    [parameter setObject:patientService.correlation_id forKey:kcorrelation_id];
    [parameter setObject:patientService.transaction_status forKey:ktransaction_status];
    [parameter setObject:patientService.validation_status forKey:kvalidation_status];
    [parameter setObject:patientService.transaction_type forKey:ktransaction_type];
    [parameter setObject:patientService.transaction_id forKey:ktransaction_id];
    [parameter setObject:patientService.transaction_tag forKey:ktransaction_tag];
    [parameter setObject:patientService.method forKey:kmethod];
    [parameter setObject:[NSString stringWithFormat:@"%@$",patientService.amount] forKey:kamount];
    [parameter setObject:patientService.currency forKey:kcurrency];
    [parameter setObject:patientService.bank_resp_code forKey:kbank_resp_code];
    [parameter setObject:patientService.bank_message forKey:kbank_message];
    [parameter setObject:patientService.gateway_resp_code forKey:kgateway_resp_code];
    [parameter setObject:patientService.gateway_message forKey:kgateway_message];
    
    //mit - NEW (New Method)
    PatientAppointService *service = [[PatientAppointService alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service bookAppointment:parameter andImageName:patientService.documentName andImages:patientService.arrDocumentData dataType:patientService.arrDocType WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //NSLog(@"RESPONSE");
        if(responseCode ) {
      if ([[responseCode objectForKey:@"status"] isEqualToString:@"success"]) {

          patientService.res_order_no = [[responseCode objectForKey:@"data"] valueForKey:@"order_no"];
          patientService.res_date = [[responseCode objectForKey:@"data"] valueForKey:@"date"];
          patientService.res_startTime = [[responseCode objectForKey:@"data"] valueForKey:@"start_time"];
          SuccessfulPaymentViewController *succPayment = [self.storyboard instantiateViewControllerWithIdentifier:@"SuccessfulPaymentViewController"];
          patientService.arrDocumentData = [[NSMutableArray alloc]init];
          patientService.documentName = [[NSMutableArray alloc]init];
          [self.navigationController pushViewController:succPayment animated:YES];
          //[IODUtils showMessage:[responseCode valueForKey:@"message"] withTitle:@""];
         }
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)setSelectedTabIndex:(int)index {
    //NSLog(@"Called");
}

@end
