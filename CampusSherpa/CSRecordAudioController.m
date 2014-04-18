//
//  CSRecordAudioController.m
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 4/17/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSRecordAudioController.h"

@interface CSRecordAudioController ()
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;
@property (weak, nonatomic) IBOutlet UILabel *lblElapsedTime;

@end

@implementation CSRecordAudioController

- (IBAction)onRecordButtonClick:(id)sender {
    [self.btnRecord setImage:[UIImage imageNamed:@"stop_unpressed"] forState:UIControlStateNormal];
    [self.btnRecord setImage:[UIImage imageNamed:@"stop_pressed"] forState:UIControlStateHighlighted];
    self.startTime = [NSDate date];
    [self updateUIWithTime];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUIWithTime) userInfo:nil repeats:YES];

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
    self.lblElapsedTime.text = @"";
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
