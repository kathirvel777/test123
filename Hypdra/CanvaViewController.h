//
//  CanvaViewController.h
//  Hypdra
//
//  Created by Mac on 2/8/19.
//  Copyright © 2019 sssn. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CanvaViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *WebView;

- (IBAction)back_btn:(id)sender;

@end

NS_ASSUME_NONNULL_END
