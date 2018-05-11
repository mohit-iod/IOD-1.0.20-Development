//
//  EVisitVCViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/16/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVisitVCViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, weak) IBOutlet UITableView *tblPatientlist;
@end
