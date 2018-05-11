//
//  DashboardXibCell.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/27/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardXibCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgDashboardCell;
@property (weak, nonatomic) IBOutlet UIImageView *imgbellIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (nonatomic,strong)IBOutlet UILabel * lblCount;

@property (weak, nonatomic) IBOutlet UILabel *lblDashboardTitle;
@end
