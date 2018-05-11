//
//  SymptomsViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 2/28/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "SymptomsViewController.h"
#import "HealthIssueViewController.h"
#import "PatientAppointService.h"
#import "AppDelegate.h"


@interface SymptomsViewController ()<UITableViewDataSource,UITableViewDelegate,SymptomsViewControlDelegate>{
    UIBarButtonItem *btnNext;
    
    /*! An PatientAppointService  object. */
    PatientAppointService *patientService;
    
    /*! An HealthIssueViewController  object. */
    HealthIssueViewController *hvc;
    
}
@property (nonatomic,strong) NSMutableArray *arrSelected;
@end

@implementation SymptomsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    patientService = [PatientAppointService sharedManager];
   
    //set the title for the navigation bar.
    self.title = @"Medical Info";
    NSString *strSymptoms = UDGet(@"SelectedSymptoms");
    hvc =  [self.storyboard instantiateViewControllerWithIdentifier:@"HealthIssueViewController"];

    // Check if the symptoms are already selected
    if(strSymptoms != nil){
        NSArray *languagesuserArray = [strSymptoms componentsSeparatedByString:@","];
        NSLog(@"%@", languagesuserArray);
        self.arrSelected = [languagesuserArray mutableCopy];
    }
    else{
        self.arrSelected = [[NSMutableArray alloc] init];
    }
    [self setUserInterfaceForView];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [btnNext setEnabled:YES];
}

-(void)setUserInterfaceForView{
    
    [_tblOptions.layer setBorderColor:[UIColor colorWithHexRGB:kBorderColor].CGColor];
    [_tblOptions.layer  setBorderWidth:1.0];
    [_tblOptions.layer setCornerRadius:6.0];
    
    btnNext = [[UIBarButtonItem alloc] initWithTitle:kSkip style:UIBarButtonItemStyleDone target:self action:@selector(goNextPage:)];
    self.navigationItem.rightBarButtonItem = btnNext;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSDictionary *dictSymptoms = (NSDictionary *)[IODUtils loadJsonDataFromPath:[[NSBundle mainBundle]pathForResource:@"symptoms" ofType:@"json"]];
    self.arrOptions= [dictSymptoms valueForKey:@"symptoms"];
    [_tblOptions reloadData];
    
    if (!self.multiSelectCellBackgroundColor)
        self.multiSelectCellBackgroundColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0];
    
    if (!self.tableTextColor)
        self.tableTextColor = [UIColor blackColor];
    
    if (!self.multiSelectTextColor)
        self.multiSelectTextColor = [UIColor whiteColor];
}



-(void)updateViewConstraints
{
    [super updateViewConstraints];
    if ([self.arrSelected count]!=0)
        self.topLayoutConstraint.constant = 68;
    else
        self.topLayoutConstraint.constant = 0;
}

#pragma mark - Tableview delegate and data source methods.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    [[UITableViewCell appearance] setTintColor:[UIColor redColor]];
    cell.textLabel.text = self.arrOptions[indexPath.row];
    cell.textLabel.textColor = self.tableTextColor;
    cell.backgroundColor = [UIColor clearColor];
    cell.tintColor = self.multiSelectCellBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //Check if the value is selected , it it is selected show checkmark else remove check mark.
    if ([self.arrSelected containsObject:self.arrOptions[indexPath.row]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
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
    
    //Change the Title of button based on the symptom array counts
    if(_arrSelected.count >0)
        [btnNext setTitle:kNext];
    
    else
        [btnNext setTitle:kSkip];
}


#pragma mark - Collection view delegate and data source methods.
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.arrSelected count];
}

#pragma mark Naviagtion click events

/*! @discussion This method  is used to go to next view controller 
    * if the symptoms are selected the title will be next else it will be skip.  !*/

-(IBAction)goNextPage:(id)sender {
    NSString *strSelectedSymptoms = @"";
    if(_arrSelected.count >0) {
        strSelectedSymptoms  = [[_arrSelected valueForKey:@"description"] componentsJoinedByString:@","];
        [btnNext setTitle:kNext];
    }
    else{
        strSelectedSymptoms = @"";
    }
    patientService.question_2 = strSelectedSymptoms;
    UDSet(@"SelectedSymptoms", strSelectedSymptoms);
    [btnNext setEnabled:NO];
    [self.navigationController pushViewController:hvc animated:YES];
}

/*! @discussion This method  is used to go to RootViewController/ Home page.!*/
-(IBAction)btnHomePressed:(id)sender{
    AppDelegate *appDelegate=( AppDelegate* )[UIApplication sharedApplication].delegate;
    [appDelegate updateStatus:@""];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
