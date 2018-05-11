//
//  ExploreViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 1/18/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "ViewController.h"

@interface ExploreViewController : ViewController

/**/
@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, weak) IBOutlet UIImageView *imgProfile;
@property(nonatomic, weak) IBOutlet UILabel *lblName;
@property(nonatomic, weak) IBOutlet UILabel *lblLocation;
@property(nonatomic, strong) NSString *userType;

@end
