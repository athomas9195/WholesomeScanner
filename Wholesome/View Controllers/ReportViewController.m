//
//  ReportViewController.m
//  Wholesome
//
//  Created by Anna Thomas on 7/14/21.
//

#import "ReportViewController.h"
#import <Parse/Parse.h>
#import <Parse/PFImageView.h>
#import "PieChartViewController.h"
#import "iCarousel.h"
  
@interface ReportViewController ()
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *containsLabel;
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *ingredientsLabel;
 
@property (weak, nonatomic) IBOutlet UILabel *key1; //keyword tag
@property (weak, nonatomic) IBOutlet UILabel *key2;//keyword tag
@property (weak, nonatomic) IBOutlet UILabel *key3;//keyword tag
@property (weak, nonatomic) IBOutlet UILabel *novaDescLabel;

@property (weak, nonatomic) IBOutlet UILabel *allergensLabel;

@property (weak, nonatomic) IBOutlet UILabel *additivesLabel;

@property (weak, nonatomic) IBOutlet UIImageView *nutriscoreImage;
@property (weak, nonatomic) IBOutlet UIImageView *novaImage;

   
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.carouselItems.count >=1) {
        _carousel.delegate = self;
        _carousel.dataSource = self;  
    }
    
    self.key1.clipsToBounds = true;
    self.key2.clipsToBounds = true;
    self.key3.clipsToBounds = true;
    self.key1.layer.cornerRadius = 10;
    self.key2.layer.cornerRadius = 10;
    self.key3.layer.cornerRadius = 10;
   
    
    self.foodNameLabel.text = self.product.foodName;
    if(self.product.allIngred != (id)[NSNull null]) {
        self.ingredientsLabel.text = self.product.allIngred;
    
    
        
    }
    //set the contains label: if no allergens, then display the first ingredient
    if(self.product.allergens) {
        NSString *allergen = self.product.allergens;
        NSString *uppercaseAllergen = [allergen uppercaseString];

        self.containsLabel.text = uppercaseAllergen;
    } else {
        //get the contains label
        NSArray *ingreds = [self.ingredientsLabel.text componentsSeparatedByString:@","];
        NSString *firstIngred = [ingreds objectAtIndex:0];
        NSString *uppercase = [firstIngred uppercaseString];

        self.containsLabel.text = uppercase; 
    } 
      

    //display image
    PFFileObject *file = self.product.image;
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

       self.imageView.image = [UIImage imageWithData:data];
   }];
   
    //open food facts  
    //nova display
    if(self.product.nova.longValue ==1) {
        self.novaImage.image = [UIImage imageNamed:@"nova 1"];
    } else if(self.product.nova.longValue ==2) {
        self.novaImage.image = [UIImage imageNamed:@"nova 2"];
    }else if(self.product.nova.longValue ==3) {
        self.novaImage.image = [UIImage imageNamed:@"nova 3"];
    } else if(self.product.nova.longValue ==4) {
        self.novaImage.image = [UIImage imageNamed:@"nova 4"];
    }
    
    self.novaDescLabel.text = [self.product.novaGroup objectAtIndex:0];
    
    //nutriscore display 
    if([self.product.nutriscore isEqual:@"a"]) {
        self.nutriscoreImage.image = [UIImage imageNamed:@"nutriscore a"];
    } else if([self.product.nutriscore isEqual:@"b"]) {
        self.nutriscoreImage.image = [UIImage imageNamed:@"nutriscore b"];
    }else if([self.product.nutriscore isEqual:@"c"]) {
        self.nutriscoreImage.image = [UIImage imageNamed:@"nutriscore c"];
    } else if([self.product.nutriscore isEqual:@"d"]) {
        self.nutriscoreImage.image = [UIImage imageNamed:@"nutriscore d"];
    } else if([self.product.nutriscore isEqual:@"e"]) {
        self.nutriscoreImage.image = [UIImage imageNamed:@"nutriscore e"];
    } 
    
    self.allergensLabel.text = self.product.allergens;
    
    
    //build the additives string
    NSString *add = @"";
    
    for (id additive in self.product.additives) {
       add= [add stringByAppendingString:additive];
    }
    self.additivesLabel.text = add;
    
    NSArray *keys =self.product.keyIngred;
    //add key ingredient tags
    if(keys.count >= 1) {
        self.key1.text = [keys objectAtIndex:0];
    }
    if(keys.count >= 2) {
        self.key2.text = [keys objectAtIndex:1];
    }
    if(keys.count >= 3) {
        self.key3.text = [keys objectAtIndex:2]; 
    }
    
    //configure carousel
    _carousel.type = iCarouselTypeCoverFlow2;
     
}

#pragma mark - Carousel Lifecycle

//carousel clean up 
- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    //this is true even if your project is using ARC, unless
    //you are targeting iOS 5 as a minimum deployment target
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [self.carouselItems count];
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
        ((UIImageView *)view).image = self.carouselItems[index];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"EmbedSegue"]) {
            PieChartViewController *embed = segue.destinationViewController;
            embed.slices = self.product.pieChartSlices;  
    } 
}


@end
