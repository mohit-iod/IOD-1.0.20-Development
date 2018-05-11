//
//  HealthIssueViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 3/1/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthIssueViewController : UIViewController

/*! @discussion This method  is used to go to next view controller
 * if the symptoms are selected the title will be next else it will be skip.
 !*/
@property(nonatomic, weak) IBOutlet UITextView *txtvHEalthIssue;

@end
