//
//  secondOpinion.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/21/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocCellXib.h"

@interface secondOpinion : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblSecondOp;
@property (retain, nonatomic) IBOutlet UILabel *lblStatus;
@end
