//
//  PlayThemeViewController.h
//  Montage
//
//  Created by MacBookPro4 on 6/6/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKVideoPlayer.h>
#import "VKVideoPlayerViewController.h"


@interface PlayThemeViewController : UIViewController<VKVideoPlayerViewDelegate>

@property (atomic,strong) VKVideoPlayer *player;

@property (strong, nonatomic) IBOutlet UIView *playView;
- (IBAction)selectThemeAction:(id)sender;
@property (nonatomic, strong) NSString *currentLanguageCode;

@property (strong, nonatomic) NSString *playerURL;

@end
