//
//  MyStyleVC.h
//  Hypdra
//
//  Created by Mac on 12/26/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
@import InMobiSDK;
@import UnityAds;

NS_ASSUME_NONNULL_BEGIN

@interface MyStyleVC : UIViewController<IMInterstitialDelegate>
@property (strong, nonatomic) IBOutlet UIView *ADView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)Add_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *Add_outlet;
@property (strong, nonatomic) IBOutlet UIView *blurView;
@property (strong, nonatomic) IBOutlet UIView *purchaseView;
@property (nonatomic, strong) IMInterstitial *interstitial;

- (IBAction)close_actn:(id)sender;
- (IBAction)Redeem_actn:(id)sender;

- (IBAction)pay_actn:(id)sender;

- (IBAction)watchAddVideo_actn:(id)sender;
- (IBAction)upgrade_actn:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *available_credits_lbl;


@end

NS_ASSUME_NONNULL_END
