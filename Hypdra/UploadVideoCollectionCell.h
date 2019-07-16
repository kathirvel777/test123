//
//  UploadVideoCollectionCell.h
//  Montage
//
//  Created by Mac on 4/29/17.
//  Copyright © 2017 sssn. All rights reserved.


#import <UIKit/UIKit.h>

@interface UploadVideoCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *ImageView;
@property (strong, nonatomic) IBOutlet UIButton *delete;

@property (strong, nonatomic) IBOutlet UIButton *btnCrop;

@property (strong, nonatomic) IBOutlet UIButton *shareBtn;

@property (strong, nonatomic) IBOutlet UIView *aboveTopView;

@property (strong, nonatomic) IBOutlet UIButton *playVideo;

@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIImageView *BackGroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *selectedIconForDelete;

@end
