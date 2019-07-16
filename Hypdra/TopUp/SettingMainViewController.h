//
//  SettingMainViewController.h
//  SampleTest
//
//  Created by MacBookPro on 8/16/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"
@interface SettingMainViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIView *planView;


@property (strong, nonatomic) IBOutlet UIView *detailView;


@property (strong, nonatomic) IBOutlet UIView *referralView;

@property (strong, nonatomic) IBOutlet UIView *historyView;



@property (strong, nonatomic) IBOutlet UILabel *nxtBillDate;


@property (strong, nonatomic) IBOutlet UILabel *pymtMethod;


@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIView *selectionView;


- (IBAction)closeBtn:(id)sender;


- (IBAction)detailsBtn:(id)sender;


- (IBAction)historyBtn:(id)sender;
- (IBAction)referralBtn:(id)sender;
- (IBAction)planBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *history;

@property (strong, nonatomic) IBOutlet UIButton *detail;

@property (strong, nonatomic) IBOutlet UIButton *plan;


@property (strong, nonatomic) IBOutlet UIButton *referral;

- (IBAction)menu:(id)sender;

- (IBAction)back:(id)sender;

- (IBAction)switch_plans:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *inviteTop;
@property (strong, nonatomic) IBOutlet UIView *sndView;
@property (strong, nonatomic) IBOutlet UIImageView *countryImage;
@property (strong, nonatomic) IBOutlet UILabel *cntryCodeLabel;
@property (strong, nonatomic) IBOutlet UIView *pick;
@property (strong, nonatomic) IBOutlet UIView *getCountryView;

- (IBAction)getOTP:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *inviteInner;
@property (strong, nonatomic) IBOutlet UIView *otpTop;
@property (strong, nonatomic) IBOutlet UIView *otpInner;
@property (strong, nonatomic) IBOutlet UIView *otpsView;
@property (strong, nonatomic) IBOutlet UIButton *otpCloseBtn;
- (IBAction)otpClose:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *enterOTP;
- (IBAction)submitOTP:(id)sender;
- (IBAction)resendCode:(id)sender;
- (IBAction)switch_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *otpCode;
@property (strong, nonatomic) IBOutlet UISwitch *Otp_switch;

@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;

@property (strong, nonatomic) IBOutlet TextFieldValidator *mobileNumber;

@property (strong, nonatomic) IBOutlet UITextField *countryCode;
@end
