//
//  CouponCellTableViewCell.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 12/27/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponCellTableViewCell : UITableViewCell
@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@property(nonatomic, weak) IBOutlet UILabel *lblDate;
@property(nonatomic, weak) IBOutlet UILabel *lblExpiryDate;

@property(nonatomic, weak) IBOutlet UIButton *lblAmount;
@property(nonatomic, weak) IBOutlet UIImageView *imgLogo;

@end
