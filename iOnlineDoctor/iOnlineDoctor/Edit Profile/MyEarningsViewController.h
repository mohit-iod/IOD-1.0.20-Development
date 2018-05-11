//
//  MyEarningsViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 12/27/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonServiceHandler.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "UIColor+HexString.h"
#import "CouponCellTableViewCell.h"

@interface MyEarningsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblMyEarnings;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;



@end
