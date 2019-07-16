//
//  MyProfileViewController.h
//  DemoExpandable
//
//  Created by MacBookPro on 7/29/17.
//  Copyright © 2017 seek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAProgressView.h"
#import "UIImageView+WebCache.h"
#import "DRCircularProgressView.h"

@interface MyProfileViewController : UIViewController

@property (strong, nonatomic) UIView* BlurView;
@property (strong, nonatomic) UIWindow* currentWindow;

@property (strong, nonatomic) IBOutlet UIView *firstView;

@property (strong, nonatomic) IBOutlet UIView *fourthView;

@property (strong, nonatomic) IBOutlet UILabel *usedLabel;
@property (strong, nonatomic) IBOutlet UILabel *availableLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *usedSpace;
@property (strong, nonatomic) IBOutlet UILabel *availSpace;

@property (strong, nonatomic) IBOutlet UILabel *totalSpace;

@property (strong, nonatomic) IBOutlet UIView *secondView;

@property (strong, nonatomic) IBOutlet UIView *thirdView;

@property (strong, nonatomic) IBOutlet UIView *profileImage;

@property (strong, nonatomic) IBOutlet UIImageView *proImage;


@property (strong, nonatomic) IBOutlet UIButton *profileBtn;

@property (strong, nonatomic) IBOutlet UIButton *textBtn;


//@property (strong, nonatomic) IBOutlet UITextField *userName;

- (IBAction)userNameEdit:(id)sender;

@property (strong, nonatomic) IBOutlet UAProgressView *progressView;

- (IBAction)editProfile:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *userEmailLabel;


@property (strong, nonatomic) IBOutlet UILabel *spaceDuration;


@property (strong, nonatomic) IBOutlet UILabel *minutesDuration;


@property (strong, nonatomic) IBOutlet UILabel *totalMinDur;

@property (strong, nonatomic) IBOutlet UILabel *usedMinDur;

- (IBAction)back:(id)sender;

- (IBAction)menu:(id)sender;

@property (strong, nonatomic) IBOutlet DRCircularProgressView *storageView;

@property (strong, nonatomic) IBOutlet DRCircularProgressView *minutesView;

@property (strong, nonatomic) IBOutlet UILabel *storagePercentage;

@property (strong, nonatomic) IBOutlet UILabel *minutesPercentage;
- (IBAction)AddStorage_btn:(id)sender;
- (IBAction)AddMinutes_btn:(id)sender;
- (IBAction)AddCredits_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *avilable_Credits;

@end
