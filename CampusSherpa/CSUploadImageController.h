//
//  CSUploadImageController.h
//  CampusSherpa
//
//  Created by Tesline Thomas on 4/5/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSUploadImageController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(strong, nonatomic) NSData *image;
@property(strong, nonatomic) NSString *titleStr;
@property(strong, nonatomic) NSString *descStr;
@end
