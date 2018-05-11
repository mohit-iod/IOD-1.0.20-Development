//
//  MedicalInfoDropDownVIews.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/8/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

 @protocol delegateDropDownView <NSObject>
-(void)ViewClickedName:(NSString *)viewTitle setHidden:(BOOL)hideViewBelow;
@end

@interface MedicalInfoDropDownVIews : UIView
{
    UIImageView *imageDropDown;
    UILabel *lblMedViewDropDown;
}
@property (weak,nonatomic)  IBOutlet id <delegateDropDownView>delegateV;
@property ( nonatomic) IBInspectable  NSString *strDropDownLbl;
@property ( nonatomic) IBInspectable  UIColor *lineColor;
@property ( nonatomic) IBInspectable  UIImage *selectedImage;
@end
