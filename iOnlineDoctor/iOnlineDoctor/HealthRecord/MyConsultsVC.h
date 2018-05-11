//
//  MyConsultsVC.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 10/5/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyConsultsVC : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *tableData;
}
@property (weak, nonatomic) IBOutlet UITableView *tblEVisit;
@property (retain, nonatomic) IBOutlet UILabel *lblStatus;
@property (retain, nonatomic) UIView *CancelAppointmentView;
@property (retain, nonatomic)  UITextView *txtv;


@end
