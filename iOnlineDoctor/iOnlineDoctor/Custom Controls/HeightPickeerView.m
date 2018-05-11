//
//  HeightPickeerView.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/17/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "HeightPickeerView.h"
#import "UIColor+HexString.h"

@interface HeightPickeerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, readwrite) NSString *component1Value;
@property (nonatomic, readwrite) NSString *component2Value;

@property (nonatomic, assign) NSInteger selectedComponent1Row;
@property (nonatomic, assign) NSInteger selectedComponent2Row;


@end
@implementation HeightPickeerView


-(void)setPreSelectedComponent1Value:(NSString *)preSelectedComponent1Value {
    _preSelectedComponent1Value = preSelectedComponent1Value;
    if(self.component1 && self.component1.count >0) {
        [self selectComponent1PreSelectedValue];
    }
}


-(void)setPreSelectedComponent2Value:(NSString *)preSelectedComponent2Value {
    _preSelectedComponent2Value = preSelectedComponent2Value;
    if(self.component2 && self.component2.count >0) {
        [self selectComponent2PreSelectedValue];
    }
}
- (void)setComponent1:(NSArray *)component1{
    _component1 = component1;
    if(self.component1 && self.component1.count >0 && self.preSelectedComponent1Value) {
        [self selectComponent1PreSelectedValue];
        
    }
}

-(void)setComponent2:(NSArray *)component2 {
    _component2 = component2;
    if(self.component2 && self.component2.count >0 && self.preSelectedComponent2Value) {
        [self selectComponent2PreSelectedValue];
        
    }
}

-(void)setSelectedComponent1Row:(NSInteger)selectedComponent1Row{
    _selectedComponent1Row = selectedComponent1Row;
    if(self.component1 && self.component1.count>0) {
        self.component1Value= [self.component1 objectAtIndex:_selectedComponent1Row];
    }
}
-(void)setSelectedComponent2Row:(NSInteger)selectedComponent2Row{
    _selectedComponent2Row = selectedComponent2Row;
    if(self.component2 && self.component2.count>0) {
        self.component2Value= [self.component2 objectAtIndex:_selectedComponent2Row];
    }
}

- (void)selectComponent1PreSelectedValue{
    for( NSString *str in self.component1 ){
        if ( [self.preSelectedComponent1Value isEqualToString:str] ){
            NSInteger index = [self.component1 indexOfObject:str];
            self.selectedComponent1Row = index;
            [self.pickerView selectRow:index inComponent:0 animated:false];
            return;
        }
    }
}
- (void)selectComponent2PreSelectedValue{
    for( NSString *str in self.component2 ){
        if ( [self.preSelectedComponent2Value isEqualToString:str] ){
            NSInteger index = [self.component2 indexOfObject:str];
            self.selectedComponent2Row = index;
            [self.pickerView selectRow:index inComponent:0 animated:false];
            return;
        }
    }
}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if( self ){
        self.selectedComponent1Row = 0;
        self.selectedComponent2Row = 0;

        self.preSelectedComponent1Value = nil;
        self.preSelectedComponent2Value = nil;
        
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    //    self.layer.borderColor = [UIColor colorWithHexString:@"CC003E"].CGColor;
    //    self.layer.borderWidth = 1.0;
    
    CGSize buttonSize = CGSizeMake(SCREEN_WIDTH/2, 44);
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.doneButton addTarget:self
                        action:@selector(onDoneButton:)
              forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(CGRectGetMaxX(self.doneButton.frame), 0, buttonSize.width, buttonSize.height);
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self
                          action:@selector(onCancelButton:)
                forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelButton.backgroundColor = self.doneButton.backgroundColor = [UIColor colorWithHexString:kDoneButton];
    self.doneButton.titleLabel.textColor = self.cancelButton.titleLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:self.doneButton];
    [self addSubview:self.cancelButton];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 42, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 40)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self addSubview:self.pickerView];
}

- (void)onDoneButton:(UIButton*)button{
    //Component 1
    if( self.component1 && self.component1.count >  0 ){
        self.component1Value = [self.component1 objectAtIndex:self.selectedComponent1Row];
        _selectedcomponent1Id = (int) self.selectedComponent1Row ;
        
        
        
        //Component 2
        if( self.component2 && self.component2.count >  0 ){
            
            if (!(self.selectedComponent2Row>=0)) {
                self.selectedComponent2Row = 0;
            }
            
            self.component2Value = [self.component2 objectAtIndex:self.selectedComponent2Row];
            
            _selectedcomponent2Id = (int) self.selectedComponent2Row ;
        }

    }
    if( self.delegate && [self.delegate respondsToSelector:@selector(heightPickerViewDidSelectDone:)] ){
        [self.delegate heightPickerViewDidSelectDone:self];
    }
       if( self.delegate && [self.delegate respondsToSelector:@selector(heightPickerViewDidSelectDone:)] ){
        [self.delegate heightPickerViewDidSelectDone:self];
    }
}


- (void)onCancelButton:(UIButton*)button{
    if( self.delegate && [self.delegate respondsToSelector:@selector(heightPickerViewDidSelectCancel:)] ){
        [self.delegate heightPickerViewDidSelectCancel:self];
    }
}

#pragma mark - UIPickerViewDelegate/UIPickerViewDataSource

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(component == 0) {
        return [self.component1 objectAtIndex:row];
    }
    else if(component ==1)
    {
    return [self.component2 objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.selectedComponent1Row = row;
    }
    else if(component ==1) {
        self.selectedComponent2Row = row;
    }

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    return self.data.count;
    if(component == 0 ){
         return self.component1.count;
    }
    else if (component == 1){
         return self.component2.count;
    }
    return 1;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

@end
