//
//  TrimViewController.h
//  Montage
//
//  Created by MacBookPro4 on 5/13/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKVideoPlayerViewController.h"
#import "VKVideoPlayerView.h"
#import "SJVideoPlayer.h"



@interface TrimViewController : UIViewController

- (IBAction)trimAction:(id)sender;
- (IBAction)playAction:(id)sender;
- (IBAction)DoneAction:(id)sender;
- (IBAction)backAction:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIView *trimView;

@property (atomic,strong) SJVideoPlayer *SJplayer;


@property (atomic,strong) VKVideoPlayer *player;


@property (strong, nonatomic) NSString *playerURL;

@property (nonatomic, strong) NSString *currentLanguageCode;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *dontBtn;


@property (strong, nonatomic) NSString *currentVideoID;

@property(nonatomic, readonly) CGSize naturalSize;


- (IBAction)clockWise:(id)sender;


- (IBAction)anticlockWise:(id)sender;
- (IBAction)horizontalAction:(id)sender;
- (IBAction)verticalAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnTrim;


@end
