//
//  AddAdvanceCollectionViewController.h
//  Montage
//
//  Created by Mac on 5/12/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXReorderableCollectionViewFlowLayout.h"

@interface AddAdvanceCollectionViewController : UICollectionViewController<LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
//@property (strong, nonatomic) NSMutableArray *MainArray;
@property (strong, nonatomic) UIImageView *EmptyImage;
@property (strong, nonatomic) UIView *holdView,*topView,*mainView;
@property (strong, nonatomic) UIButton *glcButton,*previewAction;

@property (strong, nonatomic) IBOutlet UICollectionView *CollectionView;

- (IBAction)back:(id)sender;

- (IBAction)menu:(id)sender;
- (IBAction)add:(id)sender;

@end
