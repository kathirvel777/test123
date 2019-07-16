//
//  VideoEditorViewController.h
//  Montage
//
//  Created by MacBookPro4 on 11/14/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJVideoPlayer.h"
@import GoogleMobileAds;

@interface EditVideoEditorViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *videoEditCV;
@property (strong, nonatomic) IBOutlet UIView *topView;
- (IBAction)backAction:(id)sender;
- (IBAction)doneAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *rotationView;
@property (strong, nonatomic) IBOutlet UIView *flipView;
@property (strong, nonatomic) IBOutlet UIButton *clockWise;
- (IBAction)clockWiseAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *antiClockwise;
- (IBAction)anticlockWiseAction:(id)sender;
- (IBAction)horizontalAction:(id)sender;
- (IBAction)verticalAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnHorizontal;
@property (weak, nonatomic) IBOutlet UIButton *btnVertical;

@property (atomic,strong) SJVideoPlayer *SJplayer;
@property(nonatomic, readwrite) CGSize naturalSize;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

- (IBAction)TickAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *tickBtn;
@property (weak, nonatomic) IBOutlet UIView *rotationflipMenuView;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end
