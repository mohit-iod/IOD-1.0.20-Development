//
//  FileViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 10/15/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "FileViewController.h"
#import "ColorsConstants.h"
#import "UIColor+HexString.h"

@interface FileViewController ()
{
    UIActivityIndicatorView *activity;
}
@end
@implementation FileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"";
    if (self.strTitle.length>0) {
        self.title=self.strTitle;
    }
    [self.navigationController setNavigationBarHidden:FALSE animated:FALSE];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSURL *url = [NSURL URLWithString:self.strFilePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _webView.delegate = self;
    [_webView loadRequest:request];
}

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

@end
