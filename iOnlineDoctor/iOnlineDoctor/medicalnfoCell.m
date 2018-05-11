//
//  medicalnfoCell.m
//
//
//  Created by Meghna Patel on 9/8/17.
//
//

#import "medicalnfoCell.h"
#import "CommonServiceHandler.h"
#import "PatientAppointService.h"
@implementation medicalnfoCell {
    PatientAppointService *patientService;
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
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    patientService = [PatientAppointService sharedManager];
}

- (IBAction)btnTapped:(UIButton *)sender {
    selectedIndex = (int)sender.tag;
    for ( int i=0; i < [self.ButtonArray count]; i++) {
        [[self.ButtonArray objectAtIndex:i] setBackgroundImage:[UIImage
                                                      imageNamed:@"radio-inactive.png"]
                                            forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"radio-active.png"]
                forState:UIControlStateNormal];
    }
    if(selectedIndex == 1){
        [self btnSelfAction:sender];
    }
    else if(selectedIndex == 2)
    {
        [self btnExistingAction:sender];
    }
    else if(selectedIndex == 3){
        [self btnNewmemberAction:sender];
    }
}
-(void) emptyTextfieldData {
    
    _txtName.text = nil;
    _txtDOB.text = nil;
    _txtGender = nil;
}

- (void)getAllExixtingMembers {
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service getAllMembersWithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        //NSLog(@"DIct %@",responseCode);
        memberArray =  [responseCode valueForKey:@"data"];
       // [self.tblMember reloadData];
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    } ];
}

- (IBAction)btnSelfAction:(id)sender {
 //   patientService.question_2 = @"1";
    [self emptyTextfieldData];
    [_delegate newSelfCLicked:NO];
}

- (IBAction)btnExistingAction:(id)sender {
  //  patientService.question_2 = @"2";
    [self emptyTextfieldData];
    [_delegate newExistingMemberCLicked:NO];
}

- (IBAction)btnNewmemberAction:(id)sender {
 //   patientService.question_2 = @"3";
    [_delegate newMemberCLicked:NO];
}


@end
