//
//  Product.m
//  Wholesome
//
//  Created by Anna Thomas on 7/15/21.
//

#import "Product.h"
#import "Scan.h"

@implementation Product

//initialized product with the nutritionix and open food facts dictionaries
- (instancetype)initWithDictionary:(NSDictionary *)nutritionix :(NSDictionary *)openFoodFacts: (NSString *)upc {
     self = [super init];
     if (self) {
         self.upc = upc;
         
         self.itemID = nutritionix[@"nix_item_id"];
         
         //get the image of the food
         NSDictionary *photo = nutritionix[@"photo"];
         NSString *imageURL = photo[@"thumb"];
         
         NSURL *url =[NSURL URLWithString:imageURL ];
         NSData *urlData = [NSData dataWithContentsOfURL:url];
         
         if (urlData.length != 0) {
             UIImage *productImage = [UIImage imageWithData: urlData];
             self.image = [self getPFFileFromImage:productImage];
         }
 
         self.foodName = nutritionix[@"food_name"];
         self.brandName = nutritionix[@"brand_name"];
         
         self.allIngred = nutritionix[@"nf_ingredient_statement"];
          
         if(openFoodFacts != nil) { 
             //open food facts
             self.keyIngred = openFoodFacts[@"_keywords"];
             
             NSArray *arr =openFoodFacts[@"additives_old_tags"];
             NSMutableArray *newArr = [[NSMutableArray alloc]init];
             for (id object in arr) {
                 // remove the 'en:' string
                 [newArr addObject: [object stringByReplacingOccurrencesOfString:@"en:" withString:@""]];
             }
             
             self.additives = newArr;
               
             self.nova = openFoodFacts[@"nova_group"];
            
             
             NSArray *arr1 =openFoodFacts[@"nova_groups_tags"];
             NSMutableArray *newArr1 = [[NSMutableArray alloc]init];
             for (id object in arr1) {
                 // remove the 'en:' string
                 NSString *tempString = [object stringByReplacingOccurrencesOfString:@"en:" withString:@""];
                 [newArr1 addObject: [tempString stringByReplacingOccurrencesOfString:@"-" withString:@" "]];
             }
             
            
             self.novaGroup = newArr1;
              
             
             self.nutriscore = openFoodFacts[@"nutriscore_grade"];
             
             
             NSString *allerg =openFoodFacts[@"allergens"];
            // remove the 'en:' string
             self.allergens = [allerg stringByReplacingOccurrencesOfString:@"en:" withString:@""];

             
             self.pieChartSlices = [NSMutableArray arrayWithCapacity:5];
             NSNumber *carbs = nutritionix[@"nf_total_carbohydrate"];
             [_pieChartSlices addObject:carbs];
             
             NSNumber *fat = nutritionix[@"nf_saturated_fat"];
             [_pieChartSlices addObject:fat];
             
             NSNumber *sodium = nutritionix[@"nf_sodium"];
             double newSodium = [sodium floatValue] * 0.01;
             [_pieChartSlices addObject: [NSNumber numberWithDouble:newSodium]];
             
             NSNumber *fiber = nutritionix[@"nf_dietary_fiber"];
             [_pieChartSlices addObject:fiber];
             
             NSNumber *protein = nutritionix[@"nf_protein"];
             [_pieChartSlices addObject:protein];
             
             
         }

    
     }
     return self;
 }

//initialized product with the nutritionix and open food facts dictionaries
- (instancetype)initWithDictionary:(NSArray *)nutritionixArray {
     self = [super init];
     if (self) {
    
         NSDictionary *nutritionix = [nutritionixArray objectAtIndex:0];
         //get the image of the food
         NSDictionary *photo = nutritionix[@"photo"];
         NSString *imageURL = photo[@"thumb"];
          
         NSURL *url =[NSURL URLWithString:imageURL ];
         NSData *urlData = [NSData dataWithContentsOfURL:url];
         
         if (urlData.length != 0) {
             UIImage *productImage = [UIImage imageWithData: urlData];
             self.image = [self getPFFileFromImage:productImage];
         }
 
         self.foodName = nutritionix[@"food_name"];
            

         self.pieChartSlices = [NSMutableArray arrayWithCapacity:5];
         NSNumber *carbs = nutritionix[@"nf_total_carbohydrate"];
         [_pieChartSlices addObject:carbs];
         
         NSNumber *fat = nutritionix[@"nf_saturated_fat"];
         [_pieChartSlices addObject:fat];
         
         NSNumber *sodium = nutritionix[@"nf_sodium"];
         double newSodium = [sodium floatValue] * 0.01;
         [_pieChartSlices addObject: [NSNumber numberWithDouble:newSodium]];
         
         NSNumber *fiber = nutritionix[@"nf_dietary_fiber"];
         [_pieChartSlices addObject:fiber];
         
         NSNumber *protein = nutritionix[@"nf_protein"];
         [_pieChartSlices addObject:protein];
         
    
     }
     return self;
 }

//initialized product with the nutritionix and open food facts dictionaries
- (instancetype)initWithArray:(NSArray *)nutritionixArray {
     self = [super init];
     if (self) {
    
         NSDictionary *nutritionix = [nutritionixArray objectAtIndex:0];
 
         self.foodName = nutritionix[@"food_name"];


         self.pieChartSlices = [NSMutableArray arrayWithCapacity:5];
         NSNumber *carbs = nutritionix[@"nf_total_carbohydrate"];
         [_pieChartSlices addObject:carbs];
         
         NSNumber *fat = nutritionix[@"nf_saturated_fat"];
         [_pieChartSlices addObject:fat];
         
         NSNumber *sodium = nutritionix[@"nf_sodium"];
         double newSodium = [sodium floatValue] * 0.01;
         [_pieChartSlices addObject: [NSNumber numberWithDouble:newSodium]];
         
         NSNumber *fiber = nutritionix[@"nf_dietary_fiber"];
         [_pieChartSlices addObject:fiber];
         
         NSNumber *protein = [NSNumber numberWithFloat:1.0];
         [_pieChartSlices addObject:protein]; 
         
    
     }
     return self;
 }

//initialize with scan from parse backend 
- (instancetype)initWithScan:(Scan *)scan {
     self = [super init];
     if (self) {
         self.upc = scan.upc;  
         
         self.itemID = scan.itemID;
         
         //get the image of the food
         self.image = scan.image;
         
         self.foodName = scan.foodName;
         self.brandName = scan.brandName;
         
         self.allIngred = scan.allIngred;
           
         
         //open food facts
         self.keyIngred = scan.keyIngred;
         self.additives = scan.additives;
         self.nova = scan.nova;
         self.novaGroup = scan.novaGroup;
         self.nutriscore = scan.nutriscore;
         self.allergens = scan.allergens;
 
         self.pieChartSlices = scan.pieChartSlices;
    
     }
     return self;
 }

//get the pffile from an uimage
- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}
 

@end
