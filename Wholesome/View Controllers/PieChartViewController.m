//
//  PieChartViewController.m
//  Wholesome
//
//  Created by Anna Thomas on 7/20/21.
//

#import "PieChartViewController.h"
#import "XYPieChart.h"
#import <QuartzCore/QuartzCore.h>

@interface PieChartViewController ()  <XYPieChartDelegate, XYPieChartDataSource>
@property (weak, nonatomic) IBOutlet XYPieChart *pieChart;
@property(nonatomic, strong) NSArray        *sliceColors; 
 
//"nf_total_carbohydrate" = 11;
//"nf_saturated_fat" = 0;
//"nf_sodium" = 300;
//"nf_dietary_fiber" = 4;
//"nf_protein" = 3;
 
@end

@implementation PieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Do any additional setup after loading the view.
    float viewWidth = self.pieChart.bounds.size.width / 2;
    float viewHeight = self.pieChart.bounds.size.height / 2;
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setStartPieAngle:M_PI_2];
    [self.pieChart setAnimationSpeed:1.5];
    [self.pieChart setLabelColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
    [self.pieChart setLabelShadowColor:[UIColor darkGrayColor]];
    [self.pieChart setShowPercentage:NO];
    [self.pieChart setPieBackgroundColor:[UIColor whiteColor]];
    [self.pieChart setLabelRadius:160];

    //To make the chart at the center of view
    [self.pieChart setPieCenter:CGPointMake(self.pieChart.bounds.origin.x + viewWidth, self.pieChart.bounds.origin.y + viewHeight)];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor systemYellowColor],
                       [UIColor systemOrangeColor],
                       [UIColor orangeColor],
                       [UIColor systemGreenColor],
                       [UIColor greenColor],nil];

    //Method to display the pie chart with values.
    [self.pieChart reloadData];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChart reloadData];
}


//Specify the number of Sectors in the chart
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return 5;
}
//Specify the Value for each sector
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

//configure the pie chart slice labels 
- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index {
    if(index == 0) {
        return @"Carbs";
    } else if(index == 1) {
        return @"Fat";
    } else if(index == 2) {
        return @"Sodium";
    } else if(index == 3) {
        return @"Fiber";
    } else {
        return @"Protein";
    }
}

//Specify color for each sector
- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
