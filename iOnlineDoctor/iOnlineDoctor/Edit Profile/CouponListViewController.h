//
//  CouponListViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 12/26/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonServiceHandler.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "UIColor+HexString.h"
@interface CouponListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblCoupon;

@end
