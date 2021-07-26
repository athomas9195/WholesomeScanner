//
//  FoodCell.h
//  Wholesome
//
//  Created by Anna Thomas on 7/24/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FoodCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *foodLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

NS_ASSUME_NONNULL_END
