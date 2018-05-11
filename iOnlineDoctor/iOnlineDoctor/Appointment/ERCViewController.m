//
//  labReportViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/17/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "ERCViewController.h"
#import "CommonServiceHandler.h"
#import "IODUtils.h"
#import "DoctorAppointmentServiceHandler.h"
#import "DocCellXib.h"
#import "PrescriptionXIBCell.h"
#import "StringPickerView.h"
#import "IODUtils.h"
#import "DoctorAppointmentServiceHandler.h"
#import "IODUtils.h"
#import "erxViewTableViewCell.h"
#import "UIColor+HexString.h"
#import "UIImageView+WebCache.h"
#import "TabVC.h"
#import "TabbarCategoryViewController.h"
#import "HeaderTableViewCell.h"

@interface ERCViewController ()< UITextFieldDelegate, StringPickerViewDelegate>
{
    DoctorAppointmentServiceHandler *docService;
    UIDatePicker *datePicker;
    int selectedGenderId;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l;
@end

@implementation ERCViewController

{
    NSInteger RowsPrescribeAdded;
    NSMutableArray *arrPrescription;
    NSMutableArray *arrDirection;
    NSMutableArray *arrHideCells;
    
    NSMutableArray *arrGetPrescription;
    NSMutableArray *arrGetDirection;
    
}

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    //  _viewAddPrescribtion.hidden=YES;
    //RowsPrescribeAdded=0;
    docService = [DoctorAppointmentServiceHandler sharedManager];
    // _viewLab.hidden=YES;
    RowsPrescribeAdded=0;
    if([docService.status isEqualToString:@"Pending"])
    {
        [self.view.subviews setValue:@YES forKeyPath:@"hidden"];
        UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(30,self.view.center.y, 260, 30)];
        [self.view addSubview:lblMessage];
        lblMessage.text = @"You can prescribe after call";
        [_topBar setHidden:NO];
        lblMessage.center = self.view.center;
        lblMessage.textAlignment = NSTextAlignmentCenter;
        lblMessage.font = [UIFont boldSystemFontOfSize:16];
        lblMessage.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
    }
    
    UINib *nib = [UINib nibWithNibName:@"ERXtableviewcell" bundle:[NSBundle mainBundle]];
    [[self tblReport] registerNib:nib forCellReuseIdentifier:@"erxViewTableViewCell"];
    
    UINib *nib1 = [UINib nibWithNibName:@"HeaderTableViewCell" bundle:[NSBundle mainBundle]];
    [[self tblReport] registerNib:nib1 forCellReuseIdentifier:@"headerCell"];
    
    arrPrescription = [[NSMutableArray alloc] init];
    arrDirection = [[NSMutableArray alloc] init];
    
    arrGetDirection = [[NSMutableArray alloc] init];
    arrGetPrescription = [[NSMutableArray alloc] init];

    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSString *currentDate;
    currentDate=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    currentDate = [IODUtils ChangeDateFormat:currentDate];
    
    
    _lblDate.text = currentDate;
    _txtDate.text = currentDate;
    _txtMeds.text = @"";
    _txtStength.text = @"";
    _txtQuantity.text = @"";
    _txtDosage.text=@"";
    _txtDirection.text = @"";
    _txtRefill.text = @"";
    _txtAdditionalNotes.text = @"";
    
    NSDictionary *userDict = UDGet(@"SelectedUser");
    // NSLog(@"User details:%@",userDict);
    
    NSString *color = [IODUtils setStatusColor :docService.status];
    [_btnStatus setBackgroundColor:[UIColor colorWithHexRGB:color]];
    [_btnStatus setTitle:docService.status forState:UIControlStateNormal];
    
    if([docService.callEnd isEqualToString:@"yes"])
    {
        _lblUserName.text = [NSString stringWithFormat:@"%@",docService.patient_name];
        _lblUserAge.text = @"";
        _lblUserGender.text = [NSString stringWithFormat:@"%@",docService.patient_gender];
        if([_lblUserGender.text isEqualToString:@"<null>"] || [_lblUserGender.text isEqualToString:@"2"]){
            _lblUserGender.text = @"";
        }
        _lblDocName.text = UDGet(@"uname");;
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
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[userDict valueForKey:@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"P-calling-icon.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    [_imgView.layer setCornerRadius:_imgView.frame.size.width/2];
    _imgView.clipsToBounds = YES;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [_prescriptionListView setHidden:YES];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
   
    arrPrescription = [[NSMutableArray alloc] init];
    arrDirection = [[NSMutableArray alloc] init];
    
    arrGetDirection = [[NSMutableArray alloc] init];
    arrGetPrescription = [[NSMutableArray alloc] init];

    BOOL reachable = reach. isReachable;
    if (reachable) {
        
        [self getAllPrescriptions];
    }else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
    
    if (docService.isFromVideo == 1) {
        self.viewheight.constant = 0;
        self.buttonHeight.constant= 0;
        self.addButtonHeight.constant= 0;
        
        [self.view updateConstraints];
        
        [_tblReport setHidden:YES];
        
        [self.view.subviews setValue:@YES forKeyPath:@"hidden"];
        UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(30,self.view.center.y, 260, 30)];
        [self.view addSubview:lblMessage];
        lblMessage.text = @"You can prescribe after call";
        [_topBar setHidden:NO];
        lblMessage.center = self.view.center;
        lblMessage.textAlignment = NSTextAlignmentCenter;
        lblMessage.font = [UIFont boldSystemFontOfSize:16];
        lblMessage.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
        
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
    else{
        if (![docService.status isEqualToString:@"Call interrupted"] && [docService.callEnd isEqualToString:@"no"] ) {
            
            
            if( ![docService.status isEqualToString:@"Successful"] && [docService.isFilled isEqualToString:@"0"]){
                self.viewheight.constant = 0;
                self.buttonHeight.constant= 0;
                self.addButtonHeight.constant= 0;
                
            }
        }
        
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.txtDirection) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
            NSDictionary *dictgender = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"direction" ofType:@"json"]];
            NSArray *gender= [[dictgender valueForKey:@"direction"] valueForKey:@"Title"];
            self.pickerView.data = gender;
            self.pickerView.delegate = self;
            self.pickerView.preSelectedValue = textField.text;
            self.pickerView.refernceView = textField;
            [self.view.window addSubview:self.pickerView];;
            return NO;
        }
        return NO;
    }
    if (textField == self.txtUsage) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
            NSDictionary *dictgender = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"dosage" ofType:@"json"]];
            NSArray *gender= [[dictgender valueForKey:@"dosage"] valueForKey:@"Title"];
            self.pickerView.data = gender;
            self.pickerView.delegate = self;
            self.pickerView.preSelectedValue = textField.text;
            self.pickerView.refernceView = textField;
            [self.view.window addSubview:self.pickerView];;
            return NO;
        }
        return NO;
    }
    else if (textField == self.txtDate){
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
        CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
        NSDate *date =[NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:-110];
        NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
        [comps setYear:-110];
        _datePickerView = [[UIView alloc] initWithFrame:pickerFrame];
        //time interval in seconds
        CGSize buttonSize = CGSizeMake(SCREEN_WIDTH/2, 44);
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame = CGRectMake(0, 0, buttonSize.width, 50);
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(onDoneButton)
             forControlEvents:UIControlEventTouchUpInside];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(CGRectGetMaxX(doneButton.frame), 0, buttonSize.width, 50);
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(onCancelButton)
               forControlEvents:UIControlEventTouchUpInside];
        doneButton.titleLabel.textColor = cancelButton.titleLabel.textColor = [UIColor whiteColor];
        [doneButton setBackgroundColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
        [cancelButton setBackgroundColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
        
        
        [_datePickerView addSubview:doneButton];
        [_datePickerView addSubview:cancelButton];
        datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 250)];
        [datePicker setMaximumDate:date];
        [datePicker setMinimumDate:minDate];
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.datePickerMode=UIDatePickerModeDate;
        [_datePickerView addSubview:datePicker];
        [textField setInputView:_datePickerView];
    }
    return YES;
}

