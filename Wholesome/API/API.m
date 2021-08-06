//
//  API.m
//  Wholesome
//
//  Created by Anna Thomas on 7/21/21.
//

#import "API.h" 
#import "Product.h"
#import <Foundation/Foundation.h>
#import "ScanViewController.h"
#import "DiscoverViewController.h"

static NSMutableArray *veganItems;
static NSMutableArray *ketoItems;
static Product *product;

static NSString * const baseURLString = @"https://trackapi.nutritionix.com/v2/search/item?upc=";
static NSString * const baseURLStringItemID = @"https://trackapi.nutritionix.com/v2/search/item?nix_item_id=";
static NSString * const baseURLStringSearch = @"https://trackapi.nutritionix.com/v2/search/instant?query=";
static NSString * const baseURLStringNutrition= @"https://trackapi.nutritionix.com/v2/natural/nutrients";
static NSString * const newBase = @"https://us.openfoodfacts.org/api/v0/product/";
static NSDictionary *foodDict;  //stores the nutritionix dictionary
static NSDictionary *headers; //stores the headers like app id and key
static NSString *appID;
static NSString *appKey;
static NSDictionary *foodFactsDict; //stores the dict from open food facts
static NSMutableArray *foodLabels;

static NSDictionary *searchResults;
static NSDictionary *foodNutrition;
static NSString *foodName;
  
@implementation API

//retrieves item info from Nutritionix (ingredients, item name, brand, and nutrition info).
+ (NSDictionary*)getItemWithUPC:(NSString *)upc completion:(void(^)(NSDictionary *dictComp, NSError *error))completion {
     
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    
    appID = [dict objectForKey: @"app_Id"];
    appKey = [dict objectForKey: @"app_Key"];
    
    headers = @{ @"x-app-id": appID, @"x-app-key": appKey };
     
    NSString *fullURL = [baseURLString stringByAppendingString:upc];
      
    //create request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    //send request
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
                NSLog(@"%@", error.localizedDescription);
        } else {
                //print out the http response
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                NSLog(@"%@", httpResponse);
                                                         
                //use json serialization to print out dictionary
                NSString *strISOLatin = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                NSData *dataUTF8 = [strISOLatin dataUsingEncoding:NSUTF8StringEncoding];

                id dict = [NSJSONSerialization JSONObjectWithData:dataUTF8 options:0 error:&error];
                if (dict != nil) {
                   NSLog(@"Dict: %@", dict);
                   NSArray *temp = dict[@"foods"];
                   foodDict = [temp objectAtIndex:0];
                    
                    NSString *name = foodDict[@"food_name"];
                    [self searchAlternatives:name completion:^(NSArray * _Nonnull products, NSError * _Nonnull error) {
                         
                    }];
                

                } else {
                   NSLog(@"Error: %@", error);
                }
                                                        
        }
    }];
    [dataTask resume];
    
    return foodDict;
    
}

//retrieves item info from Nutritionix (ingredients, item name, brand, and nutrition info).
+ (NSDictionary*)getItemWithItemID:(NSString *)item completion:(void(^)(NSDictionary *dict, NSError *error))completion {
     
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
     
    appID = @"7a7f40ef";
    appKey = @"4caac3de1af0d3c21b1c809fb1d14ff1";  
    
    headers = @{ @"x-app-id": appID, @"x-app-key": appKey };
     
    NSString *fullURL = [baseURLStringItemID stringByAppendingString:item];
      
    //create request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    //send request
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
                NSLog(@"%@", error.localizedDescription);
        } else {
                //print out the http response
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                NSLog(@"%@", httpResponse);
                                                         
                //use json serialization to print out dictionary
                NSString *strISOLatin = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                NSData *dataUTF8 = [strISOLatin dataUsingEncoding:NSUTF8StringEncoding];

                id dict = [NSJSONSerialization JSONObjectWithData:dataUTF8 options:0 error:&error];
                if (dict != nil) {
                   NSLog(@"Dict: %@", dict);
                   NSArray *temp = dict[@"foods"];
                   NSDictionary *dict = [temp objectAtIndex:0];
               
                    completion(dict, nil);

                } else {
                   NSLog(@"Error: %@", error);
                }
                                                        
        }
    }];
    [dataTask resume];
    
    return foodDict;
     
}


