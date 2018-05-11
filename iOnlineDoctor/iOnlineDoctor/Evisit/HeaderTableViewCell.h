//
//  HeaderTableViewCell.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 1/2/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderTableViewCell : UITableViewCell
@property(nonatomic, strong)  IBOutlet UIImageView *imgArrow;
@property(nonatomic, strong)  IBOutlet UILabel *lblTitle;
@property(nonatomic, strong)  IBOutlet UIImageView *imgLogo;

@end
