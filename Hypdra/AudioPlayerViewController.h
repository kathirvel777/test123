//
//  AudioPlayerViewController.h
//  AudioPlayer
//
//  Created by MacBookPro on 7/12/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioPlayerViewController : UIViewController


- (IBAction)play:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *dur;


@property (strong, nonatomic) IBOutlet UISlider *slider;


- (IBAction)slide:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *totalDur;


@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) NSString *playPath;

@property (strong, nonatomic) NSString *sourceView;


@property (strong, nonatomic) IBOutlet UIView *secondView;


@property (strong, nonatomic) IBOutlet UIButton *btnValue;





@end
