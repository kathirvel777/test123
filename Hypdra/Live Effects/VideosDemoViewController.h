//
//  VideosDemoViewController.h
//  Montage
//
//  Created by MacBookPro on 12/7/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APLExpandableCollectionView.h"

@protocol VideoDemoViewControllerDelegate <NSObject>

@optional

- (void)didCloseVideo;
- (void)didFinishedVideo:(NSURL*)videoURL;

@end

@interface VideosDemoViewController : UIViewController

@property (nonatomic,strong) id<VideoDemoViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *takeRecord;

@property (strong, nonatomic) IBOutlet APLExpandableCollectionView *collectionViewVideos;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic) int timeSec;
@property(nonatomic) int timeMin;

@property (strong, nonatomic) IBOutlet UIView *mainView;

@end
