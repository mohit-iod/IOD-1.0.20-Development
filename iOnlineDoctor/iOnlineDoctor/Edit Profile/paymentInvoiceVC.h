//
//  paymentInvoiceVC.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/4/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocCellXib.h"

@interface paymentInvoiceVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblPayment;

@end
