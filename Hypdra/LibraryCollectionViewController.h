//
//  LibraryCollectionViewController.h
//  Montage
//
//  Created by MacBookPro on 9/21/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryCollectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>


@property (strong, nonatomic) IBOutlet UICollectionView *cv;
@property (weak, nonatomic) IBOutlet UIView *secondView;

@end

