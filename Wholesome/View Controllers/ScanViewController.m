//
//  ScanViewController.m
//  Wholesome
//
//  Created by Anna Thomas on 7/14/21.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "API.h"
#import "Scan.h"
#import "ReportViewController.h"
#import "Product.h"
#import <Parse/Parse.h>
#import <Parse/ParseUIConstants.h>
#import <Parse/PFInstallation.h> 
#import <Parse/PFImageView.h>
#import <Firebase/Firebase.h>
#import <FirebaseFunctions/FIRFunctions.h>
#import <FirebaseFunctions/FIRHTTPSCallable.h>
#import <FirebaseFunctions/FIRError.h>
@import Firebase;
static Product *product;
static NSArray *labelArray;

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate> 
@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;
@property (weak, nonatomic) IBOutlet UIButton *rescanButton;

@property(strong, nonatomic) FIRFunctions *functions;
@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureLayer;
@property (strong, nonatomic) AVCapturePhotoOutput *stillImageOutput;

//@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) NSDictionary *nutritionixDict;
@property (nonatomic, strong) NSDictionary *foodFactsDict;
@property (nonatomic, strong) NSMutableArray *foodLabels;



@end
  
@implementation ScanViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
       // All UI calls go here
        [self.view bringSubviewToFront:self.rescanButton];
    });
    [self setupScanningSession];
    [self.captureSession startRunning];
//    self.functions = [FIRFunctions functionsForApp:];
    //timer for auto update for table view (can toggle)
    
//    self.functions = [FIRFunctions initWithProjectID:@"wholesome-321102":]
//
//    (instancetype)initWithProjectID:(NSString *)projectID
//                               region:(NSString *)region
//                         customDomain:(nullable NSString *)customDomain
//                                 auth:(nullable id<FIRAuthInterop>)auth
//                            messaging:(nullable id<FIRMessagingInterop>)messaging
//                             appCheck:(nullable id<FIRAppCheckInterop>)appCheck
//                       fetcherService:(GTMSessionFetcherService *)fetcherService
//
//
    
    self.functions = [FIRFunctions functions]; 
    
   [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reportSegue) userInfo:nil repeats:true];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // [START auth_listener]
    self.handle = [[FIRAuth auth]
        addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
          // ...
        }];
    
    // [END auth_listener]
    
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  // [START remove_auth_listener]
  [[FIRAuth auth] removeAuthStateDidChangeListener:_handle];
  // [END remove_auth_listener]
} 

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Start the camera capture session as soon as the view appears completely.
    [self.captureSession startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rescanButtonPressed:(id)sender {
    // Start scanning again.
    [self.captureSession startRunning];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.captureSession stopRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Local method to setup camera scanning session.
- (void)setupScanningSession {
    // Initalising hte Capture session before doing any video capture/scanning.
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession setSessionPreset:AVCaptureSessionPreset640x480];  
    
    NSError *error;
    // Set camera capture device to default and the media type to video.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Set video capture input: If there a problem initialising the camera, it will give am error.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];

        
    if (!input) {
        NSLog(@"Error Getting Camera Input");
        return;
    }
    // Adding input souce for capture session. i.e., Camera
    [self.captureSession addInput:input];

    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    // Set output to capture session. Initalising an output object we will use later.
    [self.captureSession addOutput:captureMetadataOutput];
    
    // Prepare an output for snapshotting CLOUD VISION INPUT SETUP
    self.stillImageOutput = [AVCapturePhotoOutput new];
    [self.captureSession addOutput:self.stillImageOutput];
    //self.stillImageOutput.outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};

     
    // Create a new queue and set delegate for metadata objects scanned.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("scanQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // Delegate should implement captureOutput:didOutputMetadataObjects:fromConnection: to get callbacks on detected metadata.
    [captureMetadataOutput setMetadataObjectTypes:[captureMetadataOutput availableMetadataObjectTypes]];
    
    // Layer that will display what the camera is capturing.
    self.captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.captureLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.captureLayer setFrame:self.cameraPreviewView.layer.bounds];
    // Adding the camera AVCaptureVideoPreviewLayer to our view's layer.
    [self.cameraPreviewView.layer addSublayer:self.captureLayer];
}
- (IBAction)didTakePhoto:(id)sender {
    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey: AVVideoCodecTypeJPEG}];

    [self.stillImageOutput capturePhotoWithSettings:settings delegate:self];
} 

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error
{
     
    if (error) {
        NSLog(@"error : %@", error.localizedDescription);
    }

    if (photo) {
        NSData *imageData = [photo fileDataRepresentation];
        UIImage *image1 = [UIImage imageWithData:imageData];
           
        NSData *newImageData = UIImageJPEGRepresentation(image1, 1.0f);
        NSString *base64encodedImage =
          [newImageData base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
//       [API getLabels:base64encodedImage completion:^(NSArray * arr, NSError * _Nonnull error) {
//           if(arr) {
//               NSLog(@"%@", arr);
//           }
//       }];
        
        NSDictionary *data = @{
            @"image": @{@"content": base64encodedImage},
          @"features": @{@"maxResults": @5, @"type": @"LABEL_DETECTION"}
        };
         
     
        [[self.functions HTTPSCallableWithName:@"annotateImage"]
                                  callWithObject:data
                                      completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
            if (error) {
                  if (error.domain == FIRFunctionsErrorDomain) {
                   // FIRFunctionsErrorCode code = error.code;
                    NSString *message = error.localizedDescription;
                   // NSObject *details = error.userInfo[FIRFunctionsErrorDetailsKey];
                      NSLog(@"error from firebase%@", message);
                  }
                
            } else {
                    // Function completed succesfully
                    // Get information about labeled objects
                    NSArray *labelArray = result.data[@"labelAnnotations"];
                  
                    for (NSDictionary *labelObj in labelArray) {
                          NSString *text = labelObj[@"description"];
                          //NSString *entityId = labelObj[@"mid"];
                          //NSNumber *confidence = labelObj[@"score"];
                        [self.foodLabels addObject:text];
                    }
              
                 
                    NSLog(@"%@", self.foodLabels);
           
               }
        }];
        
        
    }
     
}

