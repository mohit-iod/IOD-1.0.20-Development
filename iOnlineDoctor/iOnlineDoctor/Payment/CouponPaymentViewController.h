//
//  CouponPaymentViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 2/5/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponPaymentViewController : UIViewController
@property(nonatomic,  weak) IBOutlet  UITextField *txtCouponCode;
@property(nonatomic,  weak) IBOutlet  UITableView *tblCoupon;

@end
