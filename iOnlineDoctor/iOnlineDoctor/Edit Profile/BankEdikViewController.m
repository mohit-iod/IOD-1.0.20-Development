//
//  BankEdikViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 12/27/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "BankEdikViewController.h"
#import "IODUtils.h"
#import "DEMONavigationController.h"
#import "DEMOHomeViewController.h"
#import "DEMOMenuViewController.h"
#import "StringPickerView.h"
#import "CommonServiceHandler.h"
#import "RegistrationService.h"
#import "IODUtils.h"

@interface BankEdikViewController ()<StringPickerViewDelegate>
{
    int selectedAccountType;
    int selectedAccountCode;
    int accountType;
    
}

@end

@implementation BankEdikViewController

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    [super viewDidLoad];
   // self.title = @"Banking Info";
    self.navigationItem.leftBarButtonItem=nil;
    self.tabBarController.title =@"Edit Banking Info";
    [self getAllBAnkDetails];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.title =@"Edit Banking Info";
    NSInteger countryId = UDGetInt(@"cid");
    if(countryId == 101){
        [_imgPrice_bo setImage:[UIImage imageNamed:@"Sec-Op-price-inr.png"]];
        [_imgPrice_lc setImage:[UIImage imageNamed:@"video-call-price-inr.png"]];
         _txt15minsCharge.placeholder = kLCPricePlaceholderInr;
         _txt30minsCharge.placeholder = kSOPricePlaceholderInr;
    }
    else {
        [_imgPrice_bo setImage:[UIImage imageNamed:@"Sec-Op-price-dollar.png"]];
        [_imgPrice_lc setImage:[UIImage imageNamed:@"video-call-price.png"]];
        _txt15minsCharge.placeholder = kLCPricePlaceholderDollar;
        _txt30minsCharge.placeholder = kSOPricePlaceholderDollar;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAllBAnkDetails{
    
        CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service getBAnkDetails:^(NSDictionary *responseCode, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([[responseCode valueForKey:@"status"] isEqualToString:@"success"]){
                NSDictionary *dictdata = [responseCode valueForKey:@"data"];
                _txtIban.text =[dictdata  valueForKey:kaccounttypedetailvalue];
                _accountTypeCode.text = [dictdata  valueForKey:kaccounttypeDetailid];
                _txtAcName.text =[dictdata  valueForKey:kaccountname];
                _txtBankAcNumber.text =[NSString stringWithFormat:@"%@", [dictdata  valueForKey:kbankaccountno]];
                _txtAcHolderAddress.text =[dictdata  valueForKey:kaccountholderAddress];
                _txtBankName.text =[dictdata  valueForKey:kbankname];
                _txtBankAdress.text = [dictdata  valueForKey:kbankaddress];
                //selectedAccountCode =
                accountType = [[dictdata  valueForKey:kaccounttype] intValue];
                selectedAccountCode = [[dictdata  valueForKey:kaccounttype] intValue];
                
                _txt30minsCharge.text = [NSString stringWithFormat:@"%@",[dictdata  valueForKey:ksoprice]];
                _txt15minsCharge.text = [NSString stringWithFormat:@"%@",[dictdata  valueForKey:klcprice]];
                
                if(accountType == 1){
                    _txtAcType.text = @"Personal";
                }
                else{
                    _txtAcType.text = @"Business";
                }

                
                //For bank code
                if( [_accountTypeCode.text isEqualToString:@"IBAN"])
                {
                    selectedAccountCode = 1;
                }
                else if( [_accountTypeCode.text isEqualToString:@"SWIFT COD"]){
                    selectedAccountCode = 2;
                }
                else if( [_accountTypeCode.text isEqualToString:@"National ID"]){
                    selectedAccountCode = 3;
                }
                else if( [_accountTypeCode.text isEqualToString:@"IFSC CODE"]){
                    selectedAccountCode = 4;
                }
                
                
                if(_txtIban.text.length > 0){
                    [IODUtils setPlaceHolderLabelforTextfield:_txtIban];

                }
                if(_txtAcCode.text.length > 0){
                    [IODUtils setPlaceHolderLabelforTextfield:_txtAcCode];
                }
                if(_txtAcName.text.length > 0){
                    [IODUtils setPlaceHolderLabelforTextfield:_txtAcName];
                }
                if(_txtAcType.text.length > 0){
                    [IODUtils setPlaceHolderLabelforTextfield:_txtAcName];
                }
                if(_txtAcNumber.text.length >0 ){
                    [IODUtils setPlaceHolderLabelforTextfield:_txtAcNumber];
                }
                if(_txtBankName.text.length > 0){
                    [IODUtils setPlaceHolderLabelforTextfield:_txtBankName];
                }
                if(_txtBankAdress.text.length > 0){
                    [IODUtils setPlaceHolderLabelforTextfield:_txtBankAdress];
                }
                if(_txt15minsCharge.text.length > 0){
                    [IODUtils setPlaceHolderLabelforTextfield:_txt15minsCharge];
                }
                if(_txt30minsCharge.text.length >0){
                    [IODUtils setPlaceHolderLabelforTextfield:_txt30minsCharge];
                }
                if(_txtBankAcNumber.text.length > 0){
                    [IODUtils setPlaceHolderLabelforTextfield:_txtBankAcNumber];
                }
                if(_txtAcHolderAddress.text.length > 0){
                    [IODUtils setPlaceHolderLabelforTextfield:_txtAcHolderAddress];
                }
                if(_accountTypeCode.text.length > 0){
                    [IODUtils setPlaceHolderLabelforTextfield:_accountTypeCode];
                }
            }
        }];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [IODUtils setPlaceHolderLabelforTextfield:textField];
    if (textField == self.txtAcType) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
            NSArray *bankActype= [NSArray arrayWithObjects:@"Personal",@"Business",nil];
            self.pickerView.data = bankActype;
            self.pickerView.delegate = self;
            self.pickerView.preSelectedValue = textField.text;
            self.pickerView.refernceView = textField;
            [self.view.window addSubview:self.pickerView];;
            return NO;
        }
        return NO;
    }
    else  if (textField == self.accountTypeCode) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        if(!self.pickerView) {
            CGSize pickerSize = CGSizeMake(SCREEN_WIDTH, 280);
            CGRect pickerFrame = CGRectMake(0,SCREEN_HEIGHT - 280, pickerSize.width, pickerSize.height);
            self.pickerView = [[StringPickerView alloc] initWithFrame:pickerFrame];
            NSDictionary *dictBAnkCode = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"bankCode" ofType:@"json"]];
            NSArray *arrBankCode= [dictBAnkCode valueForKey:@"code"];
            self.pickerView.data = [arrBankCode  valueForKey:@"Title"];
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

  
    if(textField == _txt15minsCharge || textField == _txt30minsCharge){
        {
            const char *_char = [string cStringUsingEncoding:NSUTF8StringEncoding];
            int isBackSpace = strcmp(_char, "\b");
            if (isBackSpace == -8) {
                return YES;
            }
            // If it's not a backspace, allow it if we're still under 30 chars.
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            return (newLength > 5) ? NO : YES;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - StringPickerViewDelegate
- (void)stringPickerViewDidSelectDone:(StringPickerView *)view
{
    if( [self.pickerView.refernceView isKindOfClass:[UITextField class]] )
    {
        UITextField *textField = (UITextField*)view.refernceView;
        if(textField == _txtAcType){
            textField.text = self.pickerView.value;
            selectedAccountType = self.pickerView.selectedId+1;
        }
        if(textField == _accountTypeCode){
            textField.text = self.pickerView.value;
            selectedAccountCode = self.pickerView.selectedId+1;
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

-(IBAction)submit:(id)sender {
   
    /*
     if(![IODUtils getError:self.txtAcType minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtAcName minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtAcHolderAddress minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.accountTypeCode minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtIban minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtBankName minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtBankAdress minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txtBankAcNumber minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else
        */
    
    if(![IODUtils getError:self.txt15minsCharge minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }else if(![IODUtils getError:self.txt30minsCharge minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else {
        Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
        BOOL reachable = reach. isReachable;
        if (reachable) {
            [self editDetails];
        }
        else{
            //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        }
    }
}

//Error labele after textfield
+(UILabel *)getErrorLabel:(UITextField *)useText{
    @try {
        for(UIView *v in useText.superview.subviews ){
            if (v.tag == 10) {
                return (UILabel *)v;
            }
        }
    } @catch (NSException *exception) {
    }
    return [UILabel new];
}

-(void)editDetails{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter  = [[NSMutableDictionary alloc] init];
    [parameter setObject:[NSNumber numberWithInt:selectedAccountType] forKey:kaccounttype];
    [parameter setObject:_txtAcName.text forKey:kaccountname];
    [parameter setObject:_txtAcHolderAddress.text forKey:kaccountholderAddress];
    [parameter setObject:[NSNumber numberWithInt:selectedAccountCode] forKey:kaccounttypeDetailid];
    [parameter setObject:_txtIban.text forKey:kaccounttypedetailvalue];
    [parameter setObject:_txtBankName.text forKey:kbankname];
    [parameter setObject:_txtBankAdress.text forKey:kbankaddress];
    [parameter setObject:_txtBankAcNumber.text forKey:kbankaccountno];
    [parameter setObject:_txt15minsCharge.text forKey:klcprice];
    [parameter setObject:_txt30minsCharge.text forKey:ksoprice];
    [parameter setObject:[NSNumber numberWithInt:0] forKey:ksignatureflag];
    
    [service editBAnkDetails:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [IODUtils showFCAlertMessage:@"Succesfully saved"  withTitle:@"" withViewController:self with:@"error"];
    }];
}


-(void)refreshView:(NSNotification*)notification{
    [self getAllBAnkDetails];
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}


@end