// AVCaptureMetadataOutputObjectsDelegate method
//calls the api
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // Do your action on barcode capture here:
    NSString *capturedBarcode = nil;
    
    // Specify the barcodes you want to read here:
    NSArray *supportedBarcodeTypes = @[AVMetadataObjectTypeUPCECode,
                                       AVMetadataObjectTypeCode39Code,
                                       AVMetadataObjectTypeCode39Mod43Code,
                                       AVMetadataObjectTypeEAN13Code,
                                       AVMetadataObjectTypeEAN8Code,
                                       AVMetadataObjectTypeCode93Code,
                                       AVMetadataObjectTypeCode128Code,
                                       AVMetadataObjectTypePDF417Code,
                                       AVMetadataObjectTypeQRCode,
                                       AVMetadataObjectTypeAztecCode];
    
    // In all scanned values..
    for (AVMetadataObject *barcodeMetadata in metadataObjects) {
        // ..check if it is a suported barcode
        for (NSString *supportedBarcode in supportedBarcodeTypes) {
            
            if ([supportedBarcode isEqualToString:barcodeMetadata.type]) {
                // This is a supported barcode
                // Note barcodeMetadata is of type AVMetadataObject
                // AND barcodeObject is of type AVMetadataMachineReadableCodeObject
                AVMetadataMachineReadableCodeObject *barcodeObject = (AVMetadataMachineReadableCodeObject *)[self.captureLayer transformedMetadataObjectForMetadataObject:barcodeMetadata];
                capturedBarcode = [barcodeObject stringValue];
                // Got the barcode. Set the text in the UI and break out of the loop.
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.captureSession stopRunning];
              
                });
                   
                // self.scannedBarcode.text = capturedBarcode;
                NSLog(@"%@", capturedBarcode);
    
                
                
                //see if we're getting data from parse or api
                
                // construct PFQuery
                PFQuery *scanQuery = [Scan query];
                [scanQuery whereKey:@"upc" equalTo: capturedBarcode];

                // fetch data asynchronously
                [scanQuery findObjectsInBackgroundWithBlock:^(NSArray<Scan *> * _Nullable scans, NSError * _Nullable error) {
                    if (scans.count >=1) {
                        product = [[Product alloc] initWithScan: [scans objectAtIndex:0]]; 
                    }
                    else {
                        [self getItem:capturedBarcode completion:^(Product * product, NSError *error) {
                    
                                if (product) {
                                    NSLog(@"%@", product.allIngred);
                                
                                } else {
                                    NSLog(@"😫😫😫 Error getting product: %@", error.localizedDescription);
                                }
                        }];
                    }
                }];
                
        
                
                
                return;
            }
        }
    }
   
}

//retrieves item info from APIs (ingredients, item name, brand, and nutrition info).
- (void)getItem:(NSString *)upc completion:(void(^)(Product *product, NSError *error))completion {
  
    [API getItemWithUPC:upc completion:^(NSDictionary * _Nonnull dict, NSError * _Nonnull error) {
          
    }];
     
    [API getFoodFacts:upc completion:^(NSDictionary * _Nonnull dict, NSError * _Nonnull error) {
        
    }];
 
    
}
  

//update the data once the async api call returns
+(void)updateData:(NSDictionary *) dict : (NSDictionary *) dict1 : (NSString *)capturedBarcode {
        product = [[Product alloc]initWithDictionary:dict:dict1:capturedBarcode];
           
        //post to parse  
        [Scan postScan: product withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(error) {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
         
}

////update the data once the async api call returns
//+(void)updateData:(NSArray *) labels {
//    labelArray = labels;
//
//}

//activate the report segue to display report view
-(void)reportSegue {
    
    if(product != nil) {
        [self performSegueWithIdentifier:@"toReport" sender:self];
        product = nil;
    }
    
//    if(labelArray != nil) {
//        NSLog(@"%@", labelArray);
//    }
    
}
 

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"toReport"]){
        //report details segue
        
        ReportViewController *reportViewController = [segue destinationViewController];
        
        reportViewController.product = product;
    }
   
}


@end
