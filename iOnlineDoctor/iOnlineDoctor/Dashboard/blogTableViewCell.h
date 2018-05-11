//
//  blogTableViewCell.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 1/18/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface blogTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contv;
@property (weak, nonatomic) IBOutlet UIImageView *imgBlog;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnShare;


@end
