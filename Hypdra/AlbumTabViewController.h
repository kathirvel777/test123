//
//  AlbumTabViewController.h
//  Montage
//
//  Created by MacBookPro on 4/28/17.
//  Copyright © 2017 sssn. All rights reserved.


#import "TabBarViewController.h"

@interface AlbumTabViewController : TabBarViewController
@property (strong, nonatomic) IBOutlet UILabel *TttleLable;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addAndDeleteBtn;
- (IBAction)delete:(id)sender;
@property (strong,nonatomic) NSString *vc;

@end

