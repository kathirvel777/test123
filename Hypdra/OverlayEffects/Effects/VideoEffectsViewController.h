//
//  VideoEffectsViewController.h
//  Montage
//
//  Created by MacBookPro on 11/21/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface VideoEffectsViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,GADBannerViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong,nonatomic) NSString *videoPath,*isPageFirst;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewVideo;

- (IBAction)backAction:(id)sender;
- (IBAction)doneAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneOutlet;

@property (strong, nonatomic) IBOutlet UIImageView *bgImgView;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end
