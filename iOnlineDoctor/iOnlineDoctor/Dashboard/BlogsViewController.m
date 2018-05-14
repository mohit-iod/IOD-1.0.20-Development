//
//  BlogsViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 1/18/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "BlogsViewController.h"
#import "CommonServiceHandler.h"
#import "blogTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FileViewController.h"
#import "BlogsDetailViewController.h"

@interface BlogsViewController ()
{
    NSMutableArray *arrBlogs;
}

@end

@implementation BlogsViewController

#pragma mark - View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getAllBlogs];
    UINib *nib = [UINib nibWithNibName:@"blogTableViewCell" bundle:[NSBundle mainBundle]];
    [[self tblBlogs] registerNib:nib forCellReuseIdentifier:@"blogTableViewCell"];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:@"RefreshView" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:FALSE animated:FALSE];
}

#pragma mark - Void Methods

-(void)getAllBlogs{
    //Get List of All Blogs
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service getAllBlogs:nil WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        if([[responseCode objectForKey:@"status"] isEqualToString:@"success"]){
            arrBlogs = [responseCode valueForKey:@"data"];
            [_tblBlogs reloadData];
        }
    }];
}

#pragma mark - Tableview Delegate & Datasource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrBlogs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    blogTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"blogTableViewCell"];
    
    NSString *strThumbnail ;
    strThumbnail = [[arrBlogs objectAtIndex:indexPath.row] objectForKey:@"thumbnail"];
    if(strThumbnail == nil){
        strThumbnail = [[arrBlogs objectAtIndex:indexPath.row] objectForKey:@"thumbnail_landscape"];
    }
    [cell.imgBlog sd_setImageWithURL:[NSURL URLWithString:strThumbnail] placeholderImage:[UIImage imageNamed:@"small-no-img.png"]];
    
    cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[arrBlogs objectAtIndex:indexPath.row] valueForKey:@"post_title"]];
    
    //"post_date" = "2017-12-11 11:50:45";
    NSString *strAppointmentTime = [NSString stringWithFormat:@"%@",[[arrBlogs objectAtIndex:indexPath.row] valueForKey:@"post_date"]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *yourDate = [dateFormatter dateFromString:strAppointmentTime];
    yourDate = [IODUtils toLocalTime:yourDate];
    dateFormatter.dateFormat = @"MMM dd, yyyy ";
    strAppointmentTime =  [dateFormatter stringFromDate:yourDate];
    cell.lblDate.text = [NSString stringWithFormat:@"Posted on %@",strAppointmentTime];
    [cell.btnShare addTarget:self action:@selector(shareBlog:) forControlEvents:UIControlEventTouchUpInside];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FileViewController *fileViewMe  = [sb instantiateViewControllerWithIdentifier:@"FileViewController"];
    fileViewMe.strFilePath=[[arrBlogs objectAtIndex:indexPath.row] valueForKey:@"guid"];
    fileViewMe.strTitle=@"Blogs";
    [self.navigationController pushViewController:fileViewMe animated:YES];
}

#pragma mark - IBAction Methods

- (IBAction)shareBlog:(UIButton *)sender{
    int tag = sender.tag;
    NSString *url=[[arrBlogs objectAtIndex:tag] valueForKey:@"guid"];
    NSString * title =[NSString stringWithFormat:@"I am excited to share %@ blog from I Online Doctor Mobile App!",url];
    
    NSArray* dataToShare = @[title];
    UIActivityViewController* activityViewController =[[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [self presentViewController:activityViewController animated:YES completion:^{}];
}

#pragma mark - RefreshView Methods If Internet Connection Lost

-(void)refreshView:(NSNotification *) notification {
    [self getAllBlogs];
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshView" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