//retrieves search results from Nutritionix
+ (NSDictionary*)searchItems:(NSString *)food completion:(void(^)(NSDictionary *dictComp, NSError *error))completion {
      
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    
    appID = [dict objectForKey: @"app_Id"];
    appKey = [dict objectForKey: @"app_Key"];
    
    headers = @{ @"x-app-id": appID, @"x-app-key": appKey };
     
    NSString *tempURL = [baseURLStringSearch stringByAppendingString:food];
      
    //create request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:tempURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    //send request
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
                NSLog(@"%@", error.localizedDescription);
        } else {
                //print out the http response
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                NSLog(@"%@", httpResponse);
                                                         
                //use json serialization to print out dictionary
                NSString *strISOLatin = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                NSData *dataUTF8 = [strISOLatin dataUsingEncoding:NSUTF8StringEncoding];

                id dict = [NSJSONSerialization JSONObjectWithData:dataUTF8 options:0 error:&error];
                if (dict != nil) {
                     
                    
                   NSArray *temp = dict[@"common"];
                   searchResults = [temp objectAtIndex:0];
                    //the key value pair
                    NSString *uneditedFoodName = searchResults[@"tag_name"];
        
                    NSString *foodName = [uneditedFoodName stringByReplacingOccurrencesOfString:@" " withString:@"+"];
                      
                    [self getNutritionInfo:foodName completion:^(NSDictionary *dictComp, NSError *error) {
                        if(error) {
                            NSLog(@"%@", error.localizedDescription);
                        }
                    }];
                     
                } else {
                   NSLog(@"Error: %@", error);
                }
                                                        
        }
    }];
    [dataTask resume];
    
    return foodDict;
}

//retrieves search results from Nutritionix
+ (NSDictionary*)searchAlternatives:(NSString *)food completion:(void(^)(NSArray *products, NSError *error))completion {
       
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    
    appID = @"7a7f40ef";
    appKey = @"4caac3de1af0d3c21b1c809fb1d14ff1";
    
    headers = @{ @"x-app-id": appID, @"x-app-key": appKey };
    NSString *editedFood = [food stringByReplacingOccurrencesOfString:@" " withString:@"+"];
     
    NSString *tempURL = [baseURLStringSearch stringByAppendingString:editedFood];
       
    //create request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:tempURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    //send request
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
                NSLog(@"%@", error.localizedDescription);
        } else {
                //print out the http response
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                NSLog(@"%@", httpResponse);
                       
                //use json serialization to print out dictionary
                NSString *strISOLatin = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                NSData *dataUTF8 = [strISOLatin dataUsingEncoding:NSUTF8StringEncoding];

                id dict = [NSJSONSerialization JSONObjectWithData:dataUTF8 options:0 error:&error];
                if (dict != nil) {
                    
                    //store data for alternative items
                     NSArray *alternatives = dict[@"branded"];
                    
                    if([food isEqualToString:@"vegan"]) {
                    
                            NSMutableArray *shortenedArr =[[NSMutableArray alloc] init];
                            if(alternatives.count >= 10) {
                                for (int i =0; i<10; i++) {
                                    [shortenedArr addObject: [alternatives objectAtIndex:i]];
                                }
                            } else {
                                for (int i =0; i<alternatives.count; i++) {
                                    [shortenedArr addObject: [alternatives objectAtIndex:i]];
                                }
                            }
                              
                        NSMutableArray *output = [[NSMutableArray alloc] init];
                            for (id dict in shortenedArr) {
                                NSString *itemID = dict[@"nix_item_id"];
                                [self getItemWithItemID:itemID completion:^(NSDictionary * _Nonnull dict, NSError * _Nonnull error) {
                                     
                                    if(dict) {
                                        Product *prod = [[Product alloc] initWithDictionary:dict :nil:@""];
                                        [output addObject:prod];
                                        if(output.count >= 1) {
                                             
                                            completion(output,nil);
                                          
                                        }
                                    }
                                }];
                             
                            }
                             
                            
                    }else if ([food isEqualToString:@"keto"]) {
                        
                        NSMutableArray *shortenedArr =[[NSMutableArray alloc] init];
                        if(alternatives.count >= 10) {
                            for (int i =0; i<10; i++) {
                                [shortenedArr addObject: [alternatives objectAtIndex:i]];
                            } 
                        } else {
                            for (int i =0; i<alternatives.count; i++) {
                                [shortenedArr addObject: [alternatives objectAtIndex:i]];
                            }
                        }
                          
                    NSMutableArray *output = [[NSMutableArray alloc] init];
                        for (id dict in shortenedArr) {
                            NSString *itemID = dict[@"nix_item_id"];
                            [self getItemWithItemID:itemID completion:^(NSDictionary * _Nonnull dict, NSError * _Nonnull error) {
                                 
                                if(dict) {
                                    Product *prod = [[Product alloc] initWithDictionary:dict :nil:@""];
                                    [output addObject:prod];
                                    if(output.count >= 1) {
                                         
                                        completion(output,nil);
                                      
                                    }
                                }
                            }];
                         
                        }
                        
                    } else {
                        [ScanViewController updateAlternativeData:alternatives];
      
                    }
                }
        }
    }];
    [dataTask resume];
     
    
    return foodDict;
}



