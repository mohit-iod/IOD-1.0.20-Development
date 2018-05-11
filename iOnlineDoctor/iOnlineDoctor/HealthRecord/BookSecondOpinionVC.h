//
//  BookSecondOpinionVC.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 10/5/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookSecondOpinionVC;
@protocol CustomDelegate <NSObject>
- (void)setSelectedTabIndex:(int)index;
@end

@interface BookSecondOpinionVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) id <CustomDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tblEVisit;
@property (weak, nonatomic) IBOutlet UIButton *btnLocal;
@property (weak, nonatomic) IBOutlet UIButton *btnInternational;
- (IBAction)localPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *internationalPressed;

@end
