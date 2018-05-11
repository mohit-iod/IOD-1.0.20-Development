//
// UICheckbox.m
//  iOnlineDoctor
//
//  Created by Purva Bhureja on 8/22/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICheckbox : UIControl

-(void)setChecked:(BOOL)boolValue;
-(void)setDisabled:(BOOL)boolValue;
-(void)setText:(NSString *)stringValue;

@property(nonatomic, assign)BOOL checked;
@property(nonatomic, assign)BOOL disabled;
@property(nonatomic, strong)NSString *text;

@end
