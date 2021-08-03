//
//  ReportViewController.h
//  Wholesome
//
//  Created by Anna Thomas on 7/14/21.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "iCarousel.h"  

NS_ASSUME_NONNULL_BEGIN

@interface ReportViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) NSMutableArray *carouselItems; 
 

@end

NS_ASSUME_NONNULL_END
