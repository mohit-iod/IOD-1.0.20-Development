//
//  labViewControllerDoc.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/24/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "labViewControllerDoc.h"
#import "DoctorAppointmentServiceHandler.h"
#import "DocCellXib.h"
#import "PrescriptionXIBCell.h"
#import "CommonServiceHandler.h"
#import "IODUtils.h"
#import "labXibTableCell.h"
#import "UIColor+HexString.h"
#import "UIImageView+WebCache.h"
#import "TabbarCategoryViewController.h"
#import "HeaderTableViewCell.h"


@interface labViewControllerDoc () <StringPickerViewDelegate>
{
    UIDatePicker *datePicker;
    NSArray *arrDirection;
    NSMutableArray *arrDir;
    NSMutableArray *arrHideCells;

    NSMutableArray *arrNewDirection;
    NSMutableArray *arrNewDir;
    
    int selectedDirectionId;
}

@end

@implementation labViewControllerDoc
{
    DoctorAppointmentServiceHandler *docService;
    NSInteger RowsPrescribeAdded;
    NSMutableArray *arrLab;
    NSMutableArray *arrNewLab;
}
-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    //  _viewAddPrescribtion.hidden=YES;
    //RowsPrescribeAdded=0;
    docService = [DoctorAppointmentServiceHandler sharedManager];
    _viewLab.hidden=YES;
    RowsPrescribeAdded=0;
    self.tblLab.allowsMultipleSelectionDuringEditing = NO;
    UINib *nib = [UINib nibWithNibName:@"labXibTableCell" bundle:[NSBundle mainBundle]];
    arrLab = [[NSMutableArray alloc] init];
    arrNewLab = [[NSMutableArray alloc] init];
    
    [[self tblLab] registerNib:nib forCellReuseIdentifier:@"labXibTableCell"];
    
    
    UINib *nib1 = [UINib nibWithNibName:@"HeaderTableViewCell" bundle:[NSBundle mainBundle]];
    [[self tblLab] registerNib:nib1 forCellReuseIdentifier:@"headerCell"];

    arrDir= [[NSMutableArray alloc] init];
    arrNewDir = [[NSMutableArray alloc] init];
    
    
    NSString *currentDate;
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    currentDate=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    currentDate = [IODUtils ChangeDateFormat:currentDate];
    _lblDate.text = currentDate;
     _txtDate.text = currentDate;
  
    _txttest.text = @"";
    _txtDirection.text = @"";
    _txtvAdditionalNotes.text = @"";
    
    if([docService.status isEqualToString:@"Pending"])
    {
        [self.view.subviews setValue:@YES forKeyPath:@"hidden"];
        UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(30,self.view.center.y, 260, 30)];
        [self.view addSubview:lblMessage];
        lblMessage.text = @"You can suggest reports after call";
        lblMessage.center = self.view.center;
        [_topBar setHidden:NO];
        
        lblMessage.textAlignment = NSTextAlignmentCenter;
        lblMessage.font = [UIFont boldSystemFontOfSize:16];
        lblMessage.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
    }
    [self setTopBarData];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [_labListView setHidden:YES];

    
    arrLab = [[NSMutableArray alloc] init];
    arrNewLab = [[NSMutableArray alloc] init];
    arrDir= [[NSMutableArray alloc] init];
    arrNewDir = [[NSMutableArray alloc] init];

    
    docService = [DoctorAppointmentServiceHandler sharedManager];
    if (docService.isFromVideo == 1) {
        self.viewHeight.constant = 0;
        self.buttonHeight.constant= 0;
        [self.view updateConstraints];
        
        [self.view.subviews setValue:@YES forKeyPath:@"hidden"];
        UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(30,self.view.center.y, 260, 30)];
        [self.view addSubview:lblMessage];
        lblMessage.text = @"You can suggest reports after call";
        lblMessage.center = self.view.center;
        [_topBar setHidden:NO];
        
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
                self.viewHeight.constant = 0;
                self.buttonHeight.constant= 0;
            }
        }
    }
    
    [self getAllLAB];
}

