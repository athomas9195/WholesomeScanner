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

static NSString * const baseURLString = @"https://trackapi.nutritionix.com/v2/search/item?upc=";
static NSString * const newBase = @"https://us.openfoodfacts.org/api/v0/product/";
static NSDictionary *foodDict;  //stores the nutritionix dictionary
static NSDictionary *headers; //stores the headers like app id and key
static NSString *appID;
static NSString *appKey;
static NSDictionary *foodFactsDict; //stores the dict from open food facts

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
                

                } else {
                   NSLog(@"Error: %@", error);
                }
                                                        
        }
    }];
    [dataTask resume];
    
    return foodDict;
    
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
                                                            NSLog(@"Dict: %@", dict);
                                                            foodFactsDict = dict[@"product"];
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

