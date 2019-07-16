//
//  ImageViewController.h
//  Montage
//
//  Created by MacBookPro on 4/25/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"
#import "FGalleryViewController.h"
#import "SPUserResizableView.h"
#import <OneDriveSDK/OneDriveSDK.h>

@interface ImageViewController : UIViewController<FGalleryViewControllerDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *pageViewImgView;

@property (strong, nonatomic) IBOutlet UIView *firstView;

@property (strong, nonatomic) IBOutlet UIView *secondView;

@property (strong, nonatomic) IBOutlet UIView *pageView;

@property (strong, nonatomic) IBOutlet UIView *collectView;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIView *socialView;

@property (strong,nonatomic) IBOutlet UIButton *glcButton;

@property (strong, nonatomic) IBOutlet UIView *topSocialView;

@property (strong, nonatomic) IBOutlet UIView *socialList;

- (IBAction)fromLocal:(id)sender;

- (IBAction)facebook:(id)sender;

- (IBAction)instagram:(id)sender;

- (IBAction)dropBox:(id)sender;

- (IBAction)flickr:(id)sender;

- (IBAction)fromCamera:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *fromCameraBtn;

@property (strong, nonatomic) UIView* BlurView;
@property (strong, nonatomic) UIWindow* currentWindow;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthContraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *hghtCnst;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *wdthCnst;

@property (strong, nonatomic) SPUserResizableView *OpenCameraSPUsrRzbleVw;
@property (strong, nonatomic) UIImageView *OpenCmraImgViw;

@property (strong, nonatomic) ODClient *client;

- (IBAction)OneDrive:(id)sender;

- (IBAction)Box:(id)sender;

- (IBAction)GoogleDrive:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *ADView;

@end
