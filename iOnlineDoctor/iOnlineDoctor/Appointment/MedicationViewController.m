//
//  MedicationViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 3/1/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "MedicationViewController.h"
#import "MedicationCell.h"
#import "AlergiesViewController.h"
#import "PatientAppointService.h"
#import "AppDelegate.h"


@interface MedicationViewController () <StringPickerViewDelegate>
{

    /*! @brief This is an array to store medication names !*/
    NSMutableArray *arrMedication;
  
    UIBarButtonItem *btnNext;
    
    /*! @brief This is PatientAppointService object!*/
    PatientAppointService *patientService;
   
    /*! @brief This is AlergiesViewController object!*/
    AlergiesViewController *avc;
}

@end

@implementation MedicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set title for the navigation bar.
    self.title = @"Medical Info";
    
    patientService = [PatientAppointService sharedManager];
    avc =  [self.storyboard instantiateViewControllerWithIdentifier:@"AlergiesViewController"];
    if ([patientService.question_4 isEqualToString:@""]) {
         arrMedication = [[NSMutableArray alloc] init];
    }
    else{
        //Convert the array into JSON object.
        NSData *jsonData = [patientService.question_4 dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error:nil];
        arrMedication = jsonObject;
        [btnNext setTitle:kNext];
        [_tblMedication reloadData];
    }
    [self setUSertInterface];
}
-(void) viewWillAppear:(BOOL)animated{
    [btnNext setEnabled:YES];
}

- (void)setUSertInterface{
    // Do any additional setup after loading the view.
    [_tblMedication.layer setBorderColor:[UIColor colorWithHexRGB:kBorderColor].CGColor];
    [_tblMedication.layer  setBorderWidth:1.0];
    [_tblMedication.layer setCornerRadius:6.0];
    // arrMedication = [[NSMutableArray alloc] init];
    
    //NExt Button
    btnNext = [[UIBarButtonItem alloc] initWithTitle:kSkip style:UIBarButtonItemStyleDone target:self action:@selector(goNextPage:)];
    self.navigationItem.rightBarButtonItem = btnNext;
    
    UINib *nib = [UINib nibWithNibName:@"MedicationCell" bundle:[NSBundle mainBundle]];
    [[self tblMedication] registerNib:nib forCellReuseIdentifier:@"MedicationCell"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Textfield delegate methods.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.txthowLong) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
            NSArray *duration= [[NSArray alloc] initWithObjects:@"Past Week",@"Past Month",@"Past Year",@"More Than A Year", nil];
            self.pickerView.data = duration;
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

#pragma mark - StringPickerViewDelegate
- (void)stringPickerViewDidSelectDone:(StringPickerView *)view
{
    if( [self.pickerView.refernceView isKindOfClass:[UITextField class]] )
    {
        UITextField *textField = (UITextField*)view.refernceView;
        if(textField == _txthowLong){
            textField.text = self.pickerView.value;
        }
    }
    [btnNext setTitle:kNext];
    
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}

- (void)stringPickerViewDidSelectCancel:(StringPickerView *)view
{
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}

-(IBAction)btnAddTapped:(id)sender{
    if (![IODUtils getError:self.txtMedication minVlue:nil minVlue:nil onlyNumeric:nil
                  onlyChars:NO canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]) {
    }
    if (![IODUtils getError:self.txthowLong minVlue:nil minVlue:nil
                onlyNumeric:nil
                  onlyChars:NO canBeEmpty:NO checkEmail:NO minAge:nil maxAge:nil canBeSameDate:nil ]) {
    }
    else{
        
        [self addMedication:@{@"medication":_txtMedication.text, @"how_long":_txthowLong.text}];
    }
}


#pragma mark - tableview datasource and delegate method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrMedication count];
}


- (MedicationCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MedicationCell";
    
    MedicationCell *cell =(MedicationCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.lblTitle.text = [NSString stringWithFormat:@"    %@",[[arrMedication objectAtIndex:indexPath.row]valueForKey:@"medication"]];
    cell.lblSubTitle.text = [NSString stringWithFormat:@"    %@",[[arrMedication objectAtIndex:indexPath.row]valueForKey:@"how_long"]];
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}



#define mark - collectionview datasource and delegate method

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrMedication.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 56;
    }else{
        return 51;
    }
    
}


/* Click event to add Medication from dictionary */
-(void)addMedication: (NSDictionary *)dict{
    [arrMedication addObject:dict];
    [_tblMedication reloadData];
    
    _txthowLong.text = @"";
    _txtMedication.text = @"";
    if(arrMedication.count > 0){
        [btnNext setTitle:kNext];
    }
    if(arrMedication.count == 10){
        [_Medication setHidden:YES];
    }
}


/* Click event to delete Medication */
-(IBAction)btnDeletePressed:(UIButton *)sender{
    [arrMedication removeObjectAtIndex:sender.tag];
    [_tblMedication reloadData];
    if(arrMedication.count == 0){
        [btnNext setTitle:kSkip];
    }
    if(arrMedication.count < 10){
        [_Medication setHidden:NO];
    }
}

/*! @discussion This method is used to handle click event to go to next page  */
-(IBAction)goNextPage:(id)sender{
   
    if(arrMedication.count > 0) {
        if(_txthowLong.text.length>0 && _txtMedication.text.length>0){
            NSError *error;
            [self addMedication:@{@"medication":_txtMedication.text, @"how_long":_txthowLong.text}];
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:arrMedication options:kNilOptions error:&error];
            NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            patientService.question_4 = dataString;
        }
        else if(_txthowLong.text.length == 0  &&  _txtMedication.text.length == 0){
            NSError *error;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:arrMedication options:kNilOptions error:&error];
            NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            patientService.question_4 = dataString;        }
        else {
           // [IODUtils showMessage:MEDICATION_ERROR withTitle:@""];
            [IODUtils showFCAlertMessage:MEDICATION_ERROR  withTitle:nil withViewController:self with:@"error" ];

        }
    }
    else{
        if(_txthowLong.text.length == 0  &&  _txtMedication.text.length == 0){
             patientService.question_4 = @"";
        }
        else if(_txthowLong.text.length > 0 && _txtMedication.text.length > 0)
        {
            NSError *error;
            [self addMedication:@{@"medication":_txtMedication.text, @"how_long":_txthowLong.text}];
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:arrMedication options:kNilOptions error:&error];
            NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            patientService.question_4 = dataString;
        }
        else{
            // [IODUtils showMessage:MEDICATION_ERROR withTitle:@""];
            [IODUtils showFCAlertMessage:MEDICATION_ERROR  withTitle:nil withViewController:self with:@"error" ];
            [btnNext setEnabled:YES];
            return;
        }
    }
    [btnNext setEnabled:NO];
    [self.navigationController pushViewController:avc animated:YES];
}

/*!@discussion This method  is used to go to RootViewController.!*/
-(IBAction)btnHomePressed:(id)sender{
    AppDelegate *appDelegate=( AppDelegate* )[UIApplication sharedApplication].delegate;
    [appDelegate updateStatus:@""];
    [self.navigationController popToRootViewControllerAnimated:YES];}


@end
