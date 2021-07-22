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


@interface ReportViewController ()
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *containsLabel;
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *ingredientsLabel;


@property (weak, nonatomic) IBOutlet UILabel *key1;
@property (weak, nonatomic) IBOutlet UILabel *key2;
@property (weak, nonatomic) IBOutlet UILabel *key3;
@property (weak, nonatomic) IBOutlet UILabel *novaDescLabel;

@property (weak, nonatomic) IBOutlet UILabel *allergensLabel;

@property (weak, nonatomic) IBOutlet UILabel *additivesLabel;

@property (weak, nonatomic) IBOutlet UIImageView *nutriscoreImage;
@property (weak, nonatomic) IBOutlet UIImageView *novaImage;
 



@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // NSLog(@"%@", self.product.allIngred);
    
    self.foodNameLabel.text = self.product.foodName;
    self.ingredientsLabel.text = self.product.allIngred;
    
    //get the contains label
    NSArray *ingreds = [self.ingredientsLabel.text componentsSeparatedByString:@","];
    
    //set the contains label: if no allergens, then display the first ingredient
    if(self.product.allergens) {
        NSString *allergen = self.product.allergens;
        NSString *uppercaseAllergen = [allergen uppercaseString];

        self.containsLabel.text = uppercaseAllergen;
    } else {
        NSString *firstIngred = [ingreds objectAtIndex:0];
        NSString *uppercase = [firstIngred uppercaseString];

        self.containsLabel.text = uppercase; 
    }
      
    
    //profile image
     
    PFFileObject *file = self.product.image;
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

       self.imageView.image = [UIImage imageWithData:data];
   }];
    //self.imageView.file = self.product.image;
    
    //open food facts 
    //nova
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
    //self.novaDescLabel.text = self.product.novaGroup;  
    
    //nutri
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
