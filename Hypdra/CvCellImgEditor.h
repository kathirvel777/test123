//
//  CvCellImgEditor.h
//  Montage
//
//  Created by MacBookPro on 12/30/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CvCellImgEditor : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) IBOutlet UILabel *mainCategoryName;

@property (strong, nonatomic) IBOutlet UIView *frontView;
@property (strong, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) IBOutlet UIView *subViewSticker;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewSub;
@property (strong, nonatomic) IBOutlet UILabel *subCategoryName;

@end
