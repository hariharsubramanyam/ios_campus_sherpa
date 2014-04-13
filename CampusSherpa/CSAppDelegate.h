//
//  CSAppDelegate.h
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 3/22/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSTour.h"
#import "CSTourLocation.h"
#import "CSTourMedia.h"

@interface CSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (strong, nonatomic) CSTour *selectedTour;
@property (strong, nonatomic) CSTourLocation *selectedTourLocation;
@property (strong, nonatomic) NSMutableArray *tours;
@property (strong, nonatomic) CSTourMedia *selectedMedia;
@property (strong, nonatomic) CSTour *createdTour;
@property (strong, nonatomic) CSTourLocation *locationToEdit;

@property (strong, nonatomic) UIColor *viewBackgroundColor;

- (void) logMessageToParse:(NSString *)message;

@end
