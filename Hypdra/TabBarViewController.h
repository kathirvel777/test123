//
//  TabBarViewController.h
//  Montage
//
//  Created by MacBookPro4 on 4/22/17.
//  Copyright © 2017 sssn. All rights reserved.

#import <UIKit/UIKit.h>

@interface TabBarViewController : UITabBarController<UITabBarDelegate>
@property (strong, nonatomic) IBOutlet UILabel *TttleLable;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addAndDeleteBtn;

@end
