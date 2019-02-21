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

/** 画带箭头的直线，从圆1表面指向圆2表面（要求两圆半径相同）
 *  从fromCircleCenter指向toCircleCenter，箭头为等边三角形
 *  radius 圆的半径
 */
+ (UIBezierPath *)bezierPathWithArrowFrom:(CGPoint)fromCircleCenter
                                       to:(CGPoint)toCircleCenter
                                   radius:(CGFloat)radius;

@end
