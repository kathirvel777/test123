//
//  WizardIcons.h
//  Hypdra
//
//  Created by Mac on 12/4/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WizardIcons : UIViewController
@property (strong, nonatomic) IBOutlet UIView *ADView;
@property (strong, nonatomic) IBOutlet UICollectionView *CollectionView;
- (IBAction)done:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *blurView;
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *done;
- (IBAction)Choose_btn:(id)sender;

@end

NS_ASSUME_NONNULL_END