//retrieves nutrition info of search result from Nutritionix
+ (NSDictionary*)getNutritionInfo:(NSString *)foodName completion:(void(^)(NSDictionary *dictComp, NSError *error))completion {
       
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    
    appID = [dict objectForKey: @"app_Id"];
    appKey = [dict objectForKey: @"app_Key"];
    
    headers = @{ @"x-app-id": appID, @"x-app-key": appKey , @"x-remote-user-id": @"0"};
        
    //create request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseURLStringNutrition]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    
    NSString *string = [NSString stringWithFormat:@"query="];
    NSString *dataString = [string stringByAppendingString:foodName];
    NSData *postData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
      
    [request setHTTPBody:postData];
      
    //send request
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
                NSLog(@"%@", error.localizedDescription);
        } else {
                //print out the http response
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                NSLog(@"%@", httpResponse);
                                                         
                //use json serialization to print out dictionary
                NSString *strISOLatin = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                NSData *dataUTF8 = [strISOLatin dataUsingEncoding:NSUTF8StringEncoding];
 
                id dict = [NSJSONSerialization JSONObjectWithData:dataUTF8 options:0 error:&error];
                if (dict != nil) {
                   NSLog(@"Dict: %@", dict);
                  NSDictionary *temp = dict[@"foods"];
                    foodNutrition = temp;
                    [ScanViewController updateCommonFoodData:foodNutrition];
                      
                } else {
                   NSLog(@"Error: %@", error);
                }
                          
        }
    }];
    [dataTask resume];
    
    return foodNutrition; 
}



//retrieves item info from Open Food Facts
+ (NSDictionary*)getFoodFacts:(NSString *)upc completion:(void(^)(NSDictionary *dict, NSError *error))completion {
    //START
    NSString *newFullURL = [newBase stringByAppendingString:upc];
      
    //create request
    NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newFullURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [newRequest setHTTPMethod:@"GET"];
 
    //send request
    NSURLSession *newSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *newDataTask = [newSession dataTaskWithRequest:newRequest
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error.localizedDescription); 
                                                    } else {
                                            
                                                        //use json serialization to print out dictionary
                                                        NSString *strISOLatin = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                                                        NSData *dataUTF8 = [strISOLatin dataUsingEncoding:NSUTF8StringEncoding];

                                                        id dict = [NSJSONSerialization JSONObjectWithData:dataUTF8 options:0 error:&error];
                                                        if (dict != nil) {
                                                           
                                                            foodFactsDict = dict[@"product"];
                                                            NSLog(@"Dict: %@", foodFactsDict);
                                                            [ScanViewController updateData:foodDict :foodFactsDict : upc];
                                                             
                                                        } else {
                                                            NSLog(@"Error: %@", error);
                                                        }
                                                        
                                                
                                                     
                                                    }
                                                }];
   [newDataTask resume];
     
    return foodFactsDict;
}
 
@end

