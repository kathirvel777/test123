//
//  MyMusic.h
//  Montage
//
//  Created by MacBookPro4 on 4/7/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMusic : UIViewController
- (IBAction)chooseMusic:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnchooseMusic;

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@end
