
#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface PremiumViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UIView *billedMonthlyView;
@property (strong, nonatomic) IBOutlet UIView *billedAnnuallyView;

@property (strong, nonatomic) IBOutlet UIView *premiumMonthlyView;
- (IBAction)choosePremiumMonthlyAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnChooseMonthly;

@property (strong, nonatomic) IBOutlet UIView *premiumAnnuallyView;
- (IBAction)choosePremiumAnnuallyAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnChooseAnnually;
@property (strong, nonatomic) IBOutlet UIImageView *iconMonthly;
@property (strong, nonatomic) IBOutlet UIImageView *iconAnnually;
@property (strong, nonatomic) IBOutlet UILabel *Strike_lbl_PremiumMonthly;
@property (strong, nonatomic) IBOutlet UILabel *strike_lbl_premium_annualy;
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
