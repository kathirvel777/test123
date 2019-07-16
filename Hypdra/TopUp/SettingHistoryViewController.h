//
//  SettingHistoryViewController.h
//  Montage
//
//  Created by MacBookPro on 7/27/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingHistoryViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIView *swipeView;


@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIButton *printBtn;


- (IBAction)print_Atn:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *firstLabel;

@property (strong, nonatomic) IBOutlet UILabel *lastLabel;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UILabel *amountLabel;

@property (strong, nonatomic) IBOutlet UILabel *pTypeLabel;


@property (strong, nonatomic) IBOutlet UILabel *productLabel;


@end
