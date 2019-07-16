//
//  WorkSpaceViewController.h
//  Hypdra
//
//  Created by MacBookPro on 7/4/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkSpaceViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *chooseImage_outlet;
@property (strong, nonatomic) IBOutlet UIButton *chooseTemplate_outlet;
@property (strong, nonatomic) IBOutlet UIButton *chooseMusicTemplate;
- (IBAction)chooseImage_actn:(id)sender;

- (IBAction)chooseTemplate_actn:(id)sender;

- (IBAction)chooseMusic_actn:(id)sender;
- (IBAction)menu:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)done:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imgImgView;

@property (strong, nonatomic) IBOutlet UIImageView *templateImgView;

@property (strong, nonatomic) IBOutlet UIView *FirstView;

@property (strong, nonatomic) IBOutlet UIView *subViewFirst;
@property (strong, nonatomic) IBOutlet UIView *subViewSecond;

@property (strong, nonatomic) IBOutlet UIView *subViewThird;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *done_outlet;
@property (strong, nonatomic) IBOutlet UIView *AdView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImgView;
@property (strong, nonatomic) IBOutlet UIImageView *EffectsImgView;
- (IBAction)choose_icon_action:(id)sender;
- (IBAction)choose_effects_actin:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *choose_icon;
@property (strong, nonatomic) IBOutlet UIButton *choose_efects;
@property (strong, nonatomic) IBOutlet UIView *sub_View_Fourth;
@property (strong, nonatomic) IBOutlet UIView *Sub_View_Fifth;

@end
