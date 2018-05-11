//
//  HealthConditionViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 3/1/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HealthConditionViewController;

@protocol HealthConditionDelegate<NSObject>
@required
- (void)multiSelectControllerDidCancel:(HealthConditionViewController *)controller;
- (void)multiSelectController:(HealthConditionViewController *)controller didFinishPickingSelections:(NSArray *)selections;
@end


@interface HealthConditionViewController : UIViewController

/*! This property is used to set top Layout. */
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *topLayoutConstraint;

/*! This Collectionview is used for multiple collection. */
@property (nonatomic,strong) IBOutlet UICollectionView *multiSelectCollectionView;

/*! This table view shows table of symptoms. */
@property (nonatomic,strong) IBOutlet UITableView *tblOptions;

/*! Array for health conditions. */
@property (nonatomic,strong) NSMutableArray *arrOptions;

/*! This property is used to set delegate for Health condition. */
@property (nonatomic,strong) id<HealthConditionDelegate> delegate;

/*! @brief This is textfield to enter allergy name.!*/
@property (nonatomic,strong) NSString *leftButtonText;

/*! This property is used to set the title for right bar button */
@property (nonatomic,strong) NSString *rightButtonText;

/*! @brief This is textfield to enter allergy name.!*/
@property (nonatomic,strong) UIColor *leftButtonTextColor;

/*! @brief This is textfield to enter allergy name.!*/
@property (nonatomic,strong) UIColor *rightButtonTextColor;

/*! This property is used to set the color for background cell. */
@property (nonatomic,strong) UIColor *multiSelectCellBackgroundColor;

/*! This property is used to set the textcolor for TAbleview */
@property (nonatomic,strong) UIColor *tableTextColor;

/*! @brief This is textfield to enter allergy name.!*/
@property (nonatomic,strong) UIColor *multiSelectTextColor;


@end
