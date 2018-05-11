//
//  DocCellXib.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/16/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocCellXib : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblCellText;
@property (weak, nonatomic) IBOutlet UIButton *btnDwnload;
@property (weak, nonatomic) IBOutlet UIButton *btnView;
@property(nonatomic, weak) IBOutlet UIImageView *imgIcon;

@end
