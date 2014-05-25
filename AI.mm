#import "AI.h"
#import "2048.cpp"

@implementation AI
+(NSInteger)bestMoveForArray:(NSArray*)array{
    static dispatch_once_t once;
    dispatch_once(&once, ^ { 
	init_tables();
    });
    return find_best_move([AI boardForArray:array]);
 }
+(uint64_t)boardForArray:(NSArray*)array{
    uint64_t retVal = 0;
    for(int i=15; i>=0; i--){
	int val = [array[i][0] integerValue];
	uint64_t power = (uint64_t)log2(val);
	retVal |= power << (4*i);
    }
    return retVal;
}
@end
