//
//  searchDoctorVC.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/9/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchDoctorVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate,UIActionSheetDelegate>

/*! This property is used for search table*/
@property (weak, nonatomic) IBOutlet UITableView *tblDoctSearch;

/*! search bar to search the doctor from list */
@property(nonatomic,strong) IBOutlet UISearchBar *search;

/*! This property is used to set the error page if no data is available */
@property(nonatomic,weak) IBOutlet UIView *errorPage;

/*! This property is used to show the error label in error page */
@property (nonatomic, weak) IBOutlet UILabel *lblMessage;

/*! This property is used to book appointment if no live doctor is available */
@property (nonatomic, weak) IBOutlet UIButton *btnBookAppointment;

/*! This property is used to set the textcolor for TAbleview */
@property (nonatomic, weak) IBOutlet UIButton *btnCancel;

@property (retain, nonatomic) UISearchController *searchController;

@end
