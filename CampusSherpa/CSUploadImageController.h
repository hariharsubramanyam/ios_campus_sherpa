#import <UIKit/UIKit.h>

@interface CSUploadImageController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(strong, nonatomic) NSData *image;
@property(strong, nonatomic) NSString *titleStr;
@property(strong, nonatomic) NSString *descStr;
@end
