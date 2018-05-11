//
//  EVisitVC.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/21/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocCellXib.h"
#import "E_VisitCell.h"
#import "PatientVisitServiceHandler.h"


@interface EVisitVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblEVisit;
@property (retain, nonatomic) IBOutlet UILabel *lblStatus;
@end
