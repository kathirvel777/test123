//
//  PlanSettingViewController.h
//  Montage
//
//  Created by MacBookPro on 7/27/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKDropdownMenu.h"


@interface PlanSettingViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIView *topView;


@property (strong, nonatomic) IBOutlet UIButton *spcExpnd;


@property (strong, nonatomic) IBOutlet UIButton *minExpnd;


//@property (strong, nonatomic) IBOutlet UIView *minutesTopView;

@property (strong, nonatomic) IBOutlet UIView *minutesView;

//@property (strong, nonatomic) IBOutlet UIView *spaceTopView;

@property (strong, nonatomic) IBOutlet UIView *spaceView;


- (IBAction)minuteBtn:(id)sender;
- (IBAction)yourPlan:(id)sender;
- (IBAction)renewalDate:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *renewalBar;
@property (strong, nonatomic) IBOutlet UIView *yourPlanBar;


@property (strong, nonatomic) IBOutlet UIView *topMainView;


@property (strong, nonatomic) IBOutlet UIView *mainView;

- (IBAction)spaceBtn:(id)sender;

@property (strong, nonatomic) IBOutlet MKDropdownMenu *minutesList;

@property (strong, nonatomic) IBOutlet MKDropdownMenu *spaceList;


- (IBAction)minutePurchase:(id)sender;

- (IBAction)spacePurchase:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *viewPlanOrRenewal;
@property (strong, nonatomic) IBOutlet UILabel *availableMinutes;

@property (strong, nonatomic) IBOutlet UILabel *usedMinutes;
@property (strong, nonatomic) IBOutlet UILabel *usedSpace;
@property (strong, nonatomic) IBOutlet UILabel *availableSpace;
@property (strong, nonatomic) IBOutlet UILabel *planDetail;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minHght;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *spaceHght;

@property (strong, nonatomic) IBOutlet UILabel *planDes;

@property (strong, nonatomic) IBOutlet UIView *minDisList;

@property (strong, nonatomic) IBOutlet UIView *subMainView;

@property (strong, nonatomic) IBOutlet UIView *spaceDisList;


@property (strong, nonatomic) IBOutlet UILabel *chooseMin;

@property (strong, nonatomic) IBOutlet UILabel *usedMin;

@property (strong, nonatomic) IBOutlet UILabel *usedMinLabel;

@property (strong, nonatomic) IBOutlet UILabel *availMinLabel;

@property (strong, nonatomic) IBOutlet UILabel *availMin;

@property (strong, nonatomic) IBOutlet UILabel *usedSpaces;

@property (strong, nonatomic) IBOutlet UILabel *chooseSpace;


@property (strong, nonatomic) IBOutlet UILabel *usedSpaceLabel;

@property (strong, nonatomic) IBOutlet UILabel *availSpaceLabel;

@property (strong, nonatomic) IBOutlet UILabel *availSpace;


@property (strong, nonatomic) IBOutlet UILabel *usSpace;


@property (strong, nonatomic) IBOutlet UILabel *ttlSpace;




@end
