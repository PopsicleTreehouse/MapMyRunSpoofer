#import <UIKit/UIKit.h>

// @interface StatsCell : UITableViewCell
// @end
@interface UITableViewCellContentView : UIView
@property (nonatomic, assign) BOOL presentedSpoofingAlert;
-(void)spoofRunDetailsWithItems:(NSDictionary *)items;
@end

%hook UITableViewCellContentView
%property (nonatomic, assign) BOOL presentedSpoofingAlert;
%new
-(void)spoofRunDetailsWithItems:(NSDictionary *)items {
	NSString *newDistance = [items objectForKey:@"distance"];
	NSString *newDuration = [items objectForKey:@"duration"];
	UILabel *distanceLabel = [self.subviews objectAtIndex:2];
	UILabel *durationLabel = [self.subviews objectAtIndex:4];
	UILabel *paceLabel = [self.subviews objectAtIndex:6];
	[distanceLabel setText:newDistance];
	[durationLabel setText:newDuration];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"mm:ss";
	NSDate *durationDate = [formatter dateFromString:newDuration];
	formatter.dateFormat = @"mm";
	int minutes = [[formatter stringFromDate:durationDate] intValue];
	formatter.dateFormat = @"ss";
	int seconds = [[formatter stringFromDate:durationDate] intValue];
	float timeInMinutes = (float)seconds / 60 + minutes;
	NSLog(@"spoofer timeInMinutes: %f", timeInMinutes);
	float pace = [newDistance floatValue] / (float)(timeInMinutes);
	NSString *paceString = [NSString stringWithFormat:@"%.2f", pace];
	[paceLabel setText:paceString];
}
-(void)layoutSubviews {
	if([self.superview class] != objc_getClass("iMapMy3.StatsCell") || self.presentedSpoofingAlert) {
		return;
	}
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"MapMyRun" message: @"Input Distance and Duration" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Distance";
    }];
	[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Duration";
    }];
	[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray *textfields = alertController.textFields;
        UITextField *distanceField = textfields[0];
        UITextField *durationField = textfields[1];
		NSDictionary *dict = @{@"distance": distanceField.text, @"duration": durationField.text};
		[self spoofRunDetailsWithItems:dict];
    }]];
	[alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
	UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
	[topVC presentViewController:alertController animated:YES completion:nil];
	self.presentedSpoofingAlert = YES;
	%orig;
}
%end

// %hook WorkoutDetailsViewController
// - (id)initWithRef:(id)arg1 provider:(id)arg2 tpSession:(id)arg3 {
// 	NSLog(@"spoofer view init %@ arg1: %@ %@ arg2: %@ %@ arg3: %@ %@", NSStringFromSelector(_cmd), arg1, [arg1 class], arg2, [arg2 class], arg3, [arg3 class]);
// 	return %orig;
// }
// - (id)initWithWorkout:(id)arg1 provider:(id)arg2 {
// 	NSLog(@"spoofer view init %@ arg1: %@ %@ arg2: %@ %@", NSStringFromSelector(_cmd), arg1, [arg1 class], arg2, [arg2 class]);
// 	return %orig;
// }
// - (id)initWithRef:(id)arg1 provider:(id)arg2 {
// 	NSLog(@"spoofer view init %@ arg1: %@ %@ arg2: %@ %@", NSStringFromSelector(_cmd), arg1, [arg1 class], arg2, [arg2 class]);
// 	return %orig;
// }
// -(void)viewDidLoad {
// 	%orig;
// 	NSLog(@"spoofer view loaded");
// }
// %end
// %ctor {
// 	%init(WorkoutDetailsViewController = objc_getClass("iMapMy3.WorkoutDetailsViewController"));
// }