//
//  VideoEditorCollectionViewCell.h
//  Montage
//
//  Created by MacBookPro4 on 11/14/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditVideoEditorCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *topSelectedBar;

@end
