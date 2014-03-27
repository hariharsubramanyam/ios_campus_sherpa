//
//  CSStartTourViewController.h
//  CampusSherpa
//
//  Created by Tesline Thomas on 3/26/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CSStartTourViewController : UIViewController
@property (nonatomic, strong) PFObject *selectedTour;
@end
