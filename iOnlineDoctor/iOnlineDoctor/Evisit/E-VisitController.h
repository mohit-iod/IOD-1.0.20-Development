//
//  E-VisitController.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/30/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface E_VisitController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *tableData;
  
}
@property (weak, nonatomic) IBOutlet UITableView *tblEVisit;
@property (retain, nonatomic) IBOutlet UILabel *lblStatus;

@property (retain, nonatomic) UIView *CancelAppointmentView;
@property (retain, nonatomic)  UITextView *txtv;

@end
