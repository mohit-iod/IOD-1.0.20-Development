//
//  MedicationCell.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 3/3/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicationCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblSubTitle;
@property (nonatomic, weak) IBOutlet UIButton *btnDelete;
@end