#pragma mark - Date Picker
-(void)onDoneButton
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY"];
    self.txtDate.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.txtDate resignFirstResponder];
}

-(void)onCancelButton {
    [self.txtDate resignFirstResponder];
    [_datePickerView removeFromSuperview];
}

#pragma mark - StringPickerViewDelegate
- (void)stringPickerViewDidSelectDone:(StringPickerView *)view
{
    if( [self.pickerView.refernceView isKindOfClass:[UITextField class]] )
    {
        UITextField *textField = (UITextField*)view.refernceView;
        if(textField == _txtUsage){
            textField.text = self.pickerView.value;
        }
        else if (textField == _txtDirection){
            textField.text = self.pickerView.value;
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark container Delegate
-(void)CancelSontainer{
    
}


-(void)addNewPrecription:(NSDictionary *)dataDictValues{
  [arrPrescription addObject:dataDictValues];
    
    [self addPrecription:dataDictValues];
 // [arrGetPrescription addObject:dataDictValues];
}


-(void)addPrecription:(NSDictionary *)dataDictValues{
  //  NSLog(@"Prescription %@",dataDictValues);
    
    [arrGetPrescription addObject:dataDictValues];
    [arrGetDirection addObject:[dataDictValues valueForKey:@"direction"]];
    [_btnBadge setTitle:[NSString stringWithFormat:@"%ld",arrGetDirection.count] forState:UIControlStateNormal];
    
    arrHideCells = [[NSMutableArray alloc] init];
    for(int i = 0 ;i < arrGetPrescription.count *2 ; i++) {
        
        NSString *strISSelected;
        if(i%2){
            strISSelected = @"YES";
        }
        else{
            strISSelected = @"YES";
        }
        [arrHideCells addObject:strISSelected];
    }
}


#pragma mark tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row %2){
        if([[arrHideCells objectAtIndex:indexPath.row] isEqualToString:@"YES"]){
            return 0;
        }
        else{
        }
        return 437;
    }
    else{
        
        return 40;
    }
    return 100;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        [arrGetPrescription removeObjectAtIndex:indexPath.row -1];
        [arrGetDirection removeObjectAtIndex:indexPath.row -1] ;
        
        [tableView reloadData];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrGetPrescription.count*2;
}

-(void)cancelClicked:(UIButton *)sender{
    
    UIButton *btnP=(UIButton *)sender;
    //NSLog(@"%ld",(long)btnP.tag);
    [arrPrescription removeObjectAtIndex:btnP.tag];
    //   [_tblReport reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger i = (indexPath.row )/ 2;
    
    
    if ((indexPath.row % 2))
    {
        
        NSInteger i = (indexPath.row )/ 2;
        erxViewTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"erxViewTableViewCell" forIndexPath:indexPath];
        cell.lblDate.text=[[arrGetPrescription objectAtIndex:i]valueForKey:@"date"];
        cell.lblStr.text=[[arrGetPrescription objectAtIndex:i]valueForKey:@"strength"];
        cell.lblMeds.text=[[arrGetPrescription objectAtIndex:i]valueForKey:@"medication"];
        cell.lblDirect.text= [arrGetDirection objectAtIndex:i];
        cell.lblDosage.text=[[arrGetPrescription objectAtIndex:i]valueForKey:@"dosage"];
        NSString *StrRefill =[NSString stringWithFormat:@"%@",[[arrGetPrescription objectAtIndex:i]valueForKey:@"refill"]];
        
        if([StrRefill isEqualToString:@"(null)"]) {
            StrRefill  = @"";
        }
        cell.lblRefill.text=StrRefill;
        
        
        cell.lblQuantity.text = [NSString stringWithFormat:@"%@",[[arrGetPrescription objectAtIndex:i]valueForKey:@"quantity"]];
        
        cell.lblAdditional.text=[[arrGetPrescription objectAtIndex:i]valueForKey:@"additional_notes"];
        return cell;
    }
    else
    {
        NSString *CellIdentifier = @"headerCell";
        HeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.lblTitle.text  = [NSString stringWithFormat:@"Medicine %ld",(long)i+1];
        cell.imgLogo.image = [UIImage imageNamed:@"prescription"];
        
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.row % 2)){
        
    }
    else{
        if([[arrHideCells objectAtIndex:indexPath.row +1] isEqualToString:@"NO"])
            [arrHideCells replaceObjectAtIndex: indexPath.row +1  withObject:@"YES"];
        else
            [arrHideCells replaceObjectAtIndex: indexPath.row +1  withObject:@"NO"];
    }
    [_tblReport reloadData];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField==_txtRefill)
    {
        const char *_char = [string cStringUsingEncoding:NSUTF8StringEncoding];
        int isBackSpace = strcmp(_char, "\b");
        if (isBackSpace == -8) {
            return YES;
        }
        // If it's not a backspace, allow it if we're still under 30 chars.
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 10) ? NO : YES;
    }
   else  if(textField==_txtStength)
    {
        const char *_char = [string cStringUsingEncoding:NSUTF8StringEncoding];
        int isBackSpace = strcmp(_char, "\b");
        if (isBackSpace == -8) {
            return YES;
        }
        // If it's not a backspace, allow it if we're still under 30 chars.
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 10) ? NO : YES;
    }
    return YES;
}


