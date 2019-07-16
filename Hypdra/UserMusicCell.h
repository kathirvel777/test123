//
//  UserMusicCell.h
//  Montage
//
//  Created by MacBookPro on 6/3/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserMusicCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UIImageView *selectedMusic;


@property (strong, nonatomic) IBOutlet UILabel *title;

@property (strong, nonatomic) IBOutlet UIButton *play_btn;

@end