-(void)setTopBarData {
    
    /*
     NSDictionary *userDict = UDGet(@"SelectedUser");
     NSLog(@"User details:%@",userDict);
     _lblUserName.text = [NSString stringWithFormat:@"%@",[userDict valueForKey:@"patient_name"]];
     _lblUserAge.text = [NSString stringWithFormat:@"%li",(long)[IODUtils calculateAge:[userDict valueForKey:@"dob"]]];
     _lblUserGender.text = [NSString stringWithFormat:@"%@",[userDict valueForKey:@"gender"]];
     
     NSString *color = [IODUtils setStatusColor :docService.status];
     [_btnStatus setBackgroundColor:[UIColor colorWithHexRGB:color]];
     [_btnStatus setTitle:docService.status forState:UIControlStateNormal];
     
     _lblDocName.text = docService.doctorName;
     _lblDocGender.text = docService.doctorGender;
     _lblDoctSpecialise.text = docService.doctorSpecialization;
     CGFloat radius = _imgView.bounds.size.width / 2;
     [_imgView.layer setCornerRadius:radius];
     _imgView.clipsToBounds = YES;
     
     [_imgView sd_setImageWithURL:[NSURL URLWithString:[userDict valueForKey:@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"user-placeholder.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
     
     }];
     */
    NSDictionary *userDict = UDGet(@"SelectedUser");
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
    
    
    NSString *color = [IODUtils setStatusColor :docService.status];
    [_btnStatus setBackgroundColor:[UIColor colorWithHexRGB:color]];
    [_btnStatus setTitle:docService.status forState:UIControlStateNormal];

  
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[userDict valueForKey:@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"P-calling-icon.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    CGFloat radius = _imgView.bounds.size.width / 2;
    [_imgView.layer setCornerRadius:radius];
    _imgView.clipsToBounds = YES;
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark container Delegate


-(void)addLabReport:(NSDictionary *)dataDictValues{
    
}


#pragma mark tableview Delegate




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [arrLab removeObjectAtIndex:indexPath.row -1];
        [arrDir removeObjectAtIndex:indexPath.row -1 ];

        [self.tblLab reloadData];
        // [self.tblLab deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 6;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrLab.count*2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger i = (indexPath.row )/ 2;
    if ((indexPath.row % 2))
    {
        
        NSInteger i = (indexPath.row )/ 2;
        
        labXibTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"labXibTableCell" forIndexPath:indexPath];
        
        cell.lblDate.text=[[arrLab objectAtIndex:i] valueForKey:@"date"];
        cell.lblDirection.text=[arrDir objectAtIndex:i];
        cell.lblTest.text=[[arrLab objectAtIndex:i] valueForKey:@"test"];
        cell.txtAdiitonalNotes.text=[[arrLab objectAtIndex:i] valueForKey:@"additional_notes"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        NSString *CellIdentifier = @"headerCell";
        HeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.lblTitle.text  = [NSString stringWithFormat:@"Lab %ld",(long)i+1];
        cell.imgLogo.image =[UIImage imageNamed:@"lab-logo.png"];
        
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
    [_tblLab reloadData];
    
}

-(void)cancelClicked:(UIButton *)sender{
    
    UIButton *btnP=(UIButton *)sender;
    //NSLog(@"%ld",(long)btnP.tag);
    [arrLab removeObjectAtIndex:btnP.tag];
    // [_tblLab reloadData];
}

- (IBAction)addPrescribAction:(id)sender {
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strLabDate =_txtDate.text;
    //validations
    //    if ((_txtDirection.text.length == 0)) {
    //        [self addLab:@{@"date":strLabDate,@"test":self.txttest.text,@"additional_notes":self.txtvAdditionalNotes.text}];
    //    }
    //    else {
    
    if (![IODUtils getError:self.txttest minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:YES canBeEmpty:NO checkEmail:NO minAge:nil maxAge:nil canBeSameDate:nil ]) {
    }
    else{
     [self addNewLab:@{@"date":self.txtDate.text,@"test":self.txttest.text,@"direction_id":[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:selectedDirectionId] ], @"additional_notes":self.txtvAdditionalNotes.text,@"direction":_txtDirection.text}];
        
    // }
    _txttest.text = @"";
    
    _txtDirection.text = @"";
    _txtvAdditionalNotes.text = @"";
    RowsPrescribeAdded=RowsPrescribeAdded+1;
    [_tblLab reloadData];
    }
    
    
    
}


- (IBAction)btnSubmitAction:(id)sender {
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    

    if(_txttest.text.length > 0){
             [self addNewLab:@{@"date":self.txtDate.text,@"test":self.txttest.text,@"direction_id":[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:selectedDirectionId] ], @"additional_notes":self.txtvAdditionalNotes.text,@"direction":_txtDirection.text}];
        
      
        
    }
    
    if(arrNewLab.count >0){
        for(int i = 0 ; i < arrNewLab.count; i++ ) {
            NSString *strDirection = [[arrLab objectAtIndex:i]valueForKey:@"direction"];
            if([strDirection isEqualToString:@"30 Minutes After Meals"]){
                strDirection = @"1";
                NSMutableDictionary *d = [[arrLab objectAtIndex:i] mutableCopy];
                [d setObject :strDirection forKey:@"direction"];
                [arrLab setObject: d atIndexedSubscript: i];
            }
            else if([strDirection isEqualToString:@"30 Minutes Before Meals"]){
                strDirection = @"2";
                NSMutableDictionary *d = [[arrNewLab objectAtIndex:i] mutableCopy];
                [d setObject :strDirection forKey:@"direction"];
                [arrLab setObject: d atIndexedSubscript: i] ;
            }
            else if([strDirection isEqualToString:@"After Meals"]){
                strDirection = @"3";
                NSMutableDictionary *d = [[arrNewLab objectAtIndex:i] mutableCopy];
                [d setObject :strDirection forKey:@"direction"];
                [arrLab setObject: d atIndexedSubscript: i];
            }
            else if([strDirection isEqualToString:@"Before Meals"]){
                strDirection = @"4";
                NSMutableDictionary *d = [[arrNewLab objectAtIndex:i] mutableCopy];
                [d setObject :strDirection forKey:@"direction"];
                [arrLab setObject: d atIndexedSubscript: i];        }
            else if([strDirection isEqualToString:@"With Meals"]){
                strDirection = @"5";
                NSMutableDictionary *d = [[arrNewLab objectAtIndex:i] mutableCopy];
                [d setObject :strDirection forKey:@"direction"];
                [arrLab setObject: d atIndexedSubscript: i];        }
            else if([strDirection isEqualToString:@"With Plenty of Water"]){
                strDirection = @"6";
                NSMutableDictionary *d = [[arrNewLab objectAtIndex:i] mutableCopy];
                [d setObject :strDirection forKey:@"direction"];
                [arrLab setObject: d atIndexedSubscript: i];        }
        }
        
        
        for(int i = 0 ; i < arrNewLab.count; i++ ) {
            NSMutableDictionary *d = [[arrNewLab objectAtIndex:i] mutableCopy];
            NSString *atrDate = [[arrNewLab objectAtIndex:i] valueForKey:@"date"];
            atrDate = [self ChangeFormat:atrDate];
            [d setObject :atrDate forKey:@"date"];
            
            if(atrDate == nil){
                atrDate = [[arrNewLab objectAtIndex:i] valueForKey:@"date"];
            }
            [d setObject :atrDate forKey:@"date"];
            [arrNewLab setObject: d atIndexedSubscript: i];
        }
        
        NSError *error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:arrNewLab options:kNilOptions error:&error];
        NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [parameter setObject:dataString forKey:@"data"];
        CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service postLabDetails:parameter WithVisitId:docService.visit_id WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            if ([[responseCode valueForKey:@"status"] isEqualToString:@"success"]) {
                
                _txttest.text = @"";
                _txtDirection.text =@"";
                _txtvAdditionalNotes.text = @"";
               // [self addLab:@{@"date":self.txtDate.text,@"test":self.txttest.text,@"direction_id":[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:selectedDirectionId] ], @"additional_notes":self.txtvAdditionalNotes.text,@"direction":_txtDirection.text}];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sucessfully data saved !! Do you want to continue to enter Leave note?"message:@"" preferredStyle:UIAlertControllerStyleAlert];
                //We add buttons to the alert controller by creating UIAlertActions:
                UIAlertAction *yesPressed = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"sdssdasdasdad");
                    UITabBarController *tabBarController = (TabbarCategoryViewController *)self.parentViewController;
                    NSMutableArray *viewControllersCopy = [[tabBarController viewControllers] mutableCopy];
                    [tabBarController setSelectedIndex:4];
                }];
                
                UIAlertAction *noPressed = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                
                [alertController addAction:noPressed];
                [alertController addAction:yesPressed];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    else{
        if (![IODUtils getError:self.txttest minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:YES canBeEmpty:NO checkEmail:NO minAge:nil maxAge:nil canBeSameDate:nil ]) {
        }
    }
}

