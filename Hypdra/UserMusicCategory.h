//
//  UserMusicCategory.h
//  Montage
//
//  Created by MacBookPro on 6/3/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@interface UserMusicCategory : UIViewController


@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *done;


- (IBAction)done:(id)sender;



@property (strong, nonatomic) IBOutlet UIView *secondView;


@property (strong, nonatomic) UIView* BlurView;
@property (strong, nonatomic) UIWindow* currentWindow;

@end
