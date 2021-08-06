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
#import "API.h"
#import "Scan.h"

 
static NSMutableArray *veganItems;

@interface DiscoverViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
 
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
              [self getData1:10];
              [API searchAlternatives:@"vegan" completion:^(NSArray * products, NSError * _Nonnull error) {
                  if(products) {
                   
                          //don't do anything specific to the index within
                          //this `if (view == nil) {...}` statement because the view will be
                          //recycled and used with other index values later
                          self.carouselItems2 = products;
                  }
         
       
              }];
              
              [API searchAlternatives:@"keto" completion:^(NSArray * products, NSError * _Nonnull error) {
                  if(products) {
                   
                          //don't do anything specific to the index within
                          //this `if (view == nil) {...}` statement because the view will be
                          //recycled and used with other index values later
                          self.carouselItems3 = products;
                  }
       
              }];
             
              dispatch_async(dispatch_get_main_queue(), ^{
                  [weakSelf updateViews];
                  [weakSelf.carousel1 reloadData];
              });
          });
     
    self.profileImage.layer.cornerRadius = 38.0;
 
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reload) userInfo:nil repeats:true];
    
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
    if(carousel == self.carousel1) {
        return [self.carouselItems1 count];
    }
    
    if(carousel == self.carousel2) {
        
        return [self.carouselItems2 count];
    }
    if(carousel == self.carousel3) {
        
        return [self.carouselItems3 count]; 
    }
    //return the total number of items in the carousel
   
    return 0;
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (carousel == self.carousel1) {
        //create new view if no view is available for recycling
        if (view == nil)
        {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            view = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 300.0f, 300.0f)];
            
            //convert parse file image to uiimage
            Scan *scan =self.carouselItems1[index];
            PFFileObject *file =  scan.image;
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
      
                UIImage *newImage =[UIImage imageWithData:data];
                UIImage *resized = [self resizeImage:newImage withSize:CGSizeMake(150, 150)];
                ((UIImageView *)view).image = resized;
           }];

            view.contentMode = UIViewContentModeCenter;
        }
         
        return view;
        
    } else if (carousel == self.carousel2) {
        if (view == nil) {
            view = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 300.0f, 300.0f)];
        
            //convert parse file image to uiimage
            Product *prod =self.carouselItems2[index];
            
            
            PFFileObject *file = prod.image;
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
      
                UIImage *newImage =[UIImage imageWithData:data];
                UIImage *resized = [self resizeImage:newImage withSize:CGSizeMake(150, 150)];
                ((UIImageView *)view).image = resized;
           }];

            view.contentMode = UIViewContentModeCenter;
        }
         

        return view;
     
    
    } else {
        if (view == nil) {
            view = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 300.0f, 300.0f)];
        
            //convert parse file image to uiimage
            Product *prod =self.carouselItems3[index];
             
            PFFileObject *file = prod.image;
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
      
                UIImage *newImage =[UIImage imageWithData:data];
                UIImage *resized = [self resizeImage:newImage withSize:CGSizeMake(150, 150)];
                ((UIImageView *)view).image = resized;
           }];

            view.contentMode = UIViewContentModeCenter;
        }
           
        return view;
        
    }
       
        
        
        
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 0.3;
    }
    return value;
}  

-(void ) reload {
    if(self.carouselItems2.count >= 3) {
        [self.carousel2 reloadData];
        self.carousel2 = nil;
    }
    
    if(self.carouselItems3.count >= 3) {
        [self.carousel3 reloadData];
        self.carousel3 = nil;
    } 
   
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
