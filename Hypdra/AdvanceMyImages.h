//
//  AdvanceMyImages.h
//  Montage
//
//  Created by MacBookPro4 on 4/29/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvanceTabViewController.h"

@interface AdvanceMyImages : UIViewController
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UIView *firstView;
@property (strong, nonatomic) IBOutlet UICollectionView *imagesCollectionview;


@property (strong, nonatomic)  AdvanceTabViewController *adtabBar;

@end
