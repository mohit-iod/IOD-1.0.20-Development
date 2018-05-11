//
//  PatientListViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/30/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UITableView *tblPatientlist;
@property(nonatomic,strong) IBOutlet UISearchBar *search;
@property (retain, nonatomic) UISearchController *searchController;
@property (retain, nonatomic) IBOutlet UILabel *lblStatus;
@end
