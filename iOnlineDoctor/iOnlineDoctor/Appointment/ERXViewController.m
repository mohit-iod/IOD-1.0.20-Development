//
//  ERXViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/17/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "ERXViewController.h"
#import "DoctorAppointmentServiceHandler.h"
#import "CommonServiceHandler.h"
#import "IODUtils.h"
@interface ERXViewController ()
{
    DoctorAppointmentServiceHandler *docService;
}
@end

@implementation ERXViewController
{
    NSInteger RowsPrescribeAdded;
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    ERXContainerInfoVC *ERXView=(ERXContainerInfoVC *)segue.destinationViewController;
    
    
    ERXView.delegateERX=self;
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
        _viewAddPrescribtion.hidden=YES;
    RowsPrescribeAdded=0;
    docService = [DoctorAppointmentServiceHandler sharedManager];


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark container Delegate
-(void)CancelSontainer{
    [UIView transitionWithView:_viewAddPrescribtion
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        
                        
                        
                        _viewAddPrescribtion.hidden=YES;
                        
                    }
                    completion:NULL];
}

-(void)addPrecription:(NSDictionary *)dataDictValues{
    
    
    
}


#pragma mark tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _viewAddPrescribtion.frame.size.height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return _viewAddPrescribtion;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return RowsPrescribeAdded;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PrescribeCell" forIndexPath:indexPath];
    
    cell.textLabel.text=[NSString stringWithFormat:@"added prescribe%lu",indexPath.row ];
    
    cell.backgroundColor=[UIColor lightGrayColor];
 
    return cell;
}

- (IBAction)addPrescribAction:(id)sender {
    [UIView transitionWithView:_viewAddPrescribtion
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                    
                        
                        
                        _viewAddPrescribtion.hidden=NO;
                        
                    }
                    completion:NULL];

    
    
}

- (IBAction)btnSubmitAction:(id)sender {
    
    [UIView transitionWithView:_viewAddPrescribtion
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        
                        
                        
                        _viewAddPrescribtion.hidden=YES;
                        
                    }
                    completion:NULL];
    
    RowsPrescribeAdded=RowsPrescribeAdded+1;
    
 //   [_tblPrestcriptions reloadData];
}

-(void)getAllEPrescription {
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:docService.visit_id forKey:@"visitId"];
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
    [service getPrescription:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        
        if(responseCode) {
            NSLog(@"Response code %@", responseCode);
        }
    }];
        
    }else{
        [IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
    
}
@end
