//
//  VideoEditorViewController.h
//  Montage
//
//  Created by Srinivasan on 23/10/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "JWGCircleCounter.h"

@interface VideoEditorViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *editOutlet;
@property (strong, nonatomic) IBOutlet UIButton *overlayOutlet;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *editTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *effectTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *trimTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *overlayTop;



@property (strong, nonatomic) IBOutlet UIButton *effectOutlet;
@property (strong, nonatomic) IBOutlet UIButton *trimOutlet;

//@property (weak, nonatomic) IBOutlet JWGCircleCounter *circleCounter;

- (IBAction)overlayTap:(id)sender;

- (IBAction)effectTap:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *bgView;

@property (strong, nonatomic) NSString *user_id,*finalVideoID,*videopath,*viewHiding,*isFromTrimVC;

- (IBAction)backAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIButton *applyOutlet;

@property (strong, nonatomic) IBOutlet UIView *videoPlayView;
- (IBAction)trimTap:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *closeView;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) IBOutlet UIView *applyTopView;
@property (strong, nonatomic) IBOutlet UIView *applyBackView;
- (IBAction)editTap:(id)sender;

@end
