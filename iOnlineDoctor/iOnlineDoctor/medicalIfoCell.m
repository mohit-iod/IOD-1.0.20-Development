//
//  medicalIfoCell.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/3/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "medicalIfoCell.h"

@implementation medicalIfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void)drawRect:(CGRect)rect{
    self.backgroundColor=[UIColor lightGrayColor];
    //    [self.heightAnchor constraintEqualToConstant:self.superview.frame.size.height].active=YES;
    //    [self.widthAnchor constraintEqualToConstant:self.superview.frame.size.width].active=YES;
}
- (IBAction)btnSelfAction:(id)sender {
}
- (IBAction)btnExistingAction:(id)sender {
}
- (IBAction)btnNewmemberAction:(id)sender {
    
    if([[(UIButton *)sender imageView].image isEqual:[UIImage imageNamed:@"down-arrow.png"]] ){
        
        [(UIButton *)sender imageView].image=[UIImage imageNamed:@"up-arrow.png"];
        [_delegate newMemberCLicked:YES];
    }else{
        [(UIButton *)sender imageView].image=[UIImage imageNamed:@"down-arrow.png"];
        [_delegate newMemberCLicked:NO];
    }
}
@end
