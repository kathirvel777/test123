//
//  WizardThemeViewController.h
//  Montage
//
//  Created by MacBookPro4 on 6/6/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKVideoPlayerViewController.h"
#import "VKVideoPlayerView.h"

@interface WizardThemeViewController : UIViewController<VKVideoPlayerViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *themeCollectionView;
- (IBAction)backAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *transparentView;
@property (strong, nonatomic) IBOutlet UIView *playThemeView;
- (IBAction)closePlayView:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *themeTitle;
@property (strong, nonatomic) IBOutlet UIView *topView;
- (IBAction)chooseTheme:(id)sender;


@property (atomic,strong) VKVideoPlayer *player;

@property (nonatomic, strong) NSString *currentLanguageCode;

@property (strong, nonatomic) NSString *playerURL;


@end
