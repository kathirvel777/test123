//
//  ImgEditorStickerViewController.h
//  Montage
//
//  Created by MacBookPro on 2/9/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUserResizableView.h"
@import GoogleMobileAds;

@interface ImgEditorStickerViewController : UIViewController<GADBannerViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewSticker;
@property (strong, nonatomic) SPUserResizableView *sticView;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
- (IBAction)backAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *imgViewSuperView;

- (IBAction)doneAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneOutlet;

@property (strong, nonatomic) IBOutlet UILabel *navTitle;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end
