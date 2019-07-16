//
//  EffectsSideMenu.h
//  Hypdra
//
//  Created by MacBookPro on 5/10/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EffectsSideMenu : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)closeTap:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;

@end
