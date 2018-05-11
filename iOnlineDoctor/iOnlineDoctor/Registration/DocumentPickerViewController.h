//
//  DocumentPickerViewController.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/31/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentPickerViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate,UIDocumentPickerDelegate, UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

-(IBAction)setUpActionSheetsWithSender:(id) sender;

@property (nonatomic) NSInteger maxDocCount;
@property (strong, nonatomic) UIPopoverController *popoverControllerView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewDashbaord;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePic;

@end


