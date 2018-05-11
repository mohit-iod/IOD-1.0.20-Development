//
//  FileViewerVC.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 10/10/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "ViewController.h"

@interface FileViewerVC : ViewController
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *strFilePath;
@property (nonatomic, retain) NSString *strTitle;
@property BOOL *hideMenu;

@end
