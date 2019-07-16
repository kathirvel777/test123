//
//  BasicPlanViewController.h
//  Montage
//
//  Created by MacBookPro4 on 7/12/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface BasicPlanViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UIView *billedMonthlyView;
@property (strong, nonatomic) IBOutlet UIView *billedAnnuallyView;
@property (strong, nonatomic) IBOutlet UIView *BasicView;

- (IBAction)btnBasicAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnBasic;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@property (strong, nonatomic) IBOutlet UILabel *strike_lbl_Basic;
@end
