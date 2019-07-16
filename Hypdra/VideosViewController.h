//
//  VideosViewController.h
//  Montage
//
//  Created by MacBookPro on 4/26/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"
#import "SPUserResizableView.h"
#import <OneDriveSDK/OneDriveSDK.h>

@interface VideosViewController : UIViewController<UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *purchaseView;

- (IBAction)close_purchaseView:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *availableCredits_lbl;

- (IBAction)Pay:(id)sender;

- (IBAction)Redeem:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *secondView;

@property (strong, nonatomic) IBOutlet UIView *EmptyPageView;

@property (strong, nonatomic) IBOutlet UICollectionView *CollectionView;

@property (strong, nonatomic) UIView* BlurView;
@property (strong, nonatomic) UIWindow* currentWindow;

@property (strong, nonatomic) IBOutlet UIButton *videoCamera;

- (IBAction)videoRecord:(id)sender;

@property (strong, nonatomic) SPUserResizableView *RecordVdoRzblView;

@property (strong, nonatomic) UIImageView *recordVideoImgVw;

@property (strong, nonatomic) IBOutlet UIView *TopSocialView;

@property (strong, nonatomic) IBOutlet UIView *SocialView;

@property (strong, nonatomic) IBOutlet UIView *SocialList;

- (IBAction)dropBoxAction:(id)sender;

- (IBAction)galleryPick:(id)sender;

@property (strong, nonatomic) ODClient *client;

- (IBAction)oneDrive:(id)sender;

- (IBAction)googleDrive:(id)sender;

- (IBAction)Box:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *pageViewImgView;
@property (strong, nonatomic) IBOutlet UIView *ADView;

@end
