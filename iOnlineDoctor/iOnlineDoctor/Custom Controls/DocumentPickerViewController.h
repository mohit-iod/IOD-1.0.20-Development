//
//  DocumentPickerViewController.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/31/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"

@class DocumentPickerViewController;
@protocol documentPickerDelegate <NSObject>
- (void )deleteImageCount:(int)imagecount;

@end

@interface DocumentPickerViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate,UIDocumentPickerDelegate, UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,ELCImagePickerControllerDelegate,UIDocumentMenuDelegate>

-(IBAction)setUpActionSheetsWithSender:(id) sender;

@property (nonatomic) NSInteger maxDocCount;
@property (strong, nonatomic) UIPopoverController *popoverControllerView;
@property (strong, nonatomic) id <documentPickerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewDashbaord;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePic;

@property(nonatomic,strong) UIDocumentPickerViewController * docPicker;
@property(nonatomic,strong) UIDocumentMenuViewController * docMenuController;

@end


