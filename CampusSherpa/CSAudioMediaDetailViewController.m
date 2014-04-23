//
//  CSAudioMediaDetailViewController.m
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 4/22/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSAudioMediaDetailViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CSAppDelegate.h"

@interface CSAudioMediaDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic, strong) NSDate *startDate;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) CSAppDelegate *appDelegate;
@end

@implementation CSAudioMediaDetailViewController
- (IBAction)onPlayButtonClick:(id)sender {
    if (self.isPlaying) {
        [self stopPlaying];
    }else{
        [self startPlaying];
    }
    
}

- (void) startPlaying{
    [self.btnPlay setImage:[UIImage imageNamed:@"stop_unpressed"] forState:UIControlStateNormal];
    [self.btnPlay setImage:[UIImage imageNamed:@"stop_pressed"] forState:UIControlStateHighlighted];
    self.startDate = [NSDate date];
    self.isPlaying = YES;
    [self playAudio:self.appDelegate.selectedMedia.mediaData];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUIWithTime) userInfo:nil repeats:YES];
}

- (void) stopPlaying{
    [self.audioPlayer stop];
    [self.btnPlay setImage:[UIImage imageNamed:@"play_unpressed"] forState:UIControlStateNormal];
    [self.btnPlay setImage:[UIImage imageNamed:@"play_pressed"] forState:UIControlStateHighlighted];
    self.isPlaying = NO;
    self.lblTime.text = @"00:00";
    [self.timer invalidate];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                        successfully:(BOOL)flag{
    if (flag) {
        NSLog(@"Audio player stopped correctly");
    }else{
        NSLog(@"Audio player did not stop correctly");
    }
    
    if ([self.audioPlayer isEqual:player]) {
        self.audioPlayer = nil;
        [self stopPlaying];
    }else{
        
    }
}


- (void) updateUIWithTime{
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:self.startDate];
    int seconds = ((int)elapsedTime)%60;
    int minutes = ((int)elapsedTime)/60;
    self.lblTime.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) playAudio:(NSData *)fileData{
    NSError *playbackError = nil;
    self.audioPlayer =
    [[AVAudioPlayer alloc] initWithData:fileData
                                  error:&playbackError];
    
    if (self.audioPlayer != nil) {
        self.audioPlayer.delegate = self;
        
        if ([self.audioPlayer prepareToPlay]
            && [self.audioPlayer play]) {
            NSLog(@"Started playing the recorded audio");
        }else{
            NSLog(@"Could not play audio");
        }
    }else{
        NSLog(@"Could not create audio player");
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lblTime.text = @"";
    self.isPlaying = NO;
    self.appDelegate = ((CSAppDelegate *)[[UIApplication sharedApplication] delegate]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
