//
//  CallToActionPlayerController.h
//  Montage
//
//  Created by MacBookPro on 7/28/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKVideoPlayerViewController.h"
#import "VKVideoPlayerView.h"
#import "NMRangeSlider.h"
#import "SPUserResizableView.h"

@interface CallToActionPlayerController : UIViewController
@property (atomic,strong) VKVideoPlayer *player;
@property(nonatomic,strong) NSString *imgPath;

@property (nonatomic, strong) NSString *currentLanguageCode;

@property (assign, nonatomic) Boolean *buttonExist;
@property (strong, nonatomic) SPUserResizableView *callToActionBtn;
@property (strong, nonatomic) UIImageView *action_btn_img;
@property (strong, nonatomic) UIImage *callToActionImage;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property(nonatomic, readonly) CGSize naturalSize;

@property (strong, nonatomic) IBOutlet NMRangeSlider *Slide;

- (IBAction)slideChanges:(NMRangeSlider *)sender;

@property (strong, nonatomic) IBOutlet UILabel *lowerLabel;
@property (strong, nonatomic) IBOutlet UILabel *upperLabel;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldAddress;
@property (strong, nonatomic) IBOutlet UITextField *start_min_txt;
@property (strong, nonatomic) IBOutlet UITextField *start_sec_txt;
@property (strong, nonatomic) IBOutlet UITextField *End_min;
@property (strong, nonatomic) IBOutlet UITextField *End_sec;

- (IBAction)backAction:(id)sender;

- (IBAction)useForVideoAction:(id)sender;


@end

