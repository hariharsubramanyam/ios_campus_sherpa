#import "CSUploadImageController.h"
#import "CSAppDelegate.h"

@interface CSUploadImageController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *imageTitle;
@property (weak, nonatomic) IBOutlet UITextView *imageDesc;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) CSAppDelegate *appDelegate;
@end

@implementation CSUploadImageController

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
    self.appDelegate = (CSAppDelegate *)[[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:tap];

}

-(void)dismissKeyboard {
    [self.imageDesc resignFirstResponder];
    [self.imageTitle resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openImageUI:(BOOL)useCamera
{
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if (useCamera) {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    [self presentViewController:cameraUI animated:YES completion:NULL];
}

- (IBAction)chooseFromLibrary:(id)sender {
    [self.appDelegate logMessageToParse:@"Choosing image from library"];
    [self openImageUI:NO];
}

- (IBAction)takePicture:(id)sender {
    [self.appDelegate logMessageToParse:@"Taking new picture"];
    [self openImageUI:YES];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [self.appDelegate logMessageToParse:@"Cancelled image picker"];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    UIImage *editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
    self.imageView.image = editedImage;
    self.image = UIImageJPEGRepresentation(editedImage, 0.7);
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)onCancelClick:(id)sender {
    self.image = nil;
    [self.appDelegate logMessageToParse:@"Cancelled out of add image view"];
    [self performSegueWithIdentifier:@"CANCEL_MEDIA" sender:self];
}
- (IBAction)onDoneClick:(id)sender {
    [self.appDelegate logMessageToParse:@"Finished adding image"];
    self.titleStr = self.imageTitle.text;
    self.descStr = self.imageDesc.text;
    [self performSegueWithIdentifier:@"ADDED_MEDIA" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
}

@end
