//
//  MyPlayerViewController.h
//  Hypdra
//
//  Created by MacBookPro on 5/24/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKVideoPlayerViewController.h"
#import "VKVideoPlayerView.h"

@interface MyPlayerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *callToActionButton;

@property (strong,nonatomic)NSString *ctaStatus;

@property(strong,nonatomic) NSString *ctaBtn,*callToActionStatus;
@property (strong, nonatomic) IBOutlet UIView *shrView;

@property (atomic,strong) VKVideoPlayer *player;

@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) NSString *playerURL,*randID,*video_ID,*embed_Link,*video_Title;

@property (strong, nonatomic) NSString *paymentResult;

@property (nonatomic, strong) NSString *currentLanguageCode;

@property (strong, nonatomic) IBOutlet UIView *saveView;

- (IBAction)ShareVideo:(id)sender;

- (IBAction)removeWaterMark:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *removeWaterBtn;

@property (strong, nonatomic) IBOutlet UIButton *manageWaterBtn;


- (IBAction)manageWaterMark:(id)sender;


- (IBAction)btn240p:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *download_btn;

@property (strong, nonatomic) IBOutlet UIView *aboveView;


@property (strong, nonatomic) IBOutlet UIView *secondView;


@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;


- (IBAction)calltoAction:(id)sender;


- (IBAction)share:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *shareBtn;


@property (strong, nonatomic) IBOutlet UIView *shareScreenView;


@property (strong, nonatomic) IBOutlet UIView *topRemove;


@property (strong, nonatomic) IBOutlet UIView *afterRemove;


- (IBAction)paymentBtn:(id)sender;


- (IBAction)inviteFrndBtn:(id)sender;


- (IBAction)rewardVideoBtn:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *advanceTitle;

- (IBAction)waterCloseBtn:(id)sender;

- (IBAction)downloadAtn:(id)sender;

- (IBAction)toActualShare:(id)sender;

- (IBAction)deleteVideo:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *eTopRemove;

@property (strong, nonatomic) IBOutlet UIView *eAfterRemove;

@property (strong, nonatomic) IBOutlet UITextView *embedLink;

- (IBAction)copy:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *cpyBtn;

@property (strong, nonatomic) IBOutlet UIButton *shareVBtn;

@property (strong, nonatomic) IBOutlet UIView *cta_backView;

@property (strong, nonatomic) IBOutlet UIView *callToActionView;

@property (strong, nonatomic) IBOutlet UIView *embedLinkView;

@property (strong, nonatomic) IBOutlet UIView *deleteView;

@property (strong, nonatomic) IBOutlet UIButton *CTA_outlet;

@end
