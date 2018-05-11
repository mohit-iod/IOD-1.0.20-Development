//
//  IODregisterView.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/27/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "IODregisterView.h"

@implementation IODregisterView 

//-(instancetype)init{
//    UILabel *labelError=[UILabel new];
//    [labelError setFrame:CGRectMake(8, self.frame.size.height-13, self.frame.size.width, 10)];
//    labelError.tag=10;
//    //labelError.text=@"sdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdf";
//    [labelError setFont:[UIFont systemFontOfSize:8]];
//    [labelError setTextAlignment:NSTextAlignmentLeft];
//    [labelError setTextColor:[UIColor redColor]];
//    
//    [self addSubview:labelError];
//    
//    return  self;
//}
-(instancetype)init{
   
    return self;
}
-(void)drawRect:(CGRect)rect{
    
    
    
    UILabel *labelError=[UILabel new];
    [labelError setFrame:CGRectMake(44, self.frame.size.height-13, self.frame.size.width, 10)];
    labelError.tag=10;
     //labelError.text=@"sdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdf";
    [labelError setFont:[UIFont systemFontOfSize:9]];
    [labelError setTextAlignment:NSTextAlignmentLeft];
    [labelError setTextColor:[UIColor redColor]];
    [self addSubview:labelError];
    
    
    
    UILabel *labelPlaceholder=[UILabel new];
    [labelPlaceholder setFrame:CGRectMake(44, self.frame.size.height-50, self.frame.size.width, 15)];
    labelPlaceholder.tag=11;
    //labelError.text=@"sdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdf";
    [labelPlaceholder setFont:[UIFont systemFontOfSize:10]];
    [labelPlaceholder setTextAlignment:NSTextAlignmentLeft];
    [labelPlaceholder setTextColor:[UIColor lightGrayColor]];
    [labelPlaceholder setBackgroundColor:[UIColor clearColor]];
    [self addSubview:labelPlaceholder];

    for (UITextField *txt in self.subviews) {
        if ([txt isKindOfClass:[UITextField class]] && (txt.tag == 111)) {
            txt.autocorrectionType=UITextAutocorrectionTypeNo;
            
            if([txt.placeholder caseInsensitiveCompare:@"date of birth*"]== NSOrderedSame|| [txt.placeholder caseInsensitiveCompare:@"Date Of Birth*"]== NSOrderedSame  ||[txt.placeholder caseInsensitiveCompare:@"date of birth"]== NSOrderedSame||[txt.placeholder caseInsensitiveCompare:@"country"]== NSOrderedSame||[txt.placeholder caseInsensitiveCompare:@"state"]== NSOrderedSame||[txt.placeholder caseInsensitiveCompare:@"city"]== NSOrderedSame||[txt.placeholder caseInsensitiveCompare:@"language known"]== NSOrderedSame||[txt.placeholder caseInsensitiveCompare:@"qualification year*"]== NSOrderedSame||[txt.placeholder caseInsensitiveCompare:@"blood group"]== NSOrderedSame||[txt.placeholder caseInsensitiveCompare:@"licence to practice in state*"]== NSOrderedSame||[txt.placeholder caseInsensitiveCompare:@"specialization*"]== NSOrderedSame||[txt.placeholder caseInsensitiveCompare:@"experince"]== NSOrderedSame||[txt.placeholder caseInsensitiveCompare:@"direction"]== NSOrderedSame||[txt.placeholder caseInsensitiveCompare:@"Date"]== NSOrderedSame||[txt.placeholder caseInsensitiveCompare:@"dosage"]== NSOrderedSame)
            {
                
                txt.inputAccessoryView = [[UIView alloc] init];
            }
        }
        
        
        
        if([txt isKindOfClass:[UITextField class]] && (txt.tag == 11)){
            txt.delegate = self;
        }
        
    }
// [super drawRect:rect];
}




@end
