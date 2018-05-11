//
//  EVisitVCViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/16/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "EVisitVCViewController.h"
#import "CommonServiceHandler.h"
#import "invoiceCell.h"
@interface EVisitVCViewController ()
{
    NSArray *arrPatientList;
}
@end

@implementation EVisitVCViewController

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINib *nib = [UINib nibWithNibName:@"invoiceCell" bundle:[NSBundle mainBundle]];
    [[self tblPatientlist] registerNib:nib forCellReuseIdentifier:@"paymentCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mrk Tableview

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrPatientList.count;
}

-(invoiceCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    invoiceCell *cell=[tableView dequeueReusableCellWithIdentifier:@"paymentCell" ];
     cell.txtLabel.text = @"dsfsdf";
    //  cell.titleLAbel.text =[[arrCategory objectAtIndex:indexPath.row] valueForKey:@"name"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.transform = CGAffineTransformMakeTranslation(0.f, cell.frame.size.height);
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    //2. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.transform = CGAffineTransformMakeTranslation(0.f, 0);
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark API
-(void)getAllPatientList {
    CommonServiceHandler *service = [[CommonServiceHandler alloc]init];
    [service getAllPatienVisit:nil WithCompletionBlock:^(NSArray *array, NSError *error) {
        if(array.count > 0){
            arrPatientList = [NSArray arrayWithArray:array];
            //NSLog(@"arrPatientList is %@",arrPatientList);
        }
    }];
}


@end
