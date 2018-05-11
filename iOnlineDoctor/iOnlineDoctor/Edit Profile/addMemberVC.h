//
//  addMemberVC.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/4/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addMemberVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblMember;

@end
