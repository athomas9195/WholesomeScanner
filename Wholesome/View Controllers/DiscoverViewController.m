//
//  DiscoverViewController.m
//  Wholesome
//
//  Created by Anna Thomas on 8/4/21.
//

#import "DiscoverViewController.h"
#import <Parse/PFImageView.h>
#import "iCarousel.h"
#import <Parse/Parse.h>
#import "Scan.h"


@interface DiscoverViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
 
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profileImage.layer.cornerRadius = 35.0;
    
    __weak typeof(self) weakSelf = self;
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [self getData1:10];
          dispatch_async(dispatch_get_main_queue(), ^{
              [weakSelf updateViews];
              [weakSelf.carousel1 reloadData];
          });
      });
}

-(void)updateViews {
    _carousel1.type = iCarouselTypeCoverFlow2;
    _carousel2.type = iCarouselTypeCoverFlow2;
    _carousel3.type = iCarouselTypeCoverFlow2;
    _carousel1.delegate = self;
    _carousel1.dataSource = self;
    _carousel2.delegate = self;
    _carousel2.dataSource = self;
    _carousel3.delegate = self;
    _carousel3.dataSource = self;
}

#pragma mark - Carousel Lifecycle

//carousel clean up
- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    //this is true even if your project is using ARC, unless
    //you are targeting iOS 5 as a minimum deployment target
    _carousel1.delegate = nil;
    _carousel1.dataSource = nil;
    _carousel2.delegate = nil;
    _carousel2.dataSource = nil;
    _carousel3.delegate = nil;
    _carousel3.dataSource = nil;
}
 
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [self.carouselItems1 count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 100.0f)];
        
        //convert parse file image to uiimage
        Scan *scan =self.carouselItems1[index];
        PFFileObject *file =  scan.image;
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
  
            UIImage *newImage =[UIImage imageWithData:data];
            UIImage *resized = [self resizeImage:newImage withSize:CGSizeMake(300, 300)];
            ((UIImageView *)view).image = resized;
       }];

        view.contentMode = UIViewContentModeCenter; 
    } 
    else
    {
        //get a reference to the label in the recycled view
        //label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
   // label.text = [self.carouselItems[index] stringValue];
     
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 5.1;
    }
    return value;
}

//gets the data from parse backend
- (void)getData1: (int) postLimit {
  
    // construct PFQuery
    PFQuery *scanQuery = [Scan query];
    [scanQuery orderByDescending:@"createdAt"];
    [scanQuery includeKey:@"author"];
    [scanQuery whereKey:@"author" equalTo: [PFUser currentUser]];
    scanQuery.limit = postLimit;

    // fetch data asynchronously
    [scanQuery findObjectsInBackgroundWithBlock:^(NSArray<Scan *> * _Nullable scans, NSError * _Nullable error) {
        if (scans) {
            NSMutableArray* scansMutableArray = [scans mutableCopy];
            self.carouselItems1 = scansMutableArray;
            [self.carousel1 reloadData]; 
        }
        else {
            NSLog(@"%@", error.localizedDescription);
            NSLog(@"%@", @"CANNOT GET STUFF");
        }
    }];
   
}

//resizes the given image
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
