//
//  BasicPlanViewController.m
//  Montage
//
//  Created by MacBookPro4 on 7/12/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "BasicPlanViewController.h"

@interface BasicPlanViewController ()

@end

@implementation BasicPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    NSMutableAttributedString *attributeString1 = [[NSMutableAttributedString alloc] initWithString:self.strike_lbl_Basic.text];
    [attributeString1 addAttribute:NSStrikethroughStyleAttributeName
                             value:@1
                             range:NSMakeRange(0, [attributeString1 length])];
    [self.strike_lbl_Basic setAttributedText:attributeString1];
    
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
        //request.testDevices = @[kGADSimulatorID , @"edbfb999c3435fc4de3c45e321ec02e6"];
        request.testDevices = nil;

    [self.bannerView loadRequest:request];
        
        [self.btnBasic setTitle:@"Current Plan" forState:UIControlStateNormal];
    }
    else{
        [self.bannerView removeFromSuperview];
        [self.btnBasic setTitle:@"Downgrade" forState:UIControlStateNormal];


    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidLayoutSubviews
{
    
    self.secondView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.secondView.frame.size.width, self.secondView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    
    NSLog(@"Basic Height's = %f", self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"])
    {
        self.bannerView.frame=CGRectMake(self.bannerView.frame.origin.x, self.secondView.frame.origin.y+self.secondView.frame.size.height+15, self.bannerView.frame.size.width, self.bannerView.frame.size.height);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBasic:(id)sender
{
    
}
- (IBAction)btnBasicAction:(id)sender
{
    
}
@end