- (IBAction)addPrescribAction:(id)sender {
    //VALIDATIONS
    if (arrPrescription.count==7) {
        return;
    }
    else {
        if (![IODUtils getError:self.txtMeds minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:NO canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]) {
        }
        
        else {
            [self addNewPrecription:@{@"date":_txtDate.text, @"medication":self.txtMeds.text,@"strength":self.txtStength.text,@"quantity":self.txtQuantity.text, @"dosage_id":_txtDosage.text,@"direction_id":self.txtDirection.text,@"refill":self.txtRefill.text,@"additional_notes":_txtAdditionalNotes.text,@"dosage":_txtDosage.text,@"direction":_txtDirection.text}];
            _txtMeds.text = @"";
            _txtStength.text = @"";
            _txtQuantity.text = @"";
            _txtDosage.text=@"";
            _txtDirection.text = @"";
            _txtRefill.text = @"";
            _txtAdditionalNotes.text = @"";
            RowsPrescribeAdded=RowsPrescribeAdded+1;
            [_tblReport reloadData];
        }
    }
}

- (IBAction)btnSubmitAction:(id)sender {
    
    if(_txtMeds.text.length > 0){
        [self addNewPrecription:@{@"date":_txtDate.text, @"medication":self.txtMeds.text,@"strength":self.txtStength.text,@"quantity":self.txtQuantity.text, @"dosage_id":_txtDosage.text,@"direction_id":self.txtDirection.text,@"refill":self.txtRefill.text,@"additional_notes":_txtAdditionalNotes.text,@"dosage":_txtDosage.text,@"direction":_txtDirection.text}];
        
        
       /* [self addPrecription:@{@"date":_txtDate.text, @"medication":self.txtMeds.text,@"strength":self.txtStength.text,@"quantity":self.txtQuantity.text, @"dosage_id":_txtDosage.text,@"direction_id":self.txtDirection.text,@"refill":self.txtRefill.text,@"additional_notes":_txtAdditionalNotes.text,@"dosage":_txtDosage.text,@"direction":_txtDirection.text}]; */
        
        _txtMeds.text = @"";
        _txtStength.text = @"";
        _txtQuantity.text = @"";
        _txtDosage.text=@"";
        _txtDirection.text = @"";
        _txtRefill.text = @"";
        _txtAdditionalNotes.text = @"";
        RowsPrescribeAdded=RowsPrescribeAdded+1;
        [_tblReport reloadData];
    }
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    
    for(int i = 0 ; i < arrPrescription.count; i++ ) {
        NSString *strDirection = [[arrPrescription objectAtIndex:i]valueForKey:@"direction_id"];
        if([strDirection isEqualToString:@"30 Minutes After Meals"]){
            strDirection = @"1";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i] mutableCopy];
            [d setObject :strDirection forKey:@"direction_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];
        }
        else if([strDirection isEqualToString:@"30 Minutes Before Meals"]){
            strDirection = @"2";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i] mutableCopy];
            [d setObject :strDirection forKey:@"direction_id"];
            [arrPrescription setObject: d atIndexedSubscript: i] ;
        }
        else if([strDirection isEqualToString:@"After Meals"]){
            strDirection = @"3";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i] mutableCopy];
            [d setObject :strDirection forKey:@"direction_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];
        }
        else if([strDirection isEqualToString:@"Before Meals"]){
            strDirection = @"4";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i] mutableCopy];
            [d setObject :strDirection forKey:@"direction_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];        }
        else if([strDirection isEqualToString:@"With Meals"]){
            strDirection = @"5";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i] mutableCopy];
            [d setObject :strDirection forKey:@"direction_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];        }
        else if([strDirection isEqualToString:@"With Plenty of Water"]){
            strDirection = @"6";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i] mutableCopy];
            [d setObject :strDirection forKey:@"direction_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];        }
    }
    
    for(int i = 0 ; i < arrPrescription.count; i++ ) {
        NSString *strDirection = [[arrPrescription objectAtIndex:i]valueForKey:@"dosage_id"];
        if([strDirection isEqualToString:@"2 Times A Day"]){
            strDirection = @"1";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i]mutableCopy];
            [d setObject :strDirection forKey:@"dosage_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];
        }
        else if([strDirection isEqualToString:@"3 Times A Day"]){
            strDirection = @"2";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i]mutableCopy];
            [d setObject :strDirection forKey:@"dosage_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];
        }
        else if([strDirection isEqualToString:@"4 Times A Day"]){
            strDirection = @"3";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i]mutableCopy];
            [d setObject :strDirection forKey:@"dosage_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];
        }
        else if([strDirection isEqualToString:@"After Meals"]){
            strDirection = @"4";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i]mutableCopy];
            [d setObject :strDirection forKey:@"dosage_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];
        }
        else if([strDirection isEqualToString:@"As Needed"]){
            strDirection = @"5";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i]mutableCopy];
            [d setObject :strDirection forKey:@"dosage_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];
        }
        else if([strDirection isEqualToString:@"At Bedtime"]){
            strDirection = @"6";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i]mutableCopy];
            [d setObject :strDirection forKey:@"dosage_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];
        }
        else if([strDirection isEqualToString:@"Before Meals"]){
            strDirection = @"7";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i]mutableCopy];
            [d setObject :strDirection forKey:@"dosage_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];
        }
        else if([strDirection isEqualToString:@"Every 2 Hours"]){
            strDirection = @"8";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i]mutableCopy];
            [d setObject :strDirection forKey:@"dosage_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];
        }
        
        else if([strDirection isEqualToString:@"Every Day"]){
            strDirection = @"9";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i]mutableCopy];
            [d setObject :strDirection forKey:@"dosage_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];
        }
        else if([strDirection isEqualToString:@"Every Hour"]){
            strDirection = @"10";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i]mutableCopy];
            [d setObject :strDirection forKey:@"dosage_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];
        }
        else if([strDirection isEqualToString:@"Once A Day"]){
            strDirection = @"11";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i]mutableCopy];
            [d setObject :strDirection forKey:@"dosage_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];
        }
        else if([strDirection isEqualToString:@"Once A Week"]){
            strDirection = @"12";
            NSMutableDictionary *d = [[arrPrescription objectAtIndex:i]mutableCopy];
            [d setObject :strDirection forKey:@"dosage_id"];
            [arrPrescription setObject: d atIndexedSubscript: i];
        }
    }
    
    for(int i = 0 ; i < arrPrescription.count; i++ ) {
        NSMutableDictionary *d = [[arrPrescription objectAtIndex:i] mutableCopy];
        NSString *atrDate = [[arrPrescription objectAtIndex:i] objectForKey:@"date"];
        if(atrDate == nil){
            atrDate = _txtDate.text;
        }
        atrDate = [self ChangeDateFormat:atrDate];
        
        if(atrDate == nil){
            atrDate = [[arrPrescription objectAtIndex:i] valueForKey:@"date"];
        }
        [d setObject :atrDate forKey:@"date"];
        [arrPrescription setObject: d atIndexedSubscript: i];
    }
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:arrPrescription options:kNilOptions error:&error];
    NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [parameter setObject:dataString forKey:@"data"];
    
    if(arrPrescription.count > 0){
        CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service postPrescription:parameter WithVisitId:docService.visit_id WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            if ([[responseCode valueForKey:@"status"] isEqualToString:@"success"]) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Do you wish to continue to Prescribe, Lab work or sick leave note?"message:@"" preferredStyle:UIAlertControllerStyleAlert];
                //We add buttons to the alert controller by creating UIAlertActions:
                UIAlertAction *yesPressed = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //NSLog(@"sdssdasdasdad");
                    UITabBarController *tabBarController = (TabbarCategoryViewController *)self.parentViewController;
                    NSMutableArray *viewControllersCopy = [[tabBarController viewControllers] mutableCopy];
                    [tabBarController setSelectedIndex:3];
                }];
                
                UIAlertAction *noPressed = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                [alertController addAction:noPressed];
                [alertController addAction:yesPressed];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];}
    else{
        [IODUtils showFCAlertMessage:@"Please add Medicine" withTitle:@"" withViewController:self with:@"error"];
    }
}


