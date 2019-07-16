//
//  GetEffectsViewController.h
//  Montage
//
//  Created by MacBookPro on 4/5/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
@import GoogleMobileAds;

@interface GetEffectsViewController : UIViewController<GADBannerViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sideMenu;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)closeAction:(id)sender;

- (IBAction)Save:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *navTitle;
- (IBAction)chooseAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *chooseOutlet;

@property (strong, nonatomic) IBOutlet UITextField *titles1;

@property (strong, nonatomic) IBOutlet UITextField *titles2;

- (IBAction)titlesdoneAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *done;
@property (strong, nonatomic) IBOutlet UIView *titlesView;

- (IBAction)done:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *blurView;
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIView *bannerAdView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myHeightConstraints;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (strong, nonatomic) IBOutlet UIView *PurchaseView;
- (IBAction)Redeem:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *availableCredits_lbl;
- (IBAction)Pay:(id)sender;
- (IBAction)close_purchaseView:(id)sender;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lowHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *HigherHeight;


@end

