

#import "UIFont+CustomFont.h"

@implementation UIFont (CustomFont)

+(UIFont *)fontWithSizeForYu:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"Heiti SC" size:fontSize];
}

+(UIFont *)fontWithSizeForYaPi:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"YuppySC-Regular" size:fontSize];
}

+(UIFont *)fontWithSizeForHuakangshaonv:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"DFPShaoNvW5-GB" size:fontSize];
}

@end
