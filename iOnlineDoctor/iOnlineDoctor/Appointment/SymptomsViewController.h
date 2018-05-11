/*!
 @header SymptomsViewControlDelegate.h
 @author Purva Bhureja,iOnlineDoctor
 @copyright  Copyright © 2018 iOnlineDoctor. All rights reserved.
 @version    1.0.21
 @brief This is the header file for SelectPatientViewController
 
 @discussion
 SymptomsViewControlDelegate supports the following
 * select the patient type
 * create a new patient
 */

#import <UIKit/UIKit.h>
#import "HealthIssueViewController.h"

@class SymptomsViewController;

@protocol SymptomsViewControlDelegate<NSObject>

@required


/*!
 @brief It converts temperature degrees from Fahrenheit to Celsius scale.
 
 @discussion This method is used to cancel the selection of cell.
  To use it, simply use the delegate method;
 
 @param controller input value representing the object of SymptomsViewController
 
 */

- (void)multiSelectControllerDidCancel:(SymptomsViewController *)controller;

/*!
 @brief It converts temperature degrees from Fahrenheit to Celsius scale.
 
 @discussion This method is used for multiple selection of cell.
 To use it, simply use the delegate method;
 
 @param  selections input value representing the array of selected values.
 
 */

- (void)multiSelectController:(SymptomsViewController *)controller didFinishPickingSelections:(NSArray *)selections;
@end



@interface SymptomsViewController : UIViewController
{

    
}
/*! This property is used to set top Layout. */
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *topLayoutConstraint;

/*! This Collectionview is used for multiple collection. */
@property (nonatomic,strong) IBOutlet UICollectionView *multiSelectCollectionView;

/*! This table view shows table of symptoms. */
@property (nonatomic,strong) IBOutlet UITableView *tblOptions;

/*! Array for symptoms. */
@property (nonatomic,strong) NSMutableArray *arrOptions;

/*! This property is used to set the title for left bar button. */
@property (nonatomic,strong) NSString *leftButtonText;

/*! This property is used to set the title for right bar button */
@property (nonatomic,strong) NSString *rightButtonText;

/*! This property is used to set the color for background cell. */
@property (nonatomic,strong) UIColor *multiSelectCellBackgroundColor;

/*! This property is used to set the textcolor for TAbleview */
@property (nonatomic,strong) UIColor *tableTextColor;

/*! This property is used to set the textcolor for multiple selection. */
@property (nonatomic,strong) UIColor *multiSelectTextColor;

/*! This property is used to set delegate for symptoms. */
@property (nonatomic,strong) id<SymptomsViewControlDelegate> delegate;

@end
