//
//  AudioPlayerViewController.m
//  AudioPlayer
//
//  Created by MacBookPro on 7/12/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "AudioPlayerViewController.h"
#import "STKAudioPlayer.h"
#import "STKAutoRecoveringHTTPDataSource.h"
#import "SampleQueueId.h"
#import <AVFoundation/AVFoundation.h>
#import "MuiscTabViewController.h"
#import "DEMORootViewController.h"

@interface AudioPlayerViewController ()<STKAudioPlayerDelegate>
{
    STKAudioPlayer* audioPlayer;
    NSTimer* timer;
    BOOL isFlag;
}

@end

@implementation AudioPlayerViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    isFlag = true;
    
    NSLog(@"Source View = %@",self.sourceView);
    
    NSError* error;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    Float32 bufferLength = 0.1;
    
    AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration, sizeof(bufferLength), &bufferLength);
    
    audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions)
    {
        .flushQueueOnSeek = YES,
        .enableVolumeMixer = NO,
        .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000}
    }];
    
    audioPlayer.meteringEnabled = YES;
    audioPlayer.volume = 1;
    
    audioPlayer.delegate = self;
    
//    self.totalDur.text = @"";
    
//    [self updateControls];
    
    
//    self.imgView.animationImages = [NSArray arrayWithObjects:
//                                         [UIImage imageNamed:@"781020fcf9d38e0b3d32feb50eee0c78.gif"],nil];
//    self.imgView.animationDuration = 1.0f;
////    self.imgView.animationRepeatCount = 200;
//    [self.imgView startAnimating];
    
    
    [[self.btnValue imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [self setupTimer];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [timer invalidate];
    timer = nil;
    
    [audioPlayer stop];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}


-(void)viewDidLayoutSubviews
{
    if ([self.sourceView isEqualToString:@"admin"])
    {
        self.secondView.frame = CGRectMake(0, self.tabBarController.tabBar.frame.size.height, self.secondView.frame.size.width, self.secondView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);

        NSLog(@"Height's = %f", self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    }
}


-(void) setupTimer
{
    timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play:(id)sender
{
    
    if (isFlag)
    {
        if (audioPlayer.state == STKAudioPlayerStatePaused)
        {
            NSLog(@"Resume");
            
            [audioPlayer resume];
            
            UIImage *img = [UIImage imageNamed:@"64-play"];
            
            [self.btnValue setImage:img forState:UIControlStateNormal];
            
            isFlag = false;
        }
        else
        {
            
            NSLog(@"New Play");
            
            NSURL* url = [NSURL URLWithString:self.playPath];
    
            //    NSURL* url = [NSURL URLWithString:@"https://hypdra.com//api//Audio//9778.mp3"];
    
            STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
    
            [audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
        
            isFlag = false;
            
            UIImage *img = [UIImage imageNamed:@"64-play"];
            
            [self.btnValue setImage:img forState:UIControlStateNormal];
            
            // setBackgroundImage:img forState:UIControlStateNormal];

        }
        
    }
    else
    {
        isFlag = true;
        
        NSLog(@"Paused");
        
        UIImage *img = [UIImage imageNamed:@"126-Play"];
        
        [self.btnValue setImage:img forState:UIControlStateNormal];

        [audioPlayer pause];
    }

}

- (IBAction)slide:(id)sender
{
    if (!audioPlayer)
    {
        return;
    }
    
    NSLog(@"Slider Changed: %f", self.slider.value);
    
    [audioPlayer seekToTime:self.slider.value];
}

-(void) tick
{

//    NSLog(@"Tick");
    


    if (!audioPlayer)
    {
        
//        NSLog(@"!audioPlayer");
        
        self.slider.value = 0;
//        self.dur.text = @"";
//        statusLabel.text = @"";
        
        return;
    }
    
    if (audioPlayer.currentlyPlayingQueueItemId == nil)
    {
        
//        NSLog(@"currentlyPlayingQueueItemId");
        
        self.slider.value = 0;
        self.slider.minimumValue = 0;
        self.slider.maximumValue = 0;
                
//        self.dur.text = @"";
        
        return;
    }
    
    if (audioPlayer.duration != 0)
    {
        
//        NSLog(@"audioPlayer.duration != 0");
        
        self.slider.minimumValue = 0;
        self.slider.maximumValue = audioPlayer.duration;
        self.slider.value = audioPlayer.progress;
        
        self.dur.text = [NSString stringWithFormat:@"%@", [self formatTimeFromSeconds:audioPlayer.progress]];
        
        self.totalDur.text =  [NSString stringWithFormat:@"%@", [self formatTimeFromSeconds:audioPlayer.duration]];
        
    }
    else
    {
//        NSLog(@"Audio Else");
        
        self.slider.value = 0;
        self.slider.minimumValue = 0;
        self.slider.maximumValue = 0;
        
//        self.dur.text =  [NSString stringWithFormat:@"%@", [self formatTimeFromSeconds:audioPlayer.progress]];
//        self.totalDur.text =  [NSString stringWithFormat:@"%@", [self formatTimeFromSeconds:audioPlayer.duration]];
    }
    
//    if (audioPlayer.progress == audioPlayer.duration && audioPlayer.duration > 0)
//    {
//        NSLog(@"Matched");
//        
//        isFlag = true;
//        
//        UIImage *img = [UIImage imageNamed:@"126-videos-white"];
//        
//        [self.btnValue setImage:img forState:UIControlStateNormal];
//
//    }
    
//    statusLabel.text = audioPlayer.state == STKAudioPlayerStateBuffering ? @"buffering" : @"";
    
//    CGFloat newWidth = 320 * (([audioPlayer averagePowerInDecibelsForChannel:1] + 60) / 60);
//    
//    meter.frame = CGRectMake(0, 460, newWidth, 20);
}

-(NSString*) formatTimeFromSeconds:(int)totalSeconds
{
    
    NSString *s = @"";
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if (hours == 0)
    {
        s = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    else
    {
        s = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
    
    return s;
}


- (IBAction)back:(id)sender
{
/*    if ([self.sourceView isEqualToString:@"admin"])
    {
        NSLog(@"MuiscTabViewController");
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        MuiscTabViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MuiscTab"];
        
        //        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:vc];
        
        [vc setSelectedIndex:1];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if ([self.sourceView isEqualToString:@"user"])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_2" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        
    }*/
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    NSLog(@"End Playing");
    
    isFlag = true;
    
    UIImage *img = [UIImage imageNamed:@"126-Play"];
    
    [self.btnValue setImage:img forState:UIControlStateNormal];
    
    
    self.dur.text = @"00:00";
    
    self.totalDur.text = @"00:00";
    
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{
    NSLog(@"Start Playing");
}


-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
    
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState;
{
    
}


-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
    
}


@end
