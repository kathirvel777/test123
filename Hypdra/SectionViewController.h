//
//  SectionViewController.h
//  Montage
//
//  Created by MacBookPro on 3/27/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIImageView *titleImage;

- (IBAction)settings:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *titleName;

@property (strong, nonatomic) IBOutlet UIButton *settingBtn;


@end
