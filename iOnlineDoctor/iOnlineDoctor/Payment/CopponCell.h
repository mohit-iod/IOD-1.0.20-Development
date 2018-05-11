//
//  CopponCell.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 2/5/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CopponCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *lblCoupon;
@property (nonatomic, weak) IBOutlet UIButton *btnApplyCoupon;
@property (nonatomic, weak) IBOutlet UIImageView *imgCoupon;

@end
