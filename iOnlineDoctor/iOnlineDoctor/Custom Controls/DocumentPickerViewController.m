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
#import "RegistrationService.h"
#import "PatientAppointService.h"

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

@implementation DocumentPickerViewController {
    RegistrationService *regServCall;
    PatientAppointService *patServCall;
}
@synthesize popoverControllerView;
@synthesize documentArray = _documentArray;

bool isLastImage;
bool isCamera;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.documentCollecctionView registerNib:[UINib nibWithNibName:@"UploadDocCell" bundle:nil] forCellWithReuseIdentifier:@"photoUploadCell"];
    self.documentArray = [[NSMutableArray alloc]init];
    [self addFirstImage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCollectionview:) name:@"reloadCollectionview" object:nil];
    
}

- (void)reloadCollectionview:(NSNotification *)notif
{
    regServCall.imageData = [[NSMutableArray alloc] init];
    patServCall.arrDocumentData = [[NSMutableArray alloc] init];
    
    self.documentArray = [[NSMutableArray alloc]init];
    [self addFirstImage];
    [self.documentCollecctionView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    regServCall=[RegistrationService sharedManager];
    patServCall = [PatientAppointService sharedManager];
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
    //  regServCall.imageData = [NSArray arrayWithObject:image];
    
    [regServCall.imageData removeObjectAtIndex:sender.tag];
    [patServCall.arrDocumentData removeObjectAtIndex:sender.tag];
    [patServCall.documentName removeObjectAtIndex:sender.tag];
    [patServCall.arrDocType removeObjectAtIndex:sender.tag];
    [regServCall.arrDocType removeObjectAtIndex:sender.tag];
    [regServCall.nameArray removeObjectAtIndex:sender.tag];
    
    if (self.documentArray.count == 9) {
        NSDictionary *dic = [self.documentArray lastObject];
        if (![[dic valueForKey:@"isLast"] isEqualToString:@"YES"])
            [self addFirstImage];
    }
    if (self.documentArray.count == 0) {
        [self addFirstImage];
    }
    [self.documentCollecctionView reloadData];
  //  NSLog(@"Parent view Controller of Document Picker view Controller is %@", self.parentViewController);
    
    [self.parentViewController viewWillAppear:YES];

   // [self.parentViewController respondsToSelector:@selector(sd:)];
    
}

-(void)addDocumentToArray:(NSURL*)docURL andExtension:(NSString*)extension
{
    NSData * docData = [NSData dataWithContentsOfURL:docURL];
    [self.documentArray removeLastObject];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:docData forKey:@"document"];
    [dic setObject:@"NO" forKey:@"isLast"];
    [dic setObject:@"NO" forKey:@"ISImage"];
    [dic setObject:extension forKey:@"Extenstion"];
    [self.documentArray addObject:dic];
    if(self.documentArray.count < 10)
        [self addFirstImage];
    isLastImage = YES;
    
    [regServCall.imageData addObject:docData];
    [patServCall.arrDocumentData addObject:docData];
    [patServCall.documentName addObject:@"documents[]"];
    [regServCall.nameArray addObject:@"documents[]"];
    [patServCall.arrDocType addObject:extension];
    [regServCall.arrDocType addObject:extension];
    [self.documentCollecctionView reloadData];
    
    dispatch_async (dispatch_get_main_queue (), ^{
        NSInteger section = [self.documentCollecctionView numberOfSections] - 1;
        NSInteger item = [self.documentCollecctionView numberOfItemsInSection:section] - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        [self.documentCollecctionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    });
}

- (void)addImage:(UIImage *)image andExtension: (NSString *)extension
{
    [self.documentArray removeLastObject];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:image forKey:@"documentImage"];
    [dic setObject:@"NO" forKey:@"isLast"];
    [dic setObject:@"YES" forKey:@"ISImage"];
    [dic setObject:@"NO" forKey:@"Extenstion"];
    [self.documentArray addObject:dic];
    if(self.documentArray.count < 10)
        [self addFirstImage];
    isLastImage = YES;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
    [regServCall.imageData addObject:imageData];
    [patServCall.arrDocumentData addObject:imageData];
    [patServCall.documentName addObject:@"documents[]"];
    [regServCall.nameArray addObject:@"documents[]"];
    [patServCall.arrDocType addObject:@"Image"];
    [regServCall.arrDocType addObject:@"Image"];
    [self.documentCollecctionView reloadData];

    dispatch_async (dispatch_get_main_queue (), ^{
          NSInteger section = [self.documentCollecctionView numberOfSections] - 1;
            NSInteger item = [self.documentCollecctionView numberOfItemsInSection:section] - 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        [self.documentCollecctionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    });
}

- (NSString *)base64String: (UIImage *)image {
    NSData * data = [ UIImageJPEGRepresentation(image, 0.2) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return [NSString stringWithUTF8String:[data bytes]];
}

-(void)setUpActionSheetsWithSender:(id) sender {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select Media Type" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIPopoverPresentationController *popover = actionSheet.popoverPresentationController;
        if (popover)
        {
            popover.sourceView = sender;
            UIButton  *button = (UIButton *)sender;
            popover.sourceRect = button.frame;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            // Cancel button tappped.
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Select Gallery" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self selectPhoto];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Select Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self takePhoto];
        }]];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Upload Document" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self uploadDocument];
        }]];
        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    else {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle: @"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Select Gallery",
                                @"Select Camera",
                                @"Upload Document",
                                nil];
        popup.tag = 1;
        [popup showInView:self.view];
    }
    
}

