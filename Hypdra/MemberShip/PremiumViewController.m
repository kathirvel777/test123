//
//  PremiumViewController.m
//  Montage
//
//  Created by MacBookPro4 on 7/12/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "PremiumViewController.h"
#import "DEMORootViewController.h"
#import "TestKit.h"

@interface PremiumViewController (){
    NSString *productID;
}

@end

@implementation PremiumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.premiumAnnuallyView.hidden=YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(billedMonthly:)];
    self.billedMonthlyView.tag=1;
    [self.billedMonthlyView addGestureRecognizer:singleFingerTap];
    
    UITapGestureRecognizer *singleFingerTap1 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(billedAnnually:)];
    self.billedAnnuallyView.tag=2;
    [self.billedAnnuallyView addGestureRecognizer:singleFingerTap1];
    
    self.iconMonthly.image=[UIImage imageNamed:@"circle_withfill"];
    self.iconAnnually.image=[UIImage imageNamed:@"circle_withoutfill"];
    
    NSMutableAttributedString *attributeString1 = [[NSMutableAttributedString alloc] initWithString:self.Strike_lbl_PremiumMonthly.text];
    [attributeString1 addAttribute:NSStrikethroughStyleAttributeName
                             value:@1
                             range:NSMakeRange(0, [attributeString1 length])];
    [self.Strike_lbl_PremiumMonthly setAttributedText:attributeString1];
    
    NSMutableAttributedString *attributeString2 = [[NSMutableAttributedString alloc] initWithString:self.strike_lbl_premium_annualy.text];
    [attributeString2 addAttribute:NSStrikethroughStyleAttributeName
                             value:@1
                             range:NSMakeRange(0, [attributeString2 length])];
    [self.strike_lbl_premium_annualy setAttributedText:attributeString2];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)billedMonthly:(UITapGestureRecognizer *)recognizer
{
    self.premiumAnnuallyView.hidden=YES;
    self.premiumMonthlyView.hidden=NO;
    self.iconMonthly.image=[UIImage imageNamed:@"circle_withfill"];
    self.iconAnnually.image=[UIImage imageNamed:@"circle_withoutfill"];
}

- (void)billedAnnually:(UITapGestureRecognizer *)recognizer
{
    self.premiumAnnuallyView.hidden=NO;
    self.premiumMonthlyView.hidden=YES;
    self.iconMonthly.image=[UIImage imageNamed:@"circle_withoutfill"];
    self.iconAnnually.image=[UIImage imageNamed:@"circle_withfill"];
}
-(void)viewDidLayoutSubviews
{
    
    self.secondView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.secondView.frame.size.width, self.secondView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    
    NSLog(@"Height's = %f", self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    self.bannerView.frame=CGRectMake(self.bannerView.frame.origin.x, self.secondView.frame.origin.y+self.secondView.frame.size.height+15, self.bannerView.frame.size.width, self.bannerView.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"])
    {
        self.bannerView.adUnitID =@"ca-app-pub-4411584255946382/4912857702";
       // self.bannerView.adUnitID =@"ca-app-pub-5459327557802742/3368768794";
        self.bannerView.rootViewController = self;
        GADRequest *request = [GADRequest request];
        //request.testDevices = @[ kGADSimulatorID , @"edbfb999c3435fc4de3c45e321ec02e6"];
        request.testDevices = nil;

        [self.bannerView loadRequest:request];
                
        [self.btnChooseMonthly setTitle:@"Upgrade" forState:UIControlStateNormal];
        [self.btnChooseAnnually setTitle:@"Upgrade" forState:UIControlStateNormal];
    }
    else{

        [self.bannerView removeFromSuperview];
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"ExactMemberShipType"] isEqualToString:@"PremiumMonth"])
        {
            [self.btnChooseMonthly setTitle:@"Current Plan" forState:UIControlStateNormal];
            [self.btnChooseAnnually setTitle:@"Upgrade" forState:UIControlStateNormal];
        }
        else if([[[NSUserDefaults standardUserDefaults]valueForKey:@"ExactMemberShipType"] isEqualToString:@"PremiumYear"])
        {
            [self.btnChooseMonthly setTitle:@"Downgrade" forState:UIControlStateNormal];
            [self.btnChooseAnnually setTitle:@"Current Plan" forState:UIControlStateNormal];
        }
    }
}

- (IBAction)choosePremiumMonthlyAction:(id)sender
{
    
    _blurView.hidden = NO;
    _PriceDescriptionView.hidden = NO;
    productID = @"com.ios.wizard.hypdra.premiummonthly";

    
}

- (IBAction)choosePremiumAnnuallyAction:(id)sender
{
    _blurView.hidden = NO;
    _PriceDescriptionView.hidden = NO;
    productID = @"com.ios.wizard.hypdra.premiumyearly";

    
}
- (IBAction)termsNcond_actn:(id)sender {

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    [vc awakeFromNib:@"contentController_15" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
    
}
- (IBAction)privacyPolicy_actn:(id)sender {
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    [vc awakeFromNib:@"contentController_8" arg:@"menuController"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)Cancel:(id)sender {
    _blurView.hidden = YES;
    _PriceDescriptionView.hidden = YES;;
}

- (IBAction)Okay_btn:(id)sender {
    [TestKit setcFrom:@"MemberShip"];
    
    [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:productID];
}
@end
