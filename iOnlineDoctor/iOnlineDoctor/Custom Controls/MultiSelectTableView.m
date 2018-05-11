//
//  MultiSelectTableView.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 4/11/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "MultiSelectTableView.h"
#import "Constants.h"

@interface MultiSelectTableView () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UIButton * doneButton;
@property(nonatomic,strong) UIButton * cancelButton;
@property(nonatomic,strong) UITableView * dataTable;

@end

@implementation MultiSelectTableView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.selectArray = [[NSMutableArray alloc]init];
        self.selectedData = [[NSMutableArray alloc]init];
        self.userDef = [NSUserDefaults standardUserDefaults];
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.frame = CGRectMake(0.0, 2.0, 70.0, 35.0);
    self.doneButton.backgroundColor = [UIColor colorWithHexString:kDoneButton];
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    self.doneButton.titleLabel.textColor = [UIColor whiteColor];
    [self.doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(self.frame.size.width - 70, 2.0, 70.0, 35.0);
    self.cancelButton.backgroundColor = [UIColor colorWithHexString:kDoneButton];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.textColor = [UIColor whiteColor];
    [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.dataTable = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 40.0, self.frame.size.width, self.frame.size.height - 40.0) style:UITableViewStylePlain];
    self.dataTable.allowsMultipleSelection = true;
    self.dataTable.tintColor = [UIColor colorWithHexString:kDoneButton];
    self.dataTable.delegate = self;
    self.dataTable.dataSource = self;
    
    UIView * tempView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 40.0)];
    tempView.backgroundColor = [UIColor colorWithHexString:kDoneButton];
    
    [tempView addSubview:self.doneButton];
    [tempView addSubview:self.cancelButton];
    [self addSubview:tempView];
    [self addSubview:self.dataTable];
    
}

-(void)setPreSelectData
{
    if(self.preSelectedValue){
        NSArray * tempArray = [self.preSelectedValue componentsSeparatedByString:@","];
        for (int i=0; i<[self.dataArray count]; i++){
            if ([tempArray containsObject:[self.dataArray objectAtIndex:i]]){
                [self.selectArray addObject:@"YES"];
                [self.selectedData addObject:[self.dataArray objectAtIndex:i]];
            }
            else{
                [self.selectArray addObject:@"NO"];
            }
        }
    }
    NSLog(@"Select Array is:-%@",self.selectArray);
}

-(void)doneButtonClicked:(UIButton*)button
{
    if([self.selectedData count]>0){
        for (int m=0; m <[self.selectedData count]; m++) {
            NSString * strTemp = [self.selectedData objectAtIndex:m];
            if (self.returnValue == nil){
                self.returnValue = strTemp;
            }
            else{
                self.returnValue = [NSString stringWithFormat:@"%@,%@",self.returnValue,strTemp];
            }
        }
    }
    NSLog(@"Return Value is:-%@",self.returnValue);
    if([self.delegate respondsToSelector:@selector(multiSelectTableviewDoneClick)]){
        [self.delegate multiSelectTableviewDoneClick];
    }
}

-(void)cancelButtonClicked:(UIButton*)button{
    if([self.delegate respondsToSelector:@selector(multiSelectTableviewCancelClick)]){
        [self.delegate multiSelectTableviewCancelClick];
    }
}

#pragma mark - TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PlainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    if([[self.selectArray objectAtIndex:indexPath.row] isEqualToString:@"YES"]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.transform = CGAffineTransformMakeTranslation(0.f, cell.frame.size.height);
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    //2. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.5];
    cell.transform = CGAffineTransformMakeTranslation(0.f, 0);
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectArray replaceObjectAtIndex:indexPath.row withObject:@"YES"];
        [self.selectedData addObject:[self.dataArray objectAtIndex:indexPath.row]];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectArray replaceObjectAtIndex:indexPath.row withObject:@"NO"];
        [self.selectedData removeObject:[self.dataArray objectAtIndex:indexPath.row]];
    }
    
    NSLog(@"Selected Data Array is:-%@",self.selectedData);
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectArray replaceObjectAtIndex:indexPath.row withObject:@"YES"];
        [self.selectedData addObject:[self.dataArray objectAtIndex:indexPath.row]];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectArray replaceObjectAtIndex:indexPath.row withObject:@"NO"];
        [self.selectedData removeObject:[self.dataArray objectAtIndex:indexPath.row]];
    }
    NSLog(@"Selected Data Array is:-%@",self.selectedData);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
