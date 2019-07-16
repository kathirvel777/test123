//
//  AiStyleTabViewController.h
//  Hypdra
//
//  Created by Mac on 12/24/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"
#import "REFrostedViewController.h"
#import "DEMORootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AiStyleTabViewController : TabBarViewController
- (IBAction)menu_actn:(id)sender;

- (IBAction)search_actn:(id)sender;

- (IBAction)back_actn:(id)sender;

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) UILabel *lbl1;
@end

NS_ASSUME_NONNULL_END
