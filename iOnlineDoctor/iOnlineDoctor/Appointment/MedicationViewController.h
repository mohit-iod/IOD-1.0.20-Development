
/*!
 @header MedicationViewController.h
 @author Purva Bhureja,iOnlineDoctor
 @copyright  Copyright © 2018 iOnlineDoctor. All rights reserved.
 @version    1.0.21
 @brief This is the header file for MedicationViewController
 
 @discussion
 MedicationViewController supports the following
 * Add new medication and mention how long.
 */



#import <UIKit/UIKit.h>
#import "StringPickerView.h"
#import "IODregisterView.h"

@interface MedicationViewController : UIViewController

/*! @brief This is textfield to enter medication name.!*/
@property(nonatomic, weak) IBOutlet UITextField *txtMedication;

/*! @brief This is textfield to enter medication name.!*/
@property(nonatomic, weak) IBOutlet UITextField *txthowLong;

/*! @brief This is pickerview to select the duration of medicine!*/
@property (nonatomic, strong) StringPickerView *pickerView, *countryPicker;

/*! @brief This is UITableView that shows medication list.!*/
@property(nonatomic, weak) IBOutlet UITableView *tblMedication;

@property(nonatomic, weak) IBOutlet IODregisterView *Medication;

@end
