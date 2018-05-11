//
//  MultiSelectTableView.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 4/11/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MultiSelectTableViewDelegate <NSObject>

-(void)multiSelectTableviewDoneClick;
-(void)multiSelectTableviewCancelClick;

@end

@interface MultiSelectTableView : UIView

@property(nonatomic, weak)id <MultiSelectTableViewDelegate>delegate;
@property(nonatomic,strong)NSArray * dataArray;
@property(nonatomic,strong)NSMutableArray * selectArray, * selectedData, * preSelectData;
@property(nonatomic,strong)NSString * returnValue;
@property(nonatomic,strong)NSString * preSelectedValue;
@property(nonnull,strong)NSUserDefaults * userDef;

-(void)setPreSelectData;

@end