# pragma mark Delegates for Action sheet.
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self selectPhoto];
                    break;
                case 1:
                    [self takePhoto];
                    break;
                case 2:
                    [self uploadDocument];
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

- (void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    isCamera = YES;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)selectPhoto {
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    isCamera = NO;
//    picker.allowsEditing = NO;
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:picker animated:YES completion:NULL];
    [self launchController];
}

//To Upload Document
-(void)uploadDocument
{
    NSArray *typeArray = @[(NSString*)kUTTypeImage,(NSString*)kUTTypeContent];
    
    /*only for iCloud
    UIDocumentPickerViewController * docPicker = [[UIDocumentPickerViewController alloc]initWithDocumentTypes:typeArray inMode:UIDocumentPickerModeImport];
    docPicker.delegate = self;
    [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
    [self presentViewController:docPicker animated:true completion:nil];*/
    
    //For DropBox, icloud, Goolge Drive etc
    self.docMenuController = [[UIDocumentMenuViewController alloc]initWithDocumentTypes:typeArray inMode:UIDocumentPickerModeImport];
    self.docMenuController.delegate = self;
    [self presentViewController:self.docMenuController animated:true completion:nil];
}

#pragma mark - Document Menu Picker Delegate

- (void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker
{
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:true completion:nil];
}

#pragma mark - Document Picker Delegate

-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    if(controller.documentPickerMode == UIDocumentPickerModeImport){
        NSLog(@"URL is:%@",url);
        NSLog(@"Successfully Imported:%@",[url lastPathComponent]);
        NSArray * tmpArray = [[url lastPathComponent]componentsSeparatedByString:@"."];
        NSLog(@"tmpArray is:%@",tmpArray);
        
        NSArray * supportedExtension = @[@"png",@"jpg",@"jpeg",@"pdf",@"doc",@"docx"];
        if ([supportedExtension containsObject:[tmpArray lastObject]]){
            [self addDocumentToArray:url andExtension:[tmpArray lastObject]];
        }
        else{
              [IODUtils showFCAlertMessage:@"You can't Upload this file, You can only upload Image/PDF/Word Files" withTitle:@"" withViewController:self with:@"error"];
           //
          //  [IODUtils showMessage:@"You can't Upload this file, You can only upload Image/PDF/Word Files" withTitle:@"Error"];
        }
        [controller dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = chosenImage;
    [self addImage:chosenImage andExtension:@"jpeg"];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    if(isCamera){
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Collection view delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.documentArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(60,60);
}

-(UploadDocCell  *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UploadDocCell *cell=(UploadDocCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"photoUploadCell" forIndexPath:indexPath];
    cell.uploadButon.backgroundColor = [UIColor grayColor];
    [cell.uploadButon setTag:indexPath.row];
    [cell.deleteButton setTag:indexPath.row];
    
    UIImage *img;
    NSString * isPDF = [[self.documentArray objectAtIndex:indexPath.row] valueForKey:@"ISImage"];
    if([isPDF isEqualToString:@"NO"]){
        NSString * ext = [[self.documentArray objectAtIndex:indexPath.row] valueForKey:@"Extenstion"];
        if([ext isEqualToString:@"pdf"])
            img = [UIImage imageNamed:@"Upload-pdf.png"];
        else if([ext isEqualToString:@"doc"] || [ext isEqualToString:@"docx"])
            img = [UIImage imageNamed:@"Upload-doc.png"];
        else if([ext isEqualToString:@"png"] || [ext isEqualToString:@"jpg"] || [ext isEqualToString:@"jpeg"])
            img = [UIImage imageNamed:@"Upload-img.png"];
    }
    else{
        img = [[self.documentArray objectAtIndex:indexPath.row] valueForKey:@"documentImage"];
    }
    
    NSString *isLast =[[self.documentArray objectAtIndex:indexPath.row] valueForKey:@"isLast"];
    [cell.uploadButon setBackgroundImage:img forState:UIControlStateNormal];
    [cell.uploadButon setBackgroundColor:[UIColor clearColor]];
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

-(NSString *)imageToNSString:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
    return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

-(UIImage *)stringToUIImage:(NSString *)string
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string
                                                      options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

#pragma mark ELCImagePickerControllerDelegate Methods
- (IBAction)launchController
{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.maximumImagesCount = 11 - _documentArray.count; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
//    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image
    elcPicker.imagePickerDelegate = self;
  //  [self.parentViewController presentViewController:elcPicker animated:YES completion:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self.parentViewController presentViewController:elcPicker animated:YES completion:nil];
    });
    
}


- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage *chosenImage = [dict objectForKey:UIImagePickerControllerOriginalImage];
                self.imageView.image = chosenImage;
                [self addImage:chosenImage andExtension:@"jpeg"];
                [picker dismissViewControllerAnimated:YES completion:NULL];
            } 
        }
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
