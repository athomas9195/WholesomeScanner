//
//  Product.m
//  Wholesome
//
//  Created by Anna Thomas on 7/15/21.
//

#import "Product.h"

@implementation Product

//PHOTO?
- (instancetype)initWithDictionary:(NSDictionary *)nutritionix :(NSDictionary *)openFoodFacts {
     self = [super init];
     if (self) {

         self.itemID = nutritionix[@"nix_item_id"];
         
         //get the image of the food 
         NSDictionary *photo = nutritionix[@"photo"];
         self.image = photo[@"thumb"];
         
         self.foodName = nutritionix[@"food_name"];
         self.brandName = nutritionix[@"brand_name"];
         
         self.allIngred = nutritionix[@"nf_ingredient_statement"];
          
         
         //open food facts
         self.keyIngred = openFoodFacts[@"_keywords"]; 
         self.additives = openFoodFacts[@"additives_old_tags"];
         self.nova = openFoodFacts[@"nova_group"];
         self.novaGroup = openFoodFacts[@"nova_groups_tags"]; 
         self.nutriscore = openFoodFacts[@"nutriscore_grade"];
         self.allergens = openFoodFacts[@"allergens"];
         //self.traces = openFoodFacts[@"traces"];
         
         //implement pie chart slices
        
     
             //"nf_total_carbohydrate" = 11;
             //"nf_saturated_fat" = 0;
             //"nf_sodium" = 300;
             //"nf_dietary_fiber" = 4;
             //"nf_protein" = 3;

         self.pieChartSlices = [NSMutableArray arrayWithCapacity:5];
         NSNumber *carbs = nutritionix[@"nf_total_carbohydrate"];
         [_pieChartSlices addObject:carbs];
         
         NSNumber *fat = nutritionix[@"nf_saturated_fat"];
         [_pieChartSlices addObject:fat];
         
         NSNumber *sodium = nutritionix[@"nf_sodium"];
         [_pieChartSlices addObject:sodium];
         
         NSNumber *fiber = nutritionix[@"nf_dietary_fiber"];
         [_pieChartSlices addObject:fiber];
         
         NSNumber *protein = nutritionix[@"nf_protein"];
         [_pieChartSlices addObject:protein];  
         
        
        
     }
     return self;
 }

////a factory method that returns Tweets when initialized with an array of Tweet Dictionaries
//+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
//    NSMutableArray *tweets = [NSMutableArray array];
//    for (NSDictionary *dictionary in dictionaries) {
//        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
//        [tweets addObject:tweet];
//    }
//    return tweets;
//}


@end
