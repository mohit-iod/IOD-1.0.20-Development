//
//  BankAccountVC.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 8/31/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "BankAccountVC.h"
#import "IODUtils.h"
#import "DEMONavigationController.h"
#import "DEMOHomeViewController.h"
#import "DEMOMenuViewController.h"
#import "SignViewController.h"
#import "CommonServiceHandler.h"




@interface BankAccountVC () <StringPickerViewDelegate>
{
    int selectedAccountType;
    int selectedAccountCode;
}
@end

@implementation BankAccountVC

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View Controller Methods

- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    
    [self getAllBAnkDetails];
    
    self.title = @"Banking Info";
    self.navigationItem.leftBarButtonItem=nil;
   }

-(void) viewWillAppear:(BOOL)animated {
    NSInteger countryId = UDGetInt(@"cid");
    
    if(countryId == 101){
        [_imgPrice_bo setImage:[UIImage imageNamed:@"Sec-Op-price-inr.png"]];
        [_imgPrice_lc setImage:[UIImage imageNamed:@"video-call-price-inr.png"]];
        _txt15minsPrice.placeholder = @"Price/Consult - Live call In INR";
        _txt30minsPrice.placeholder = @"Price/Consult- 2nd Opinion In INR.";
    }
    else {
        [_imgPrice_bo setImage:[UIImage imageNamed:@"Sec-Op-price-dollar.png"]];
        [_imgPrice_lc setImage:[UIImage imageNamed:@"video-call-price.png"]];
        _txt15minsPrice.placeholder = @"Price/Consult - Live call In USD.";
        _txt30minsPrice.placeholder = @"Price/Consult- 2nd Opinion In USD.";
    }
    // Do any additional setup after loading the view.
 
}

#pragma mark - UITextfield Delegate Methods

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
            [self.view.window addSubview:self.pickerView];
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
            [self.view.window addSubview:self.pickerView];
            return NO;
        }
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField == _txt15minsPrice || textField == _txt30minsPrice){
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

#pragma mark - StringPickerView Delegate

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

#pragma mark - IBAction Methods

-(IBAction)submit:(id)sender {
    
    
   /* if(![IODUtils getError:self.txtAcType minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
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
    else*/
    if(![IODUtils getError:self.txt15minsPrice minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
    else if(![IODUtils getError:self.txt30minsPrice minVlue:nil minVlue:nil onlyNumeric:nil onlyChars:nil canBeEmpty:NO checkEmail:nil minAge:nil maxAge:nil canBeSameDate:NO ]){
    }
      else {
          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Your Earnings will only be deposited once your Banking information is provided." preferredStyle:UIAlertControllerStyleAlert];
          
          UIAlertAction *yesPressed = [UIAlertAction actionWithTitle:kSkip style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              [self nextScreen];
          }];
          UIAlertAction *noPressed = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          }];
          [alertController addAction:yesPressed];
          [alertController addAction:noPressed];
          [self presentViewController:alertController animated:YES completion:nil];
          
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

#pragma mark - Void Methods

- (void)nextScreen {
//    else {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    /*
     signature_path
     */
    NSMutableDictionary *parameter  = [[NSMutableDictionary alloc] init];
    [parameter setObject:[NSNumber numberWithInt:selectedAccountType] forKey:@"account_type"];
    
    [parameter setObject:_txtAcName.text forKey:@"account_name"];
    [parameter setObject:_txtAcHolderAddress.text forKey:@"account_holder_address"];
    [parameter setObject:[NSNumber numberWithInt:selectedAccountCode] forKey:@"account_type_detail_id"];
    [parameter setObject:_txtIban.text forKey:@"account_type_detail_value"];
    [parameter setObject:_txtBankName.text forKey:@"bank_name"];
    [parameter setObject:_txtBankAdress.text forKey:@"bank_address"];
    [parameter setObject:_txtBankAcNumber.text forKey:@"bank_account_no"];
    [parameter setObject:_txt15minsPrice.text forKey:@"lc_price"];
    [parameter setObject:_txt30minsPrice.text forKey:@"so_price"];

    SignViewController * viewcontroller = [sb instantiateViewControllerWithIdentifier:@"SignViewController"];
    viewcontroller.parameter  = parameter;
    
       [self.navigationController pushViewController:viewcontroller animated:YES];
    //}
}


-(void)redirectDoctor {

}


-(void)getAllBAnkDetails{
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service getBAnkDetails:^(NSDictionary *responseCode, NSError *error) {
        
        //selectedAccountType
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
             int accountType = [[dictdata  valueForKey:kaccounttype] intValue];
            selectedAccountCode = [[dictdata  valueForKey:kaccounttype] intValue];
            _txt30minsPrice.text = [NSString stringWithFormat:@"%@",[dictdata  valueForKey:ksoprice]];
            _txt15minsPrice.text = [NSString stringWithFormat:@"%@",[dictdata  valueForKey:klcprice]];
            
            if(accountType == 1){
                _txtAcType.text = @"Personal";
                selectedAccountType = 1;
            }
            else{
                _txtAcType.text = @"Business";
                selectedAccountType = 2;
            }
        }
    }];
}


// Mohit
#pragma mark - RefreshView Methods If Internet Connection Lost

-(void)refreshView:(NSNotification *) notification {
   [self getAllBAnkDetails];
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}


@end
