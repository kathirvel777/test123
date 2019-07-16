//
//  PlayVideoViewController.h
//  Montage
//
//  Created by MacBookPro4 on 1/19/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayVideoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (strong,nonatomic)NSURL *urlValue;

@end
