
/*!
 @header SelectPatientViewController.h
 @author Purva Bhureja,iOnlineDoctor
 @copyright  Copyright © 2018 iOnlineDoctor. All rights reserved.
 @version    1.0.21
 @brief This is the header file for SelectPatientViewController
 
 @discussion
  SelectPatientViewController supports the following
 * select the patient type
 * create a new patient 
 */


#import <UIKit/UIKit.h>


@interface SelectPatientViewController : UIViewController

/*! @brief This is a collectionview to show patient type that is self or other existing member */
@property (weak, nonatomic) IBOutlet UICollectionView *membersCollectionView;


/*! @brief This is a view to add new member */
@property (weak, nonatomic) IBOutlet UIView *MemberView;

/*! @brief array of buttons for single selection */
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *ButtonArray;


/*! @brief This is textfield to add name of new member */
@property (weak, nonatomic) IBOutlet UITextField *txtName;

/*! @brief This is textfield to select date of birth of new member */
@property (weak, nonatomic) IBOutlet UITextField *txtDOB;

/*! @brief This is view that contains date picker */
@property (nonatomic, strong) UIView *datePickerView;


/*! @brief This is label for male */
@property (weak, nonatomic) IBOutlet UILabel *lblMale;

/*! @brief This is label for female */
@property (weak, nonatomic) IBOutlet UILabel *lblFemale;

/*! @brief This is label for other */
@property (weak, nonatomic) IBOutlet UILabel *lblOther;


/*! @brief This is button to select gender Male */
@property (weak, nonatomic) IBOutlet UIButton *Male;

/*! @brief This is button to select gender Female */
@property (weak, nonatomic) IBOutlet UIButton *Female;

/*! @brief This is button to select gender Other */
@property (weak, nonatomic) IBOutlet UIButton *Other;

@end
