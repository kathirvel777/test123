//
//  CallToActionCollectionViewController.h
//  Montage
//
//  Created by Mac on 7/20/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
#import "PopUpViewController.h"


@interface CallToActionCollectionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UICollectionView *collection;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImage;
//@property (strong, nonatomic) UIView *blurView;
@property (strong, nonatomic) UIImageView *HighLightImgVIew;
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UIView *blurView;

@end

