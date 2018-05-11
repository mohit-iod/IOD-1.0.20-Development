//
//  labXibTableCell.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 10/5/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface labXibTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTest;
@property (weak, nonatomic) IBOutlet UILabel *lblDirection;
@property (weak, nonatomic) IBOutlet UITextView *txtAdiitonalNotes;

@end
