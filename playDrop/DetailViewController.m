//
//  DetailViewController.m
//  playDrop
//
//  Created by Mit Parikh on 5/1/14.
//  Copyright (c) 2014 Mit Parikh. All rights reserved.
//

#import "DetailViewController.h"
#import "Shared.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface DetailViewController (){
    NSMutableString *pathForURL;
    dispatch_queue_t seekQueue;
}


@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *NavigationItem;
@property (weak, nonatomic) IBOutlet UISlider *seekbar;
//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *pauseButton;
//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *playButton;

@end

@implementation DetailViewController

@synthesize rowValue;
@synthesize playButton;
@synthesize pauseButton;
@synthesize maxTimeValueLabel;
@synthesize minTimeValueLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self setFileName];
    //self.playButton.hidden = YES;
    
    
//    if(!playQueue){
//        playQueue = dispatch_queue_create("com.example.gcdPlayQueue", NULL);
//    }
//    
//    dispatch_async(playQueue, ^{ [self playselectedsong];});
    

    
    
//    //NSMutableString *pathForURl
//    pathForURL = [[NSMutableString alloc]initWithString:[Shared sharedInstance].path];
//    //pathForURL = [[NSString alloc]initWithString:[[Shared sharedInstance].path]];
//    [pathForURL appendString:[Shared sharedInstance].fileNamesList[rowValue]];
//    NSLog(@"\n*********|||||||||||| PATH ::: %@ ",pathForURL);
    
    


    
}

-(void)viewWillAppear:(BOOL)animated{
    //[self setFileName];
    //self.playButton.hidden = YES;
    //[self playselectedsong];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setFileName
{
    NSLog(@"\n ((((((((((( setting Song name as :  ::: %@ ::::: ))))))))) ",[Shared sharedInstance].songNamesList[rowValue]);
    [self NavigationItem].title = [Shared sharedInstance].songNamesList[rowValue];
    
}

-(void)playselectedsong{
    rowValue = [Shared sharedInstance].currentPlayingRow;
    self.playButton.hidden = YES;
    pathForURL = [[NSMutableString alloc]initWithString:[Shared sharedInstance].path];
    [pathForURL appendString:[Shared sharedInstance].fileNamesList[rowValue]];
    NSLog(@"\n*********|||||||||||| PATH ::: %@ ",pathForURL);
    
    AVPlayerItem *newPlayerItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:pathForURL]];
    [Shared sharedInstance].songPlaying = YES;
    
    AVPlayer* player = [[AVPlayer alloc] initWithPlayerItem:newPlayerItem];
    NSLog(@"\n*********|||||||||||| AFTER STARTING PLAYER!! ::: ");
    [Shared sharedInstance].myAudioPlayer = player;
    [self commonTasksForView];
    

//    [[Shared sharedInstance].myAudioPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
}

-(void) commonTasksForView
{
    rowValue = [Shared sharedInstance].currentPlayingRow;
    NSLog(@"\n ((((((((((( ROW VALUE IS ::: %ld ::::: ))))))))) ",(long)rowValue);
    [self setFileName];
    
    
    //NSLog(@"\n************ MAX TIMEE VALUE :  %f ", maxTimeValue);
    dispatch_async(dispatch_get_main_queue(), ^{
        CMTime maxTimeDuration = [Shared sharedInstance].myAudioPlayer.currentItem.asset.duration;
        float maxTimeValue = CMTimeGetSeconds(maxTimeDuration);
        self.playButton.hidden = YES;
        self.seekbar.maximumValue = maxTimeValue;
        self.seekbar.minimumValue = 0;
        self.maxTimeValueLabel.text = [NSString stringWithFormat:@"%d:%02d",(int)maxTimeValue/60,(int)maxTimeValue%60];
       
    });
    
    [[Shared sharedInstance].myAudioPlayer play];


    dispatch_async(dispatch_get_main_queue(), ^{
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSeekBar) userInfo:nil repeats:YES];
    });
    
    NSLog(@"AFTER UPDATE SEEK");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[[Shared sharedInstance].myAudioPlayer currentItem]];
    
}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    
//    if (object == [Shared sharedInstance].myAudioPlayer && [keyPath isEqualToString:@"status"]) {
//        if ([Shared sharedInstance].myAudioPlayer.status == AVPlayerStatusFailed) {
//            NSLog(@"AVPlayer Failed");
//            
//        } else if ([Shared sharedInstance].myAudioPlayer.status == AVPlayerStatusReadyToPlay) {
//            NSLog(@"AVPlayerStatusReadyToPlay");
//            [[Shared sharedInstance].myAudioPlayer play];
//            
//            
//        } else if ([Shared sharedInstance].myAudioPlayer.status == AVPlayerItemStatusUnknown) {
//            NSLog(@"AVPlayer Unknown");
//            
//        }
//    }
//}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    if (rowValue<[Shared sharedInstance].fileNamesList.count-1) {
        [Shared sharedInstance].currentPlayingRow = rowValue+1;
        [self playselectedsong];
    }
    
    
}

- (void)updateSeekBar{
    CMTime duration = [Shared sharedInstance].myAudioPlayer.currentTime;
    float seconds = CMTimeGetSeconds(duration);
    //NSLog(@"\n************ time :  %f ", seconds);
    [self.seekbar setValue:seconds];
    [self.minTimeValueLabel setText:[NSString stringWithFormat:@"%d:%02d",(int)seconds/60,(int)seconds%60]];
}


- (IBAction)seekBar:(id)sender {
    
    if ([sender isKindOfClass:[UISlider class]]) {
        CMTime playerDuration = [Shared sharedInstance].myAudioPlayer.currentItem.duration;
        if (CMTIME_IS_INVALID(playerDuration)) {
            return;
        }
        
        double duration = CMTimeGetSeconds(playerDuration);
        if (isfinite(duration)) {
            float minValue = [self.seekbar minimumValue];
            float maxValue = [self.seekbar maximumValue];
            float value = [self.seekbar value];
            
            double time = duration * (value - minValue) / (maxValue - minValue);
            
            [[Shared sharedInstance].myAudioPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.pauseButton.hidden == YES){
                self.pauseButton.hidden = NO;
                self.playButton.hidden = YES;
            }
        });
        [[Shared sharedInstance].myAudioPlayer play];
    }
    
}

- (IBAction)pauseButton:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.pauseButton.hidden = YES;
        self.playButton.hidden = NO;
    });
    [[Shared sharedInstance].myAudioPlayer pause];

}


- (IBAction)playButton:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.playButton.hidden = YES;
        self.pauseButton.hidden = NO;
    });
    [[Shared sharedInstance].myAudioPlayer play];
}




@end
