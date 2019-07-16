//
//  UploadImageCollectionCell.h
//  Montage
//
//  Created by MacBookPro on 4/26/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadImageCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *TopView;

@property (strong, nonatomic) IBOutlet UIImageView *ImgView;

@property (strong, nonatomic) IBOutlet UIImageView *BackGroundImage;
@property (strong, nonatomic) IBOutlet UIButton *View;
@property (strong, nonatomic) IBOutlet UIButton *Edit;

@property (strong, nonatomic) IBOutlet UIButton *Annotate;
@property (strong, nonatomic) IBOutlet UIButton *Delete;
@property (strong, nonatomic) IBOutlet UIView *AboveTopView;
@property (strong, nonatomic) IBOutlet UIImageView *SelectedItem;

@end
