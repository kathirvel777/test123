//
//  ImgEditorCollectionViewController.h
//  Montage
//
//  Created by MacBookPro on 12/30/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface ImgEditorCollectionViewController : UIViewController

//@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIView *imgView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewImg;

- (IBAction)backAction:(id)sender;

- (IBAction)applyAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *applyOutlet;
@property (strong, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@end
