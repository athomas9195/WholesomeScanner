//
//  DiscoverViewController.h
//  Wholesome
//
//  Created by Anna Thomas on 8/4/21.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiscoverViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>
@property (weak, nonatomic) IBOutlet iCarousel *carousel1;
@property (weak, nonatomic) IBOutlet iCarousel *carousel2;
@property (weak, nonatomic) IBOutlet iCarousel *carousel3;
@property (nonatomic, strong) NSMutableArray *carouselItems1;
@property (nonatomic, strong) NSMutableArray *carouselItems2;
@property (nonatomic, strong) NSMutableArray *carouselItems3; 

@end

NS_ASSUME_NONNULL_END
