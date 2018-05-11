
/*!
 @header AlergiesViewController.h
 @author Purva Bhureja,iOnlineDoctor
 @copyright  Copyright © 2018 iOnlineDoctor. All rights reserved.
 @version    1.0.21
 @brief This is the header file for AlergiesViewController
 
 @discussion
 AlergiesViewController supports the following
 * select the allergies from list of allergies
 */


#import <UIKit/UIKit.h>
#import "StringPickerView.h"
#import "IODregisterView.h"


@interface AlergiesViewController : UIViewController

/*! @brief This is textfield to enter allergy name.!*/
@property(nonatomic, weak) IBOutlet UITextField *txtAllergies;

/*! @brief This is textfield to enter how long.!*/
@property(nonatomic, weak) IBOutlet UITextField *txthowLong;

/*! @brief This is a pickerview to select the how long.!*/
@property (nonatomic, strong) StringPickerView *pickerView, *countryPicker;

/*! @brief This is table view that contains list of allergies.!*/
@property(nonatomic, weak) IBOutlet UITableView *tblAllergies;

/*! @brief This is a view that contains medication to be added.!*/
@property(nonatomic, weak) IBOutlet IODregisterView *Medication;


@end
