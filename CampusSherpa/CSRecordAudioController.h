#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface CSRecordAudioController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSURL *soundFileURL;

@property (strong, nonatomic) NSData *audioData;

@property (nonatomic) BOOL recording;

@property NSTimer *timer;

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

- (void) updateUIWithTime;
@end
