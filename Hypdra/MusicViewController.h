//
//  MusicViewController.h
//  Montage
//
//  Created by MacBookPro on 4/26/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "SPUserResizableView.h"

@interface MusicViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *purchaseView;

- (IBAction)close_purchaseView:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *availableCredits_lbl;

@property (strong, nonatomic) IBOutlet UIView *topView;

- (IBAction)Pay:(id)sender;

- (IBAction)Redeem:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *secondView;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIView *collectView;


@property (strong, nonatomic) IBOutlet UIView *pageView;


@property (strong, nonatomic) IBOutlet UIImageView *albumImg;


//@property (strong, nonatomic) AVPlayerItem *playerItem;
//
//@property (strong, nonatomic) AVPlayer *audioPlayer;


@property (strong, nonatomic) UIView* BlurView;
@property (strong, nonatomic) UIWindow* currentWindow;

- (IBAction)recordAudio:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *rcAudio;
@property (strong, nonatomic) SPUserResizableView *recordAdioRzblVw;
@property (strong, nonatomic) UIImageView *recordAdoImgVw;
@property (strong, nonatomic) IBOutlet UIImageView *pageViewImgView;

@property (strong, nonatomic) IBOutlet UIView *ADView;

@end
