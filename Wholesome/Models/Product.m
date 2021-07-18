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
         self.keyIngred = openFoodFacts[@"categories_hierarchy"];
         self.additives = openFoodFacts[@"additives_old_tags"];
         self.nova = openFoodFacts[@"nova_group"];
         self.novaGroup = openFoodFacts[@"nova_groups_tags"]; 
         self.nutriscore = openFoodFacts[@"nutriscore_grade"];
         self.allergens = openFoodFacts[@"allergens"];
         //self.traces = openFoodFacts[@"traces"];
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
