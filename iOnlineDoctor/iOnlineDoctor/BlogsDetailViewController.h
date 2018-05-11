//
//  BlogsDetailViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 2/1/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlogsDetailViewController : UIViewController
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *strFilePath;
@property (nonatomic, retain) NSString *strTitle;
@end
