//
//  ERXContainerInfoVC.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/17/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol delegateP <NSObject>

-(void)CancelSontainer;
-(void)addPrecription:(NSDictionary *)dataDictValues;
@end

@interface ERXContainerInfoVC : UIViewController

@property (weak,nonatomic) id<delegateP>delegateERX;
@property (weak, nonatomic) IBOutlet UITextField *txtDat;
@property (weak, nonatomic) IBOutlet UITextField *txtMeds;
@property (weak, nonatomic) IBOutlet UITextField *txtStength;
@property (weak, nonatomic) IBOutlet UITextField *txtQuantity;
@property (weak, nonatomic) IBOutlet UITextField *txtDIrection;
- (IBAction)cancelAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addAction;

- (IBAction)addClickAction:(id)sender;

@end
