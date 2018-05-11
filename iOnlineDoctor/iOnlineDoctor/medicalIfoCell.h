//
//  medicalIfoCell.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/3/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol delegateMedXib <NSObject>

-(void)newMemberCLicked:(BOOL)show;

@end


@interface medicalIfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnSelf;
@property (weak, nonatomic) IBOutlet UIButton *btnExistingMember;
@property (weak, nonatomic) IBOutlet UIButton *btnNewMember;

@property (weak,nonatomic) IBOutlet id <delegateMedXib>delegate;

- (IBAction)btnSelfAction:(id)sender;
- (IBAction)btnExistingAction:(id)sender;
- (IBAction)btnNewmemberAction:(id)sender;
@end
