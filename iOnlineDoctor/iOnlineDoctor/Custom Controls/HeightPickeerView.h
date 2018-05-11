//
//  HeightPickeerView.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/17/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeightPickeerView;
@protocol HeightPickeerViewDelegate <NSObject>

- (void)heightPickerViewDidSelectDone:(HeightPickeerView*)view;
- (void)heightPickerViewDidSelectCancel:(HeightPickeerView*)view;

@end

@interface HeightPickeerView : UIView

@property (nonatomic, weak) id <HeightPickeerViewDelegate> delegate;
@property (nonatomic, strong) NSString *preSelectedComponent1Value, *preSelectedComponent2Value;
@property (nonatomic, readonly) NSString *component1Value, *component2Value;

@property (nonatomic, strong) NSArray *component1,*component2;
@property (nonatomic) int selectedcomponent1Id,selectedcomponent2Id;
@property (nonatomic, weak) UIView *refernceView;

@end


