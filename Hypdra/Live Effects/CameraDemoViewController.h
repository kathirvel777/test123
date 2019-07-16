//
//  CameraDemoViewController.h
//  Montage
//
//  Created by MacBookPro on 10/10/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APLExpandableCollectionView.h"

@protocol CameraDemoViewControllerDelegate <NSObject>

@required
    - (void)didCloseCamera;
    - (void)didFinishedCamera:(UIImage*)chosenImage;
@end

@interface CameraDemoViewController : UIViewController

@property (nonatomic,strong) id<CameraDemoViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) IBOutlet UIButton *takePic;

@property (strong, nonatomic) IBOutlet APLExpandableCollectionView *collectionViewCam;

@property (strong, nonatomic) IBOutlet UIImageView *bgViewImage;



@end
