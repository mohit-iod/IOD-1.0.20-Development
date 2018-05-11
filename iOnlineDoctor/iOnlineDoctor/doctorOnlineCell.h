//
//  doctorOnlineCell.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/3/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface doctorOnlineCell : UITableViewCell
@property(nonatomic, weak) IBOutlet UILabel *lblName;
@property(nonatomic, weak) IBOutlet UILabel *lblLanguage;
@property(nonatomic, weak) IBOutlet UILabel *lbladdress;
@property(nonatomic, weak) IBOutlet UIImageView *imgProfile;

@end