- (NSString *) ChangeDateFormat : (NSString *) toDate
{
    NSString *toDateCheck;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *date = [dateFormatter dateFromString: toDate]; // here you can fetch date from string with define format
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];// here set format which you want...
    
    toDateCheck = [dateFormatter stringFromDate:date]; //here convert date in NSString
    return toDateCheck;
}

-(void)getAllPrescriptions {
    

    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:docService.visit_id forKey:@"visitId"];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
    //    [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
        [service getPrescription:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
            if([[responseCode objectForKey:@"status"] isEqualToString:@"success"]) {
                //NSLog(@"Response code %@", responseCode);
                NSMutableArray *Prescription = [responseCode objectForKey:@"data"];
                
                for(int i = 0 ; i< Prescription.count ;i ++){
                    
                    NSString *medication = [[Prescription objectAtIndex:i] valueForKey:@"medication"];
                    NSString *strength = [[Prescription objectAtIndex:i] valueForKey:@"strength"];
                    NSString *quantity = [[Prescription objectAtIndex:i] valueForKey:@"quantity"];
                   NSString *dosage_id = [NSString stringWithFormat:@"%@",[[Prescription objectAtIndex:i] valueForKey:@"dosage_id"]];
                    
                    NSString *direction_id = [NSString stringWithFormat:@"%@",[[Prescription objectAtIndex:i] valueForKey:@"direction_id"]];
                    
                    NSString *additional_notes = [[Prescription objectAtIndex:i] valueForKey:@"additional_notes"];
                    NSString *dosage = [NSString stringWithFormat:@"%@",[[Prescription objectAtIndex:i] valueForKey:@"dosage"]];
                    
                    NSString *direction =[NSString stringWithFormat:@"%@", [[Prescription objectAtIndex:i] valueForKey:@"direction"]];
                    
                    NSString *StrRefill = @"";
                    
                    [self addPrecription:@{@"medication":medication,@"strength":strength,@"quantity":quantity, @"dosage_id":dosage_id,@"direction_id":direction_id,@"additional_notes":additional_notes,@"dosage":dosage,@"refill":StrRefill,@"direction":direction}];
                }
            }
            
            [_tblReport reloadData];
        }];
        
    }else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}


- (IBAction)btnAdd:(id)sender {
    
}

- (IBAction)btnCancelPrescribe:(id)sender {
    
}

-(IBAction)showList:(id)sender{
    [_prescriptionListView setHidden:NO];
}

-(IBAction)hideListView:(id)sender{
    [_prescriptionListView setHidden:YES];
    
}

@end
