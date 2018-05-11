//
//  AlergiesViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 3/3/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "AlergiesViewController.h"
#import "MedicationCell.h"
#import "HealthConditionViewController.h"
#import "PatientAppointService.h"
#import "AppDelegate.h"

@interface AlergiesViewController ()<StringPickerViewDelegate>{
    NSMutableArray *arrAllergies;
    UIBarButtonItem *btnNext;
    PatientAppointService *patientService;
    HealthConditionViewController *avc ;
}
@end

@implementation AlergiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Title of the navgation bar.
    self.title = @"Medical Info";

    patientService = [PatientAppointService sharedManager];
   
    // Do any additional setup after loading the view.
    [_tblAllergies.layer setBorderColor:[UIColor colorWithHexRGB:kBorderColor].CGColor];
    [_tblAllergies.layer  setBorderWidth:1.0];
    [_tblAllergies.layer setCornerRadius:6.0];
    arrAllergies = [[NSMutableArray alloc] init];
    
    patientService = [PatientAppointService sharedManager];
    avc =  [self.storyboard instantiateViewControllerWithIdentifier:@"HealthConditionViewController"];

    //Bar button
    btnNext = [[UIBarButtonItem alloc] initWithTitle:kSkip style:UIBarButtonItemStyleDone target:self action:@selector(goNextPage:)];
    self.navigationItem.rightBarButtonItem = btnNext;
    
    UINib *nib = [UINib nibWithNibName:@"MedicationCell" bundle:[NSBundle mainBundle]];
    [[self tblAllergies] registerNib:nib forCellReuseIdentifier:@"MedicationCell"];
}


-(void)viewWillAppear:(BOOL)animated{
    [btnNext setEnabled:YES];

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
            [self.view.window addSubview:self.pickerView];
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
        [btnNext setTitle:kNext];
    }
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}

- (void)stringPickerViewDidSelectCancel:(StringPickerView *)view
{
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}



#pragma mark - Tableview delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrAllergies count];
}

- (MedicationCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MedicationCell";
    
    MedicationCell *cell =(MedicationCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.lblTitle.text = [NSString stringWithFormat:@"    %@",[[arrAllergies objectAtIndex:indexPath.row]valueForKey:@"allergy"]];
    cell.lblSubTitle.text = [NSString stringWithFormat:@"    %@",[[arrAllergies objectAtIndex:indexPath.row]valueForKey:@"how_long"]];
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


#pragma mark Collection view delegte methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrAllergies.count;
}


#pragma mark - Add / Delete Allergies  

/*! @brief This method is used to add medication in array and reload the table.!*/

-(void)addMedication: (NSDictionary *)dict{
    [arrAllergies addObject:dict];
    [_tblAllergies reloadData];
    _txthowLong.text = @"";
    _txtAllergies.text = @"";
    if(arrAllergies.count > 0){
        [btnNext setTitle:kNext];
    }
    if(arrAllergies.count == 10){
        [_Medication setHidden:YES];
    }
    
}

/*! @brief This method is used when the user tap on the Add medication buttton.!*/
-(IBAction)btnAddTapped:(id)sender{
    if (![IODUtils getError:self.txtAllergies minVlue:nil minVlue:nil onlyNumeric:nil
                  onlyChars:YES canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:nil ]) {
    }
    if (![IODUtils getError:self.txthowLong minVlue:nil minVlue:nil
                onlyNumeric:nil
                  onlyChars:NO canBeEmpty:NO checkEmail:NO minAge:nil maxAge:nil canBeSameDate:nil ]) {
    }
    else{
        
        [self addMedication:@{@"allergy":_txtAllergies.text, @"how_long":_txthowLong.text}];
    }
}



/*! @brief This method is invoked when user click on delere button from list of allergy name.!*/
-(IBAction)btnDeletePressed:(UIButton *)sender{
    [arrAllergies removeObjectAtIndex:sender.tag];
    [_tblAllergies reloadData];
    if(arrAllergies.count == 0){
        [btnNext setTitle:kSkip];
    }
    if(arrAllergies.count < 10){
        [_Medication setHidden:NO];
    }
}


#pragma mark - Navigation methods 

/*! @discussion This method is used to handle click event to go to next page  */
-(IBAction)goNextPage:(id)sender{
    if(arrAllergies.count > 0) {
        if(_txthowLong.text.length>0 && _txtAllergies.text.length>0){
            NSError *error;
            [self addMedication:@{@"allergy":_txtAllergies.text, @"how_long":_txthowLong.text}];
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:arrAllergies options:kNilOptions error:&error];
            NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            patientService.question_5 = dataString;
        }
        else{
        NSError *error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:arrAllergies options:kNilOptions error:&error];
        NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        patientService.question_5 = dataString;
        }
    }
    else{
        if(_txthowLong.text.length == 00 &&  _txtAllergies.text.length == 0){
            patientService.question_5 = @"";
        }
        else if (_txthowLong.text.length == 00 ||  _txtAllergies.text.length == 0){
            [IODUtils showFCAlertMessage:ALLERGIES_ERROR  withTitle:nil withViewController:self with:@"error" ];
            [btnNext setEnabled:YES];
            return;
        }
        else{
            NSError *error;
            [self addMedication:@{@"allergy":_txtAllergies.text, @"how_long":_txthowLong.text}];
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:arrAllergies options:kNilOptions error:&error];
            NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            patientService.question_5 = dataString;
        }
    }
    _txtAllergies.text = @"";
    _txthowLong.text = @"";
    [btnNext setEnabled:NO];
    [self.navigationController pushViewController:avc animated:YES];
    
}

/*!@discussion This method  is used to go to RootViewController / Dashboard page.!*/
-(IBAction)btnHomePressed:(id)sender{
    //[[[UIApplication sharedApplication] delegate] performSelector:@selector(update)];
    AppDelegate *appDelegate=( AppDelegate* )[UIApplication sharedApplication].delegate;
    [appDelegate updateStatus:@""];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
