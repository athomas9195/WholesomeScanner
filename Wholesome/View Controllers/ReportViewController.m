//
//  ReportViewController.m
//  Wholesome
//
//  Created by Anna Thomas on 7/14/21.
//

#import "ReportViewController.h"
#import <Parse/Parse.h>
#import <Parse/PFImageView.h>


@interface ReportViewController ()
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *ingredientsLabel;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // NSLog(@"%@", self.product.allIngred);
    
    self.foodNameLabel.text = self.product.foodName;
    self.ingredientsLabel.text = self.product.allIngred;
    
    //profile image
    NSString *URLString = self.product.image;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];

    if (urlData.length != 0) {
        self.imageView.image = nil;
        self.imageView.image = [UIImage imageWithData: urlData];
    }
    
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
