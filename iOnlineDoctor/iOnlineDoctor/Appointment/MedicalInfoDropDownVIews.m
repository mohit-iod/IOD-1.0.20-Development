//
//  MedicalInfoDropDownVIews.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/8/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "MedicalInfoDropDownVIews.h"
@implementation MedicalInfoDropDownVIews

//@dynamic  strDropDownLbl;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawRect:(CGRect)rect{
    self.backgroundColor=[UIColor lightGrayColor];
    UIImageView *imageQue= [UIImageView new];
    [imageQue setFrame:CGRectMake(20, self.frame.size.height/2-15, 25, 25)];
    if(self.selectedImage) {
        imageQue.image = self.selectedImage;
    }
    else {
        imageQue.image = [UIImage imageNamed:@"Qus-icon.png"];
    }
    [self addSubview:imageQue];
    
    UIImageView *bottomLine= [UIImageView new];
    [bottomLine setFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    if(self.lineColor){
          [bottomLine setBackgroundColor:self.lineColor];
    }
    else{
        [bottomLine setBackgroundColor:[UIColor lightGrayColor]];
    }
    [self addSubview:bottomLine];
    lblMedViewDropDown=[UILabel new];
    [lblMedViewDropDown setFrame:CGRectMake(60, 0, self.frame.size.width-(45+60), self.frame.size.height)];
    lblMedViewDropDown.font=[UIFont fontWithName:lblMedViewDropDown.font.fontName size:15];
 //   lblMedViewDropDown.textColor = [UIColor colorWithHexRGB:kNavigatinBarColor];
    lblMedViewDropDown.lineBreakMode=NSLineBreakByWordWrapping;
    lblMedViewDropDown.numberOfLines=0;
    lblMedViewDropDown.tag=10;
    //labelError.text=@"sdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdf";
    lblMedViewDropDown.text=self.strDropDownLbl;
    [lblMedViewDropDown setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lblMedViewDropDown];
    imageDropDown = [UIImageView new];
    
    [imageDropDown setFrame:CGRectMake(self.frame.size.width-45, self.frame.size.height/2-7.5, 15, 15)];
    [self addSubview:imageDropDown];
    
    
    UITapGestureRecognizer *tapDrop=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dropDownClicked)];
   // imageDropDown.backgroundColor=[UIColor redColor];
    imageDropDown.contentMode=UIViewContentModeScaleAspectFit;
    imageDropDown.image=[UIImage imageNamed:@"down-arrow-icon.png"];
    [self addGestureRecognizer:tapDrop];
    [self setUserInteractionEnabled:YES];
    
    UILabel *labelError=[UILabel new];
    [labelError setFrame:CGRectMake(60, self.frame.size.height-10, self.frame.size.width, 10)];
    labelError.tag=10;
   // labelError.text=@"error error error error error";
    //labelError.text=@"sdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdf";
    [labelError setFont:[UIFont systemFontOfSize:9]];
    [labelError setTextAlignment:NSTextAlignmentLeft];
    [labelError setTextColor:[UIColor redColor]];
    [self addSubview:labelError];
}

-(void)dropDownClicked{
    if([imageDropDown.image isEqual:[UIImage imageNamed:@"down-arrow-icon.png"]] ){
        
   imageDropDown.image=[UIImage imageNamed:@"up-arrow-icon.png"];
            [_delegateV ViewClickedName:lblMedViewDropDown.text setHidden:NO];
    }else{
           imageDropDown.image=[UIImage imageNamed:@"down-arrow-icon.png"];
            [_delegateV ViewClickedName:lblMedViewDropDown.text setHidden:YES];
    }
}

@end
