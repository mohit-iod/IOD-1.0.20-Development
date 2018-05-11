//
//  HealthConditionViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 3/1/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "HealthConditionViewController.h"
#import "VitalsViewController.h"
#import "PatientAppointService.h"
#import "AppDelegate.h"

@interface HealthConditionViewController () <UITableViewDataSource,UITabBarDelegate,HealthConditionDelegate>{
    UIBarButtonItem *btnNext;
    PatientAppointService *patientService;
    VitalsViewController *hvc;
    
}
@property (nonatomic,strong) NSMutableArray *arrSelected;

@end

@implementation HealthConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [_tblOptions.layer setBorderColor:[UIColor colorWithHexRGB:kBorderColor].CGColor];
    [_tblOptions.layer  setBorderWidth:1.0];
    [_tblOptions.layer setCornerRadius:6.0];
    self.title = @"Medical Info";
     hvc =  [self.storyboard instantiateViewControllerWithIdentifier:@"VitalsViewController"];

    patientService = [PatientAppointService sharedManager];
    if (![patientService.question_6 isEqualToString:@""]) {
        NSArray *languagesuserArray = [patientService.question_6 componentsSeparatedByString:@","];
        self.arrSelected = [languagesuserArray mutableCopy];
    }
    else{
        self.arrSelected = [[NSMutableArray alloc] init];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSDictionary *dicthealthCondition = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"healthConditions" ofType:@"json"]];
    self.arrOptions= [dicthealthCondition valueForKey:@"healhCondition"];
    [_tblOptions reloadData];
    
    if (!self.multiSelectCellBackgroundColor)
        self.multiSelectCellBackgroundColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0];
    
    if (!self.tableTextColor)
        self.tableTextColor = [UIColor blackColor];
    
    if (!self.multiSelectTextColor)
        self.multiSelectTextColor = [UIColor whiteColor];
    
    btnNext = [[UIBarButtonItem alloc] initWithTitle:kSkip style:UIBarButtonItemStyleDone target:self action:@selector(goNextPage:)];
    self.navigationItem.rightBarButtonItem = btnNext;
}

-(void) viewWillAppear:(BOOL)animated{
    [btnNext setEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* Update constraints for top layout */
-(void)updateViewConstraints
{
    [super updateViewConstraints];
    if ([self.arrSelected count]!=0)
        self.topLayoutConstraint.constant = 68;
    else
    self.topLayoutConstraint.constant = 0;
}

#pragma mark - Table view delegate and datasource methods.
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    return [self.arrOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    cell.textLabel.text = self.arrOptions[indexPath.row];
    cell.textLabel.textColor = self.tableTextColor;
    cell.backgroundColor = [UIColor clearColor];
    cell.tintColor = self.multiSelectCellBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.arrSelected containsObject:self.arrOptions[indexPath.row]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.arrSelected removeObject:self.arrOptions[indexPath.row]];
        [self.multiSelectCollectionView reloadData];
        [self.view setNeedsUpdateConstraints];
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.arrSelected addObject:self.arrOptions[indexPath.row]];
        [self.multiSelectCollectionView reloadData];
        [self.view setNeedsUpdateConstraints];
    }
    if(_arrSelected.count >0)
        [btnNext setTitle:kNext];
    else
        [btnNext setTitle:kSkip];
}


#pragma mark - Collectionview delegate and datasource method.
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.arrSelected count];
}

/*! @discussion This method is used to handle click event to go to next page  */

-(IBAction)goNextPage:(id)sender{
    NSString *strSelectedSymptoms;
    if(_arrSelected.count >0)
        strSelectedSymptoms  = [[_arrSelected valueForKey:@"description"] componentsJoinedByString:@","];
    else
        strSelectedSymptoms = @"";
    patientService.question_6 = strSelectedSymptoms;
    [btnNext setEnabled:NO];
    [self.navigationController pushViewController:hvc animated:YES];
}

/*!@discussion This method  is used to go to RootViewController/ Dashboard page!*/

-(IBAction)btnHomePressed:(id)sender{
    AppDelegate *appDelegate=( AppDelegate* )[UIApplication sharedApplication].delegate;
    [appDelegate updateStatus:@""];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
