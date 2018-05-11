//
//  DocumentPickerViewController.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/31/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "DocumentPickerViewController.h"
#import "UIColor+HexString.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UploadDocCell.h"


#define kStringDocumentPickerTitle @"Select Document"
#define kStringDocumentPickerCancel @"Cancel"
#define kStringImagePickerCreateImage @"Create"
#define kStringImagePickerChooseImage @"Choose Image"
#define kStringImagePickerChooseImageOtherSource @"Choose other source"

#define kMaxRatio 1.5
#define kMaxImageSelectionCount 8
#define kMINIMUM_IMAGE_WIDTH 320
#define kMAXIMUM_IMAGE_WIDTH 600
#define kMAXIMUM_IMAGE_HEIGHT 600


@interface DocumentPickerViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *selectDocumentView;
@property (weak, nonatomic) IBOutlet UIButton *addDocumentButton;
@property (nonatomic, strong) NSMutableArray *documentArray;
@property (nonatomic, strong) NSMutableArray *imageViewCache;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintImgButton_ViewX;
@property (nonatomic) CGFloat xValue;
@property (nonatomic, strong) UIImageView *favoriteImageView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UICollectionView *documentCollecctionView;

@end

@implementation DocumentPickerViewController
@synthesize popoverControllerView;
@synthesize documentArray = _documentArray;

bool isLastImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.documentCollecctionView registerNib:[UINib nibWithNibName:@"UploadDocCell" bundle:nil] forCellWithReuseIdentifier:@"photoUploadCell"];
    self.documentArray = [[NSMutableArray alloc]init];
    [self addFirstImage];
    
}

-(void)addFirstImage {
    NSMutableDictionary *dicFirstImage = [[NSMutableDictionary alloc]init];
    [dicFirstImage setObject:[UIImage imageNamed:@"Upload-btn.png"] forKey:@"documentImage"];
    [dicFirstImage setObject:@"YES" forKey:@"isLast"];
    isLastImage = YES;
    [self.documentArray addObject:dicFirstImage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)deleteImage:(UIButton *)sender {
    [self.documentArray removeObjectAtIndex:sender.tag];
    if (self.documentArray.count == 4) {
        NSDictionary *dic = [self.documentArray lastObject];
        if (![[dic valueForKey:@"isLast"] isEqualToString:@"YES"])
            [self addFirstImage];
    }
    if (self.documentArray.count == 0) {
        [self addFirstImage];
    }
    [self.documentCollecctionView reloadData];
}
- (void)addImage:(UIImage *)image andExtension: (NSString *)extension
{
    [self.documentArray removeLastObject];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:image forKey:@"documentImage"];
    [dic setObject:@"NO" forKey:@"isLast"];
    [self.documentArray addObject:dic];
    if(self.documentArray.count < 5)
     [self addFirstImage];
        isLastImage = YES;
    [self.documentCollecctionView reloadData];
}

-(void)setUpActionSheetsWithSender:(id) sender {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Document upload option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Select Camera",
                                @"Select Galllery",
                                @"Select Document",
                                nil];
        popup.tag = 1;
        [popup showInView:self.view];
}

# pragma mark Delegates for Action sheet.
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self takePhoto];
                    break;
                case 1:
                    [self selectPhoto];
                    break;
                case 2:
                    [self selectDocument];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)takePhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}
-(void) selectDocument {
    NSArray *types = @[(NSString*)kUTTypePDF,(NSString*)kUTTypeImage];
    //Create a object of document picker view and set the mode to Import
    UIDocumentPickerViewController *docPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeImport];
    //Set the delegate
    docPicker.delegate = self;
    //present the document picker
    [self presentViewController:docPicker animated:YES completion:nil];
}

- (void)selectPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
     self.imageView.image = chosenImage;
    [self addImage:chosenImage andExtension:@"png"];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Collection view delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.documentArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80,80);
}

-(UploadDocCell  *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UploadDocCell *cell=(UploadDocCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"photoUploadCell" forIndexPath:indexPath];
    cell.uploadButon.backgroundColor = [UIColor grayColor];
    [cell.uploadButon setTag:indexPath.row];
    [cell.deleteButton setTag:indexPath.row];
    
    UIImage *img = [[self.documentArray objectAtIndex:indexPath.row] valueForKey:@"documentImage"];
    NSString *isLast =[[self.documentArray objectAtIndex:indexPath.row] valueForKey:@"isLast"];
    [cell.uploadButon setBackgroundImage:img forState:UIControlStateNormal];
    [cell.uploadButon addTarget:self action:@selector(setUpActionSheetsWithSender:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    if([isLast isEqualToString:@"YES"]) {
        [cell.deleteButton setHidden:YES];
        [cell.uploadButon setUserInteractionEnabled:YES];
    }
    else {
        [cell.deleteButton setHidden:NO];
        [cell.uploadButon setUserInteractionEnabled:NO];
    }
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}




@end
