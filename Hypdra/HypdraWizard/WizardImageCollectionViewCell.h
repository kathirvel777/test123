//
//  WizardImageCollectionViewCell.h
//  Montage
//
//  Created by MacBookPro4 on 6/5/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WizardImageCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *selectedWizardImage;

@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIImageView *BackGroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *videoImgView;

@end
