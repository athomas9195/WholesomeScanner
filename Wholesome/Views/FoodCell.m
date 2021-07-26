//
//  FoodCell.m
//  Wholesome
//
//  Created by Anna Thomas on 7/24/21.
//

#import "FoodCell.h"
#import <Parse/Parse.h>

@implementation FoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.selectButton setSelected:FALSE];
}

//post the selected item to parse
- (IBAction)didSelectItem:(id)sender {
    
    [self.selectButton setSelected:TRUE];
    
    //send comment to parse backend
    PFUser *current = [PFUser currentUser];
     
    if(current[@"itemsToAvoid"] == nil) {
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:self.foodLabel.text, nil];
        current[@"itemsToAvoid"] = arr;
    } else {
        NSMutableArray *itemArray = current[@"itemsToAvoid"];
        [itemArray insertObject:self.foodLabel.text atIndex:0];
        current[@"itemsToAvoid"] = itemArray;    
    }
    
    [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error!= nil) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
     
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
