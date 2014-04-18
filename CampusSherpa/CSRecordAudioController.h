//
//  CSRecordAudioController.h
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 4/17/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSRecordAudioController : UIViewController
@property (strong, nonatomic) NSDate *startTime;
- (void) updateUIWithTime;
@end
