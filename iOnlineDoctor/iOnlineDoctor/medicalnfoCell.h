//
//  medicalnfoCell.h
//  
//
//  Created by Meghna Patel on 9/8/17.
//
//

#import <UIKit/UIKit.h>

@protocol delegateMedXib <NSObject>
-(void)newMemberCLicked:(BOOL)show;
-(void)newSelfCLicked:(BOOL)show;
-(void)newExistingMemberCLicked:(BOOL)show;

@end

@interface medicalnfoCell : UIView
{
    NSArray *memberArray;
    int selectedIndex;
}

@property (weak, nonatomic) IBOutlet UIButton *btnSelf;
@property (weak, nonatomic) IBOutlet UIButton *btnExistingMember;
@property (weak, nonatomic) IBOutlet UIButton *btnNewMember;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtDOB;
@property (weak, nonatomic) IBOutlet UITextField *txtGender;

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *ButtonArray;

@property (weak,nonatomic) IBOutlet id <delegateMedXib>delegate;

- (IBAction)btnSelfAction:(id)sender;
- (IBAction)btnExistingAction:(id)sender;
- (IBAction)btnNewmemberAction:(id)sender;
- (IBAction)btnTapped:(UIButton *)sender;
@end