- (NSString *) ChangeFormat : (NSString *) toDate
{
    NSString *toDateCheck;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MMM/yyyy"];
    NSDate *date = [dateFormatter dateFromString: toDate]; // here you can fetch date from string with define format
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];// here set format which you want...
    toDateCheck = [dateFormatter stringFromDate:date]; //here convert date in NSString
    
    return toDateCheck;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.txtDirection) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
            NSDictionary *dictDirection = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"direction" ofType:@"json"]];
            arrDirection = [dictDirection valueForKey:@"direction"];
            self.pickerView.data = [arrDirection valueForKey:@"Title"];
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



#pragma mark - StringPickerViewDelegate
- (void)stringPickerViewDidSelectDone:(StringPickerView *)view
{
    if( [self.pickerView.refernceView isKindOfClass:[UITextField class]] )
    {
        UITextField *textField = (UITextField*)view.refernceView;
        if(textField == _txtDirection){
            textField.text = self.pickerView.value;
            selectedDirectionId = [[[arrDirection objectAtIndex:self.pickerView.selectedId] valueForKey:@"id"] intValue];
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

- (IBAction)btnCancelPrescribe:(id)sender {
    //    [UIView transitionWithView:_viewLab
    //                      duration:0.2
    //                       options:UIViewAnimationOptionTransitionCrossDissolve
    //                    animations:^{
    //                        _viewLab.hidden=YES;
    //                    }
    //                    completion:NULL];
    //
    //    RowsPrescribeAdded=RowsPrescribeAdded+1;
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

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)getAllLAB {
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:docService.visit_id forKey:@"visitId"];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service getLab:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            if(responseCode) {
             
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSMutableArray *Prescription = [responseCode objectForKey:@"data"];
                
                for(int i = 0 ; i< Prescription.count ;i ++){
                    
                    NSString *medication = [[Prescription objectAtIndex:i] valueForKey:@"test"];
                    NSString *strength = [[Prescription objectAtIndex:i] valueForKey:@"strength"];
                    NSString *quantity = [[Prescription objectAtIndex:i] valueForKey:@"quantity"];
                    NSString *direction_id = [NSString stringWithFormat:@"%@",[[Prescription objectAtIndex:i] valueForKey:@"direction_id"]];
                    NSString *additional_notes = [[Prescription objectAtIndex:i] valueForKey:@"additional_notes"];
                    NSString *dosage = [NSString stringWithFormat:@"%@",[[Prescription objectAtIndex:i] valueForKey:@"dosage"]];
                    NSString *direction =[NSString stringWithFormat:@"%@", [[Prescription objectAtIndex:i] valueForKey:@"direction"]];
                    NSString *StrRefill = @"";
                    [self addLab:@{@"test":medication,@"direction_id":[NSString stringWithFormat:@"%@",direction_id ], @"additional_notes":additional_notes,@"direction":direction}];
                };
            }
        }];
    }else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row %2){
        if([[arrHideCells objectAtIndex:indexPath.row] isEqualToString:@"YES"]){
            return 0;
        }
        else{
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            return 220;
        }else{
            return 196;
        }
    }
    else{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            return 50;
        }else{
            return 40;
        }
        
    }
    return 100;
}


