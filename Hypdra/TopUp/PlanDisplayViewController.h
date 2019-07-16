//
//  PlanDisplayViewController.h
//  SampleTest
//
//  Created by apple on 17/08/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKDropdownMenu.h"
@import InMobiSDK;
@import UnityAds;

@interface PlanDisplayViewController : UIViewController<IMInterstitialDelegate>


@property (strong, nonatomic) IBOutlet UIView *chooseMinutes;

@property (strong, nonatomic) IBOutlet UIView *chooseSpace;

@property (strong, nonatomic) IBOutlet UILabel *minValLabel;

@property (strong, nonatomic) IBOutlet UILabel *spcValLabel;

@property (strong, nonatomic) IBOutlet MKDropdownMenu *minList;

@property (strong, nonatomic) IBOutlet MKDropdownMenu *spcList;

- (IBAction)minPurchase:(id)sender;

- (IBAction)spcPurchase:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *planDis;

@property (strong, nonatomic) IBOutlet UILabel *amtDis;

@property (strong, nonatomic) IBOutlet UILabel *renuDateDisp;

@property (strong, nonatomic) IBOutlet UIButton *minVideo;

@property (strong, nonatomic) IBOutlet UIButton *invitFrnd;

@property (strong, nonatomic) IBOutlet UIButton *minPurch;

@property (strong, nonatomic) IBOutlet UIButton *spcPurch;

@property (strong, nonatomic) IBOutlet UIButton *spcInvite;

@property (strong, nonatomic) IBOutlet UIButton *spcVideo;

- (IBAction)InviteFrndSpc:(id)sender;

- (IBAction)InviteFrndMin:(id)sender;

- (IBAction)RewardedVideoSpc:(id)sender;

- (IBAction)RewardedVideoMin:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *creditsView;

@property (weak, nonatomic) IBOutlet UIView *transparentView;
@property (weak, nonatomic) IBOutlet UIView *spacePopUp;

- (IBAction)spaceNoThanks:(id)sender;

- (IBAction)getSpace:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *minutesPopUp;

@property (weak, nonatomic) IBOutlet UIView *oneMinuteView;
@property (weak, nonatomic) IBOutlet UIView *threeMinuteView;

@property (weak, nonatomic) IBOutlet UILabel *pointsInfo;

@property (weak, nonatomic) IBOutlet UILabel *lblPoints;
- (IBAction)minutesNoThanks:(id)sender;

- (IBAction)getMinutes:(id)sender;
- (IBAction)useCreditsToGetMinutes:(id)sender;
- (IBAction)useCreditsToGetSpaces:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgOneMin;
@property (weak, nonatomic) IBOutlet UIImageView *imgThreeMin;
- (IBAction)getGiftPoints:(id)sender;

@property (nonatomic, strong) IMInterstitial *interstitial;


@end
