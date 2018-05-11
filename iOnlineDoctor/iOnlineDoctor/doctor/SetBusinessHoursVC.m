//
//  SetBusinessHoursVC.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/9/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "SetBusinessHoursVC.h"
#import "FSCalendar.h"
#import "CommonServiceHandler.h"
#import "IODUtils.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "UIColor+HexString.h"
#import <AVFoundation/AVFoundation.h>


@interface SetBusinessHoursVC ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance,UITextFieldDelegate>
{
    NSMutableArray *arrSlots,*arrResultSlots;
    NSMutableArray *arrDoctorBusinessSlots;
    int selectdScheduleId;
    BOOL isFromCheckbox;
    NSString *strSlots;
    NSString *selectedDate;
    int next;
    int  pre;
    NSDate *lastSavedDate;
    BOOL isDateslected;
    UIBarButtonItem *Save ;
}

@property (nonatomic,strong) AppDelegate *appDelegate;
@property (retain, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSMutableArray *datesWithEvent;
@property (strong, nonatomic) NSMutableArray *slotsWithBookedEvent;
@property (strong, nonatomic) NSDateFormatter *dateFormatter2;

- (IBAction)previousClicked:(id)sender;
- (IBAction)nextClicked:(id)sender;

@end

@implementation SetBusinessHoursVC


- (void)addcal
{
    // 450 for iPad and 300 for iPhone
    self.calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,self.calendarContainer.frame.size.height)];
     self.calendar.dataSource = self;
     self.calendar.delegate = self;
     self.calendar.backgroundColor = [UIColor whiteColor];
     self.calendar.appearance.headerMinimumDissolvedAlpha = 0;
     self.calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
     self.calendar.locale = [NSLocale currentLocale];
    
    [self.calendarContainer addSubview: self.calendar];
    
    self.calendar =  self.calendar;
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(0, 0, 40, 44);
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
 //   [self.calendarContainer addSubview:previousButton];
    self.previousButton = previousButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(SCREEN_WIDTH-60, 0, 40, 44);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setImage:[UIImage imageNamed:@"icon_prev"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
  //  [self.calendarContainer addSubview:nextButton];
    self.nextButton = nextButton;
    self.calendar.appearance.headerTitleColor = [UIColor blackColor];
    self.calendar.appearance.weekdayTextColor = [UIColor blackColor];
    self.calendar.scrollEnabled = NO;
    self.calendar.pagingEnabled = NO;
}


- (void)previousClicked:(id)sender
{
    if(next >= 1) {
        next = next -1;
        NSDate *currentMonth = lastSavedDate;
        
        NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:lastSavedDate options:0];
        previousMonth = [IODUtils toLocalTime:previousMonth];
        [self.calendar setCurrentPage:previousMonth animated:YES];
        NSString *newDate = [self.dateFormatter2 stringFromDate:previousMonth] ;
        lastSavedDate = previousMonth;
        [self getBusinessHoursSlotsFromDate:newDate];
    }
}

- (IBAction)nextClicked:(id)sender
{
    if(next <2)
    {
        next = next +1;
        NSDate *currentMonth = self.calendar.currentPage;
        currentMonth = [IODUtils toLocalTime:currentMonth];
       NSDate *today = [IODUtils toLocalTime:_calendar.today];
        if(currentMonth <= today) {
            lastSavedDate = today;
        }
        NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:lastSavedDate options:0];
        nextMonth = [IODUtils toLocalTime:nextMonth];
        lastSavedDate = nextMonth;
        
        [self.calendar setCurrentPage:nextMonth animated:YES];
        NSString *newDate = [self.dateFormatter2 stringFromDate:nextMonth] ;
         [self getBusinessHoursSlotsFromDate:newDate];
    }
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.view setNeedsLayout];
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
    [self.navigationController setNavigationBarHidden:FALSE animated:FALSE];
    [super viewDidLoad];
    
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.title = @"Set Business Hours";
    [self addcal];
    self.dateFormatter2 = [[NSDateFormatter alloc] init];
    self.dateFormatter2.dateFormat = @"yyyy-MM-dd";
    [self.businessHoursCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    _calendar.delegate = self;
     NSString *currentDate = [IODUtils formatDateForServer:_calendar.today];
    selectedDate = currentDate;
    
    
    [self getBusinessHoursSlotsFromDate:currentDate];
    [self getSlots];
    _datesWithEvent = [[NSMutableArray alloc] init];
    _slotsWithBookedEvent = [[NSMutableArray alloc] init];
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
    isDateslected = YES;
    // Do any additional setup after loading the view.
    strSlots = [[NSString alloc] init];
    Save = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(btnSubmitPressed:)];
    self.navigationItem.rightBarButtonItem = Save;
    pre = 0;
    next = 0;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        return [UIColor lightGrayColor];
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