-(void)addNewLab:(NSDictionary *)dataDictValues{
    [arrNewLab addObject:dataDictValues];
    [arrNewDir addObject:_txtDirection.text];
    
    [self addLab:dataDictValues];
    [_btnBadge setTitle:[NSString stringWithFormat:@"%ld",arrLab.count] forState:UIControlStateNormal];
    
    arrHideCells = [[NSMutableArray alloc] init];
    for(int i = 0 ;i < arrLab.count *2 ; i++) {
        
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
-(void)addLab:(NSDictionary *)dataDictValues{
    
    [arrLab addObject:dataDictValues];
    [arrDir addObject:_txtDirection.text];
    [_btnBadge setTitle:[NSString stringWithFormat:@"%ld",arrLab.count] forState:UIControlStateNormal];

    arrHideCells = [[NSMutableArray alloc] init];
    for(int i = 0 ;i < arrLab.count *2 ; i++) {
        
        NSString *strISSelected;
        if(i%2){
            strISSelected = @"YES";
        }
        else{
            strISSelected = @"YES";
        }
        [arrHideCells addObject:strISSelected];
    }
    
    [_tblLab reloadData];
}


-(IBAction)showList:(id)sender{
    [_labListView setHidden:NO];
}

-(IBAction)hideListView:(id)sender{
    [_labListView setHidden:YES];
    
}


@end
