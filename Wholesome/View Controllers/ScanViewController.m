//
//  ScanViewController.m
//  Wholesome
//
//  Created by Anna Thomas on 7/14/21.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "APIManager.h"
#import "Scan.h"
#import "ReportViewController.h"
#import "Product.h"

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;
@property (weak, nonatomic) IBOutlet UIButton *rescanButton;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureLayer;

@property (nonatomic, strong) Product *product;

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
    
    
    
    // Do any additional setup after loading the view.
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
             
                   // self.scannedBarcode.text = capturedBarcode;
                    NSLog(@"%@", capturedBarcode);
    
                    [self getItemWithUPC:capturedBarcode completion:^(Product * product, NSError *error) {
            
                        if (product) {
                            NSLog(@"%@", product.allIngred);
                        
                        } else {
                            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
                        }
                    }];
                });
            
                return;
            }
        }
    }
   
}

//retrieves item info from Nutritionix (ingredients, item name, brand, and nutrition info).
- (void)getItemWithUPC:(NSString *)upc completion:(void(^)(Product *product, NSError *error))completion {

    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    
    NSString *appID= [dict objectForKey: @"app_Id"];
    NSString *appKey = [dict objectForKey: @"app_Key"];
    
    NSDictionary *headers = @{ @"x-app-id": appID,
                               @"x-app-key": appKey };
    
    //START
    NSString *base = @"https://trackapi.nutritionix.com/v2/search/item?upc=";
    NSString *fullURL = [base stringByAppendingString:upc];
    
    //create request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    //send request
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        //print out the http response
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                         
                                                        //use json serialization to print out dictionary
                                                        NSString *strISOLatin = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                                                        NSData *dataUTF8 = [strISOLatin dataUsingEncoding:NSUTF8StringEncoding];

                                                        id dict = [NSJSONSerialization JSONObjectWithData:dataUTF8 options:0 error:&error];
                                                        if (dict != nil) {
                                                            NSLog(@"Dict: %@", dict);
                                                            NSArray *temp = dict[@"foods"];
                                                            NSDictionary *foodDict = [temp objectAtIndex:0];
                                                            //set product
                                                            self.product = [[Product alloc]initWithDictionary:foodDict];
                                                            
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [self performSegueWithIdentifier:@"toReport" sender:self];
                                                            }); 
                                                            
                                                            
                                                        } else { 
                                                            NSLog(@"Error: %@", error);
                                                        }
                                                        
                                                
                                                     
                                                    } 
                                                }];
    [dataTask resume];
   
}


//send toreport segue data here (post object)

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"toReport"]){
        //report details segue
        
        ReportViewController *reportViewController = [segue destinationViewController];
        
        reportViewController.product = self.product;
    }
}


@end