/*- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
{
    
    NSString *dateString = [self.dateFormatter2 stringFromDate:date];
    if ([_datesWithEvent containsObject:dateString]) {
        return [UIColor lightGrayColor];
    }
    return nil;
}*/

#pragma mark - Collection view delegates
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
  //  cell.contentView.backgroundColor = [UIColor greenColor];
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
   // [btntitle setTag:indexPath.item];
    [btntitle setBackgroundColor:[UIColor whiteColor]];
    [btntitle.layer setBorderWidth:1.0];
    [btntitle.layer setBorderColor:[UIColor colorWithHexRGB:kNavigatinBarColor].CGColor];
    [btntitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btntitle.titleLabel.font = [UIFont systemFontOfSize:12.0];

    btntitle.tag = indexPath.row+1;
    [btntitle addTarget:self action:@selector(selectCell:) forControlEvents:UIControlEventTouchUpInside];
    if (isFromCheckbox) {
        [btntitle setBackgroundColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
        btntitle.selected = YES;
        [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        for (id object in self.slotsWithBookedEvent) {
            NSString *caption = [object objectForKey:@"caption"];
            if([caption containsString:@":31"]){
                caption = [caption stringByReplacingOccurrencesOfString:@":31" withString:@":30"];
            }
            
            else if([caption containsString:@":29"]){
                caption = [caption stringByReplacingOccurrencesOfString:@":29" withString:@":30"];
            }
            
            else if([caption containsString:@"-00:00"]){
                caption = [caption stringByReplacingOccurrencesOfString:@"-00:00" withString:@"-23:59"];
            }
            else if([caption containsString:@"00:00-"]){
                caption = [caption stringByReplacingOccurrencesOfString:@"00:00-" withString:@"00:01-"];
            }
            
            if([caption isEqualToString:title]) {
                NSString *str = [NSString stringWithFormat:@"%@",[object objectForKey:@"is_booked"]];
                
                if([str isEqualToString: @"1" ]) {
                    [btntitle setUserInteractionEnabled:NO];
                    [btntitle setEnabled:NO];
                    [btntitle setBackgroundColor:[UIColor colorWithHexRGB:@"#727372"]];
                    [btntitle.layer setBorderColor:[UIColor clearColor].CGColor];
                    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    btntitle.tag = -1;
                    
                }
                else{
                    [btntitle setBackgroundColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
                    [btntitle.layer setBorderColor:[UIColor clearColor].CGColor];
                    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btntitle setUserInteractionEnabled:NO];
                    [btntitle setEnabled:NO];
                    btntitle.tag = -1;
                    btntitle.selected = YES;
                }
            }
            else {
                [btntitle setUserInteractionEnabled:YES];
                [btntitle setEnabled:YES];
            }
        }

        
    }
    else {
        for (id object in self.slotsWithBookedEvent) {
            NSString *caption = [object objectForKey:@"caption"];
            if([caption containsString:@":31"]){
                caption = [caption stringByReplacingOccurrencesOfString:@":31" withString:@":30"];
            }
            
            else if([caption containsString:@":29"]){
                caption = [caption stringByReplacingOccurrencesOfString:@":29" withString:@":30"];
            }
            
            else if([caption containsString:@"-00:00"]){
                caption = [caption stringByReplacingOccurrencesOfString:@"-00:00" withString:@"-23:59"];
            }
            else if([caption containsString:@"00:00-"]){
                caption = [caption stringByReplacingOccurrencesOfString:@"00:00-" withString:@"00:01-"];
            }
            
            if([caption isEqualToString:title]) {
                NSString *str = [NSString stringWithFormat:@"%@",[object objectForKey:@"is_booked"]];
                
                if([str isEqualToString: @"1" ]) {
                    [btntitle setUserInteractionEnabled:NO];
                    [btntitle setEnabled:NO];
                    [btntitle setBackgroundColor:[UIColor colorWithHexRGB:@"#727372"]];
                    [btntitle.layer setBorderColor:[UIColor clearColor].CGColor];
                    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    btntitle.tag = -1;
                    
                }
                else{
                   [btntitle setBackgroundColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
                    [btntitle.layer setBorderColor:[UIColor clearColor].CGColor];
                    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btntitle setUserInteractionEnabled:NO];
                    [btntitle setEnabled:NO];
                    btntitle.tag = -1;
                    btntitle.selected = YES;
                }
            }
            else {
                [btntitle setUserInteractionEnabled:YES];
                [btntitle setEnabled:YES];
            }
        }
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

#pragma Mark -- FSCalendar Delegate methods

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    // self.eventLabel.frame = CGRectMake(0, CGRectGetMaxY(calendar.frame)+10, self.view.frame.size.width, 50);
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
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
   // today = [IODUtils toLocalTime:today];
   // sDate = [IODUtils toLocalTime:sDate];
    isDateslected = YES;
    
    NSCalendar *calendar2 = [NSCalendar currentCalendar];
    NSInteger comps = ( NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
    
    NSDateComponents *date1Components = [calendar2 components:comps
                                                    fromDate: today];
    NSDateComponents *date2Components = [calendar2 components:comps
                                                    fromDate: sDate];
    
    NSDate  *td = [calendar2 dateFromComponents:date1Components];
    NSDate  *sD = [calendar2 dateFromComponents:date2Components];
    NSComparisonResult result;
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
    
    result = [td compare:sD]; // comparing two dates
    NSDate *dt = [NSDate date];
    dt = [IODUtils toLocalTime:dt];
    
    isFromCheckbox = NO;
    [_businessHoursCollectionView  setHidden:NO];
    self.slotsWithBookedEvent = [[NSMutableArray alloc] init];
    selectedDate = [IODUtils formatDateForServer:date];
    
    for (id object in arrDoctorBusinessSlots) {
        if([[object objectForKey:@"date"] isEqual:selectedDate])
            [self.slotsWithBookedEvent addObject:object];
    }
    [_businessHoursCollectionView reloadData];
    if(result==NSOrderedAscending){
        arrSlots = arrResultSlots;
        [_businessHoursCollectionView setHidden:NO];
        [_scheduleContainer setHidden:NO];
    }
    else if(result==NSOrderedDescending){
        [_businessHoursCollectionView setHidden:YES];
        [_scheduleContainer setHidden:YES];
    }
    else{
        [_businessHoursCollectionView setHidden:NO];
        [_scheduleContainer setHidden:NO];
        
        [self slotsGreaterThanCurrentDate];
    }
}

//Check for current time slots
- (void)slotsGreaterThanCurrentDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *strCurrentTime = [dateFormatter stringFromDate:[NSDate date]];
    float currenttime = [strCurrentTime floatValue];
    
    NSMutableArray *Arr = [[NSMutableArray alloc] init];
    for(int i = 0; i < arrSlots.count ; i++ ){
        NSString *slot1 = [NSString stringWithFormat:@"%@",[[arrSlots objectAtIndex:i] valueForKey:@"caption"]];
        
        NSString *strSlot = [slot1 substringToIndex:5];
        strSlot = [strSlot stringByReplacingOccurrencesOfString:@":" withString:@"."];
        float slot = [[NSString stringWithFormat:@"%@",strSlot]floatValue];
        if(slot > currenttime){
            [Arr addObject:[arrSlots objectAtIndex:i]];
        }
    }
    arrSlots = [Arr mutableCopy];
    [_businessHoursCollectionView reloadData];
}


- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    isFromCheckbox = NO;
    isDateslected = NO;
    
    [self.checkBox setChecked:NO];
    [_businessHoursCollectionView setHidden:NO];
}

#pragma API CALLS
//Get business slots for particular date
- (void)getBusinessHoursSlotsFromDate:(NSString *) sDate {
    
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach.isReachable;
    if (reachable)
    {
        self.slotsWithBookedEvent = [[NSMutableArray alloc] init];
        [_businessHoursCollectionView reloadData];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentDate =[dateFormatter stringFromDate:[NSDate date]];
        [parameter setObject:sDate forKey:@"date"];
      //  [parameter setObject:currentDate forKey:@"current_date"];
        [service getDoctorBusinessHoursWith:parameter WithCompletionBlock:^(NSArray *array) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            strSlots = @"";
            [_businessHoursCollectionView reloadData];
            if(array.count >0) {
                arrDoctorBusinessSlots = [array  mutableCopy];
                if(arrDoctorBusinessSlots.count > 0)
                    self.datesWithEvent = [arrDoctorBusinessSlots valueForKey:@"date"];
                _datesWithEvent = [_datesWithEvent valueForKeyPath:@"@distinctUnionOfObjects.self"];
                [self getSlotForCurrentDate:sDate];
                [_businessHoursCollectionView reloadData];
                
            }
            [_calendar reloadData];
        }];
    }
    else
    {
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
   }
}

- (void) getSlotForCurrentDate:(NSString *) sDate {
    
    self.slotsWithBookedEvent = [[NSMutableArray alloc] init];
    for (id object in arrDoctorBusinessSlots) {
        
        if([[object objectForKey:@"date"] isEqual:sDate])
            [self.slotsWithBookedEvent addObject:object];
    }
    [_businessHoursCollectionView reloadData];
}

//get time slots for 24 hours.
-(void)getSlots {
    [self getOnlyHourAndMinutes];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service getSlots:nil WithCompletionBlock:^(NSArray *array, NSError *error) {
        NSMutableSet *keys = [NSMutableSet new];
        NSMutableArray *result = [NSMutableArray new];
        for (NSDictionary *data in array) {
            NSString *key = data[@"caption"];
            if ([keys containsObject:key])
                continue;
            [keys addObject:key];
            [result addObject:data];
        }
        arrResultSlots = [NSMutableArray new];
        arrResultSlots = result;
        arrSlots = result;
        
        [self slotsGreaterThanCurrentDate];

        [_businessHoursCollectionView reloadData];
        [_calendar reloadData];
    }];
}

