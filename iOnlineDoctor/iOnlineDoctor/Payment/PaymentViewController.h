//
//  PaymentViewController.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/7/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "ViewController.h"
#import "StringPickerView.h"
#import "PaymentsSDK.h"

@interface PaymentViewController : ViewController<PGTransactionDelegate>


@property (nonatomic, strong) NSMutableDictionary* icredit_card;
@property (nonatomic, strong) NSString* fdTokenValue;

@property (nonatomic, strong) IBOutlet UITextField *txtCouponcode;
@property (nonatomic, strong) IBOutlet UITextField *txtName;
@property (nonatomic, strong) IBOutlet UITextField *txtCardNumber;
@property (nonatomic, strong) IBOutlet UITextField *txtExpiryDate;
@property (nonatomic, strong) IBOutlet UITextField *txtCvv;
@property (nonatomic, strong) IBOutlet UITextField *txtCardType;
@property (nonatomic, strong) IBOutlet UITextField *txtamount;
@property (nonatomic, strong) IBOutlet UIButton  *btnApplyCoupon;
@property (nonatomic, strong) IBOutlet UIButton  *btnCouponPayment;
@property (nonatomic, strong) IBOutlet UIButton  *btnRemoveCouponPayment;
@property (nonatomic, strong) IBOutlet UILabel  *lblAmount;

@property (nonatomic, strong) StringPickerView *pickerView;
@property (nonatomic, strong) UIView *datePickerView;

@property (nonatomic, strong) IBOutlet UIView *creditCardView;
@property (nonatomic, strong) IBOutlet UIView *couponCodeView;

@end
