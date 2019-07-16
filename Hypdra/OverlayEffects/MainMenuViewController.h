//
//  MainMenuViewController.h
//  Montage
//
//  Created by MacBookPro on 11/13/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface MainMenuViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sideMenu;

- (IBAction)closeAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *navTitle;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end

