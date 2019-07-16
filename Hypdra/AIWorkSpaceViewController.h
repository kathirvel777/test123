//
//  AIWorkSpaceViewController.h
//  Hypdra
//
//  Created by Mac on 12/26/18.
//  Copyright © 2018 sssn. All rights reserved.
//
#import <UIKit/UIKit.h>
@import InMobiSDK;
@import UnityAds;

NS_ASSUME_NONNULL_BEGIN


@interface AIWorkSpaceViewController : UIViewController<IMInterstitialDelegate>
@property (strong, nonatomic) IBOutlet UIButton *Choose_Style_outlet;

- (IBAction)Choose_Img_actn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *Choose_Imag_outlet;

- (IBAction)Choose_Style_actn:(id)sender;

- (IBAction)Apply_actn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *choose_your_style_Lbl;
@property (strong, nonatomic) IBOutlet UILabel *_choose_Your_Image_Lbl;
@property (nonatomic, strong) IMInterstitial *interstitial;

@end

NS_ASSUME_NONNULL_END
