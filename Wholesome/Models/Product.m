//
//  Product.m
//  Wholesome
//
//  Created by Anna Thomas on 7/15/21.
//

#import "Product.h"

@implementation Product

//PHOTO?
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
     self = [super init];
     if (self) {

         self.itemID = dictionary[@"nix_item_id"]; 
         
         //get the image of the food 
         NSDictionary *photo = dictionary[@"photo"];
         self.image = photo[@"thumb"];
         
         self.foodName = dictionary[@"food_name"];
         self.brandName = dictionary[@"brand_name"];
         
         self.allIngred = dictionary[@"nf_ingredient_statement"];
          
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
