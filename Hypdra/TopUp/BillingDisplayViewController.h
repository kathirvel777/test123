//
//  BillingDisplayViewController.h
//  SampleTest
//
//  Created by MacBookPro on 8/17/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillingDisplayViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *bView;

@property (strong, nonatomic) IBOutlet UIView *borderView;

@property (strong, nonatomic) IBOutlet UIButton *print;

- (IBAction)printAtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UILabel *plan;
@property (weak, nonatomic) IBOutlet UILabel *payment;
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *expiredDate;

-(IBAction)downloadAction:(id)sender;
- (IBAction)close_btn:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *printView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *sceenShotForPrint;
- (IBAction)printAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *blurView;
- (IBAction)DOwnload_actn:(id)sender;

@end
