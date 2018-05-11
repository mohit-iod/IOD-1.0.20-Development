//
//  erxViewTableViewCell.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 10/5/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface erxViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDirect;
@property (weak, nonatomic) IBOutlet UILabel *lblRefill;
@property (weak, nonatomic) IBOutlet UILabel *lblQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lblDosage;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblMeds;
@property (weak, nonatomic) IBOutlet UILabel *lblStr;
@property (weak, nonatomic) IBOutlet UILabel *lblAdditional;

@end