- (void)getOnlyHourAndMinutes{
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                    fromDate:[IODUtils toLocalTime:[NSDate date]]];
    NSDate *startDate = [[NSCalendar currentCalendar]
                         dateFromComponents:components];
    NSLog(@"Start date %@",startDate);
}

#pragma mark - StringPickerViewDelegate
- (void)stringPickerViewDidSelectDone:(StringPickerView *)view
{
    if( [self.pickerView.refernceView isKindOfClass:[UITextField class]] )
    {
        UITextField *textField = (UITextField*)view.refernceView;
        if(textField == _txtSelection){
            textField.text = self.pickerView.value;
            selectdScheduleId = self.pickerView.selectedId+1;
        }
    }
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}

- (void)stringPickerViewDidSelectCancel:(StringPickerView *)view
{
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.txtSelection) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
            NSDictionary *dictgender = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"slotsType" ofType:@"json"]];
            NSArray *gender= [dictgender valueForKey:@"slot"];
            self.pickerView.data = [gender  valueForKey:@"Title"];
            self.pickerView.delegate = self;
            self.pickerView.preSelectedValue = textField.text;
            self.pickerView.refernceView = textField;
            [self.view.window addSubview:self.pickerView];;
            return NO;
        }
        return NO;
    }
      return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}

- (IBAction)selectCell:(UIButton *)sender {
    int tag = (int)sender.tag;
    if(tag < 0 ){
    }
    else if (sender.tag >= 0) {
        if ([sender isSelected]) {
          
            [sender setSelected:NO];
            [sender setBackgroundColor:[UIColor whiteColor]];
            [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if (sender.tag == 1) {
                @try {
                    // sender.tag =0;
                    NSString *strslot = [NSString stringWithFormat:@"%@",[[arrSlots objectAtIndex:0 ] valueForKey:@"id"]];
                    
                    strSlots = [strSlots stringByReplacingOccurrencesOfString:strslot withString:@""];
                } @catch (NSException *exception) {
                   // isFromCheckbox
                }
            }
            else {
                @try {
                    NSString *strslot = [NSString stringWithFormat:@"%@",[[arrSlots objectAtIndex:sender.tag -1 ] valueForKey:@"id"]];
                    
                    strSlots = [strSlots stringByReplacingOccurrencesOfString:strslot withString:@""];
                    
                    strSlots = [strSlots stringByReplacingOccurrencesOfString:strslot withString:@""];
                } @catch (NSException *exception) {
                    NSLog(@"exceptiob %@",exception.description);
                    
                    
                } @finally {
                    
                }
            }
            strSlots = [strSlots stringByReplacingOccurrencesOfString:@",," withString:@","];
        }
        else
        {
            [sender setSelected:YES];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setBackgroundColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
            
            @try {
                strSlots = [NSString stringWithFormat:@"%@,%@",strSlots,[[arrSlots objectAtIndex:sender.tag - 1] valueForKey:@"id"]];
                if ([strSlots hasPrefix:@","]) {
                    strSlots = [strSlots substringFromIndex:1];
                }
            } @catch (NSException *exception) {
                NSLog(@"exceptiob %@",exception.description);
        }
        }
    }
    if ([strSlots hasPrefix:@","] && strSlots.length >1) {
        strSlots = [strSlots substringFromIndex:1];
    }
    
    if ([strSlots hasSuffix:@","] && strSlots.length >1) {
        strSlots = [strSlots substringToIndex:strSlots.length-1];
        
    }
}

-(IBAction)testCheckbox:(id)sender
{
    
    
    strSlots = @"";
    if(_checkBox.checked == YES)
    {
        isFromCheckbox = YES;
        for (id object in arrSlots) {
          //  strSlots = [NSString stringWithFormat:@"%@,%@",strSlots,[object  valueForKey:@"caption"]];
              strSlots = [NSString stringWithFormat:@"%@,%@",strSlots,[object  valueForKey:@"id"]];
        }
        if ([strSlots hasPrefix:@","]) {
            strSlots = [strSlots substringFromIndex:1];
        }
    }
    else {
        isFromCheckbox= NO;
        strSlots = @"";
    }
    //NSLog(@"str slots %@",strSlots);
    [_businessHoursCollectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:FALSE animated:FALSE];
}



-(void)gotoAppSettings{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@""
                                  message:@"You will not be able receive without the requested permissions.Do you wish to change it ?  "
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"app-settings:"]];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //do something when click button
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}

