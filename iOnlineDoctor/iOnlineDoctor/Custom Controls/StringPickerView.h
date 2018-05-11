//
//  StringPickerView.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/27/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//
#import <UIKit/UIKit.h>

@class StringPickerView;

@protocol StringPickerViewDelegate <NSObject>

@optional
- (void)stringPickerViewDidSelectDone:(StringPickerView*)view;
- (void)stringPickerViewDidSelectCancel:(StringPickerView*)view;

@end

@interface StringPickerView : UIView

@property (nonatomic, weak) id <StringPickerViewDelegate> delegate;
@property (nonatomic, strong) NSString *preSelectedValue;
@property (nonatomic, readonly) NSString *value;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic) int selectedId;
@property (nonatomic, weak) UIView *refernceView;

@end
