#import <UIKit/UIKit.h>

@interface UIBezierPath (dqd_arrowhead)

/** 画带箭头的直线
 *  https://stackoverflow.com/questions/13528898/how-can-i-draw-an-arrow-using-core-graphics/37985645#37985645
 */
+ (UIBezierPath *)dqd_bezierPathWithArrowFromPoint:(CGPoint)startPoint
                                           toPoint:(CGPoint)endPoint
                                         tailWidth:(CGFloat)tailWidth
                                         headWidth:(CGFloat)headWidth
                                        headLength:(CGFloat)headLength;

@end
