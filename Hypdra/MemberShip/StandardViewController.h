//
//  StandardViewController.h
//  Montage
//
//  Created by MacBookPro4 on 7/12/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface StandardViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UIView *billedMonthlyView;
@property (strong, nonatomic) IBOutlet UIView *billedAnnuallyview;


@property (strong, nonatomic) IBOutlet UIView *standardMonthlyView;
- (IBAction)chooseStandardMonthlyPlan:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnChooseMonthly;

@property (strong, nonatomic) IBOutlet UIView *standardAnnuallyView;
- (IBAction)chooseStandardAnnuallyPlan:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnChooseAnnually;
@property (strong, nonatomic) IBOutlet UIImageView *iconMonthly;

@property (strong, nonatomic) IBOutlet UIImageView *iconAnnually;
@property (strong, nonatomic) IBOutlet UILabel *Strike_lbl_standard_monthly;
@property (strong, nonatomic) IBOutlet UILabel *strike_lbl_standard_Annually;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (strong, nonatomic) IBOutlet UIButton *termsNcond_outlet;
- (IBAction)termsNcond_actn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *privacyPolicy_outlet;
- (IBAction)privacyPolicy_actn:(id)sender;
- (IBAction)Cancel:(id)sender;
- (IBAction)Okay_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *PriceDescriptionView;
@property (strong, nonatomic) IBOutlet UIView *blurView;

@end