-(void)checkPermissions{
    __block BOOL isCameraAccess = YES;
    __block BOOL isMicrophoneAccess = YES;
    __block BOOL isNotificationAccess = YES;
    __block  BOOL isAllPermissionGranted = YES;
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings){
        
        //1. Query the authorization status of the UNNotificationSettings object
        switch (settings.authorizationStatus) {
            case UNAuthorizationStatusAuthorized:
                isNotificationAccess = YES;
                break;
            case UNAuthorizationStatusDenied:
                isNotificationAccess = NO;
                NSLog(@"Status Denied");
                break;
            case UNAuthorizationStatusNotDetermined:
                isNotificationAccess = NO;
                break;
            default:
                break;
        }
        if( isNotificationAccess == NO){
            [IODUtils showFCAlertMessage:@"Please ensure your notifications are on  in order to receive call" withTitle:@"" withViewController:self with:@"error" ];
        }
    }];
}


-(IBAction)btnSubmitPressed:(id)sender {
    if(isDateslected == YES){
        int  selectedOption;
        if (_txtSelection.text.length ==0 ) {
            selectedOption = 0;
        }
        else {
            selectedOption =  selectdScheduleId;
        }
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        [parameter setObject:strSlots forKey:@"slot_name"];
        [parameter setObject:[NSNumber numberWithInt:selectedOption]  forKey:@"schedule_option"];
        [parameter setObject:selectedDate forKey:@"date"];
        CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      
        [self checkPermissions];
        
        [service postDoctorBusinessHours:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]) {
                 [IODUtils showFCAlertMessage:@"Successfully saved" withTitle:@"" withViewController:self with:@"success" ];
                [self getBusinessHoursSlotsFromDate:selectedDate];
                _checkBox.checked = NO;
            }
        }];

    }
    else {
        [IODUtils showFCAlertMessage:@"Please select date first" withTitle:@"" withViewController:self with:@"error" ];
    }
}

-(void)refreshView:(NSNotification*)notification{
    NSString *currentDate = [IODUtils formatDateForServer:_calendar.today];
    [self getBusinessHoursSlotsFromDate:currentDate];
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}


@end
