//
//  ReferralDisplayViewController.h
//  SampleTest
//
//  Created by MacBookPro on 8/17/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReferralDisplayViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIView *rView;

@property (weak, nonatomic) IBOutlet UILabel *BonusType;

@property (weak, nonatomic) IBOutlet UILabel *referredEmail;

@property (weak, nonatomic) IBOutlet UILabel *update;

@property (weak, nonatomic) IBOutlet UILabel *earned;

@property (weak, nonatomic) IBOutlet UILabel *referredStatus;

@property (weak, nonatomic) IBOutlet UILabel *validTill;
- (IBAction)nextReferralAction:(id)sender;
- (IBAction)backReferralAction:(id)sender;


@end
