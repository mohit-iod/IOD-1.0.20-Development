//
//  FileViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 10/15/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *strFilePath;
@property (nonatomic, retain) NSString *strTitle;
@property BOOL *hideMenu;

@end
