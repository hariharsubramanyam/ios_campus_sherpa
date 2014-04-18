//
//  CSRecordAudioController.m
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 4/17/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSRecordAudioController.h"
#import "CSAppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CSImageMedia.h"

@interface CSRecordAudioController ()
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;
@property (weak, nonatomic) IBOutlet UILabel *lblElapsedTime;
@property (strong, nonatomic) CSAppDelegate *appDelegate;
@end

@implementation CSRecordAudioController

- (IBAction)onRecordButtonClick:(id)sender {
    // Determine which state we're in - recording or not recording
    if (!self.recording) {  // if not recording
        // Change button icons
        [self.btnRecord setImage:[UIImage imageNamed:@"stop_unpressed"] forState:UIControlStateNormal];
        [self.btnRecord setImage:[UIImage imageNamed:@"stop_pressed"] forState:UIControlStateHighlighted];
        
        // Record start time and update time label
        self.startTime = [NSDate date];
        [self updateUIWithTime];
        
        // Every second, update the label
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUIWithTime) userInfo:nil repeats:YES];
        self.recording = YES;
        [self startRecordingAudio];
    }else{               // if recording
        self.recording = NO;
        [self.timer invalidate];
        [self stopRecordingOnAudioRecorder:self.audioRecorder];
    }
}

- (void) updateUIWithTime{
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:self.startTime];
    int seconds = ((int)elapsedTime)%60;
    int minutes = ((int)elapsedTime)/60;
    self.lblElapsedTime.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Make the label have no text
    self.lblElapsedTime.text = @"";
    
    // Get the app delegate
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Set the background color
    self.view.backgroundColor = self.appDelegate.viewBackgroundColor;
    
    // We're not recording
    self.recording = NO;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord
             withOptions:AVAudioSessionCategoryOptionDuckOthers
                   error:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startRecordingAudio{
    NSError *error = nil;
    NSURL *audioRecordingURL = [self audioRecordingPath];
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioRecordingURL
                                                     settings:[self audioRecordingSettings]
                                                        error:&error];
    
    if (self.audioRecorder != nil) {
        self.audioRecorder.delegate = self;
        
        /* Prepare the audio recorder and record */
        
        if ([self.audioRecorder prepareToRecord]
            && [self.audioRecorder record]) {
            NSLog(@"Successfully began recording");
        }else{
            NSLog(@"Failed to record");
            self.audioRecorder = nil;
        }
    }else{
        NSLog(@"Failed to create audio recorder");
    }
}

- (NSURL *) audioRecordingPath{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *documentsFolderUrl =
    [fileManager URLForDirectory:NSDocumentDirectory
                        inDomain:NSUserDomainMask
               appropriateForURL:nil create:NO
                           error:nil];
    
    return [documentsFolderUrl URLByAppendingPathComponent:@"Recording.m4a"];
}

- (NSDictionary *) audioRecordingSettings{
    return @{
             AVFormatIDKey : @(kAudioFormatAppleLossless),
             AVSampleRateKey : @(44100.0f),
             AVNumberOfChannelsKey : @1,
             AVEncoderAudioQualityKey : @(AVAudioQualityLow),
             };
}

- (void) stopRecordingOnAudioRecorder:(AVAudioRecorder *)paramRecorder{
    [paramRecorder stop];
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                            successfully:(BOOL)flag{
    if (flag) {
        NSLog(@"Successfully recorded audio");
        
        NSError *readingError = nil;
        
        self.audioData =
        [NSData dataWithContentsOfURL:[self audioRecordingPath]
                              options:NSDataReadingMapped
                                error:&readingError];
        UIAlertView *alertView = [self makeAlertView];
        [alertView show];
    }else{
        NSLog(@"Stopping audio recording failed");
    }
    self.audioRecorder = nil;
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

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                        successfully:(BOOL)flag{
    if (flag) {
        NSLog(@"Audio player stopped correctly");
    }else{
        NSLog(@"Audio player did not stop correctly");
    }
    
    if ([self.audioPlayer isEqual:player]) {
        self.audioPlayer = nil;
    }else{
        
    }
}

- (void) audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    // Handle interruption here
}

- (void) audioPlayerEndInterruption:(AVAudioPlayer *)player
                        withOptions:(NSUInteger)flags{
    if (flags == AVAudioSessionInterruptionOptionShouldResume) {
        [player play];
    }
}

- (UIAlertView *)makeAlertView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Save Audio?"
                                                        message:@"Enter a name to save as"
                                                       delegate:self
                                              cancelButtonTitle:@"Discard"
                                              otherButtonTitles: @"Save", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeAlphabet;
    return alertView;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSLog(@"Saving audio named %@", textField.text);
    }else{
        NSLog(@"Not saving audio");
        self.audioData = nil;
        self.recording = NO;
        [self.btnRecord setImage:[UIImage imageNamed:@"microphone_button_unpressed"] forState:UIControlStateNormal];
        [self.btnRecord setImage:[UIImage imageNamed:@"microphone_button_pressed"] forState:UIControlStateHighlighted];
        self.lblElapsedTime.text = @"";
    }
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
