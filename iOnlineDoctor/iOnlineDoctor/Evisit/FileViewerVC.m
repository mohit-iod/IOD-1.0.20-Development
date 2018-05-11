//
//  FileViewerVC.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 10/10/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "FileViewerVC.h"
#import "ColorsConstants.h"
#import "UIColor+HexString.h"
#import "DoctorAppointmentServiceHandler.h"
@interface FileViewerVC () <UIWebViewDelegate>

@end

@implementation FileViewerVC

{
    UIActivityIndicatorView *activity;
    DoctorAppointmentServiceHandler *docService;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.title = self.strTitle;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexRGB:kNavigatinBarColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
    docService = [DoctorAppointmentServiceHandler sharedManager];
    docService.isFromDocument = @"yes";
}


- (void) viewWillAppear:(BOOL)animated{
    
    NSURL *url = [NSURL URLWithString:self.strFilePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    _webView.delegate = self;
}

- (void) viewDidAppear:(BOOL)animated {

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];

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
