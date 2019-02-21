// To the extent possible under law, I (Rob Mayoff, the author of this work) have waived
// all copyright and related or neighboring rights to this work, in accordance with
// the CC0 1.0 Universal Public Domain Dedication.  Please see this page
// for details: http://creativecommons.org/publicdomain/zero/1.0/

#import "UIBezierPath+dqd_arrowhead.h"

#define kArrowPointCount 7

@implementation UIBezierPath (dqd_arrowhead)

+ (UIBezierPath *)bezierPathWithArrowFrom:(CGPoint)fromCircleCenter
                                       to:(CGPoint)toCircleCenter
                                   radius:(CGFloat)r {
    float from_x = fromCircleCenter.x;
    float from_y = fromCircleCenter.y;
    float to_x = toCircleCenter.x;
    float to_y = toCircleCenter.y;
    
    //画线
    float angle1,line_from_x,line_from_y,line_to_x,line_to_y;
    angle1 = atanf((to_x - from_x) / (to_y - from_y));
    
    if (from_y > to_y) { //一二象限
        line_from_x = -sinf(angle1) * r + from_x;
        line_from_y = -cosf(angle1) * r + from_y;
        line_to_x = sinf(angle1) * r + to_x;
        line_to_y = cosf(angle1) * r + to_y;
    } else { //三四象限
        line_from_x = sinf(angle1) * r + from_x;
        line_from_y = cosf(angle1) * r + from_y;
        line_to_x = -sinf(angle1) * r + to_x;
        line_to_y = -cosf(angle1) * r + to_y;
    }
    
    float line_distance = hypotf(line_to_y - line_from_y, line_to_x - line_from_x);
    float headWidth = line_distance > 40 ? 20 : MAX(line_distance/2, 8);
    
    //画顶点箭头
    UIBezierPath* path = [UIBezierPath dqd_bezierPathWithArrowFromPoint:CGPointMake(line_from_x, line_from_y) toPoint:CGPointMake(line_to_x, line_to_y) tailWidth:3 headWidth:headWidth headLength:headWidth/5*4];
    return path;
}

+ (UIBezierPath *)dqd_bezierPathWithArrowFromPoint:(CGPoint)startPoint
                                           toPoint:(CGPoint)endPoint
                                         tailWidth:(CGFloat)tailWidth
                                         headWidth:(CGFloat)headWidth
                                        headLength:(CGFloat)headLength {
    CGFloat length = hypotf(endPoint.x - startPoint.x, endPoint.y - startPoint.y);

    CGPoint points[kArrowPointCount];
    [self dqd_getAxisAlignedArrowPoints:points
                              forLength:length
                              tailWidth:tailWidth
                              headWidth:headWidth
                             headLength:headLength];

    CGAffineTransform transform = [self dqd_transformForStartPoint:startPoint
                                                          endPoint:endPoint
                                                            length:length];

    CGMutablePathRef cgPath = CGPathCreateMutable();
    CGPathAddLines(cgPath, &transform, points, sizeof points / sizeof *points);
    CGPathCloseSubpath(cgPath);

    UIBezierPath *uiPath = [UIBezierPath bezierPathWithCGPath:cgPath];
    CGPathRelease(cgPath);
    return uiPath;
}

+ (void)dqd_getAxisAlignedArrowPoints:(CGPoint[kArrowPointCount])points
                            forLength:(CGFloat)length
                            tailWidth:(CGFloat)tailWidth
                            headWidth:(CGFloat)headWidth
                           headLength:(CGFloat)headLength {
    CGFloat tailLength = length - headLength;
    points[0] = CGPointMake(0, tailWidth / 2);
    points[1] = CGPointMake(tailLength, tailWidth / 2);
    points[2] = CGPointMake(tailLength, headWidth / 2);
    points[3] = CGPointMake(length, 0);
    points[4] = CGPointMake(tailLength, -headWidth / 2);
    points[5] = CGPointMake(tailLength, -tailWidth / 2);
    points[6] = CGPointMake(0, -tailWidth / 2);
}

+ (CGAffineTransform)dqd_transformForStartPoint:(CGPoint)startPoint
                                       endPoint:(CGPoint)endPoint
                                         length:(CGFloat)length {
    CGFloat cosine = (endPoint.x - startPoint.x) / length;
    CGFloat sine = (endPoint.y - startPoint.y) / length;
    return (CGAffineTransform){ cosine, sine, -sine, cosine, startPoint.x, startPoint.y };
}

@end
