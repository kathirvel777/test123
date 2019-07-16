//
//  OverlayEffectViewController.h
//  Montage
//
//  Created by Srinivasan on 23/10/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface OverlayEffectViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,GADBannerViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *TopView;
@property (strong, nonatomic) IBOutlet UIImageView *bgImgView;

@property (strong, nonatomic) IBOutlet UIView *sideBorderView;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *overlyViewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *overlyX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *plusY;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *plusX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *plusWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *plusHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *moreY;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *moreWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *moreHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *moreX;


@property (strong, nonatomic) IBOutlet UILabel *moreOutlet;

@property (strong, nonatomic) IBOutlet UICollectionView *overlayCollectionView;
@property (strong, nonatomic) IBOutlet UIButton *moreButtonOutlet;

@property (strong, nonatomic) IBOutlet UIView *overlayView;

@property (strong, nonatomic) NSString *videopath,*image_path,*status,*isPageFirst;

- (IBAction)menuSelection:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *menuSelectionView;

@property(strong,nonatomic) NSString *imageText1,*imagePath1,*thumbImage1;

@property(strong,nonatomic) NSMutableArray *imageText,*thumbImage,*imagePath;
- (IBAction)backAction:(id)sender;

- (IBAction)doneAction:(id)sender;
- (IBAction)moreTap:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneOutlet;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;


@end
