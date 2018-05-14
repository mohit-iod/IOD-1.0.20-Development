//
//  BlogsDetailViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 2/1/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "BlogsDetailViewController.h"
#import "DoctorAppointmentServiceHandler.h"

@interface BlogsDetailViewController ()

@end

@implementation BlogsDetailViewController

#pragma mark - View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIActivityIndicatorView *activity;
    [super viewDidLoad];
    
    self.title=@"";
    if (self.strTitle.length>0) {
        self.title=self.strTitle;
    }
    [self.navigationController setNavigationBarHidden:FALSE animated:FALSE];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
}

- (void)viewWillAppear:(BOOL)animated{
    NSURL *url = [NSURL URLWithString:self.strFilePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

#pragma mark - Webview Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
