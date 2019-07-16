//
//  WebViewController.m
//  SampleFlickr
//
//  Created by MacBookPro4 on 4/11/17.
//  Copyright © 2017 seek. All rights reserved.
//

#import "WebViewController.h"
#import "FlickrKit.h"
#import "SelectSourceViewController.h"
#import "DEMORootViewController.h"

@interface WebViewController ()
@property (nonatomic, retain) FKDUNetworkOperation *authOp;


@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Login Called");
    
/*    @try
    {
        NSString *callbackURLString = @"flickrkitdemo://auth";
        
        self.authOp = [[FlickrKit sharedFlickrKit] beginAuthWithCallbackURL:[NSURL URLWithString:callbackURLString] permission:FKPermissionDelete completion:^(NSURL *flickrLoginPageURL, NSError *error)
                       {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                if (!error)
                {
                    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:flickrLoginPageURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
                    [self.webView loadRequest:urlRequest];
                }
                else
                {
                    
                    
                    
                    NSLog(@"Error in flickr = %@",error);
                    
                    
                }
            });
        }];

    }
    @catch (NSException *exception)
    {
        
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
                                                                      message:@"Try Again."
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
        
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    @finally
    {
        
    }
    */
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.authOp cancel];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"])
    {
        if ([[UIApplication sharedApplication]canOpenURL:url])
        {
            NSLog(@"Open");

            [[UIApplication sharedApplication]openURL:url];
            return NO;
        }
    }
    
    
    return YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // This must be defined in your Info.plist
    // See FlickrKitDemo-Info.plist
    // Flickr will call this back. Ensure you configure your flickr app as a web app
    NSString *callbackURLString = @"flickrkitdemo://auth";
    
    // Begin the authentication process
    self.authOp = [[FlickrKit sharedFlickrKit] beginAuthWithCallbackURL:[NSURL URLWithString:callbackURLString] permission:FKPermissionDelete completion:^(NSURL *flickrLoginPageURL, NSError *error)
                   {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           if (!error) {
                               NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:flickrLoginPageURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
                               [self.webView loadRequest:urlRequest];
                           }
                           else
                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                               [alert show];
                           }
                       });		
                   }];
}


- (IBAction)back:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_2" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
}

@end
