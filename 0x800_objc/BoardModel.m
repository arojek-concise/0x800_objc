//
//  BoardModel.m
//  0x800_objc
//
//  Created by Artur Rojek on 23/02/15.
//  Copyright (c) 2015 Artur Rojek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BoardModel.h"


@interface BoardModel () {
    NSInteger values[4][4];
}
@end

@implementation BoardModel


+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _score = 0;
        _rows = 4;
        _cols = 4;

        _refreshBoardNotif = @"REFRESH_BOARD";
        _gameOverNotif = @"GAME_OVER";
        
        memset(values, 0, sizeof(values));
    }
    return self;
}

- (void)clear {
    _score = 0;
    for (int i=0;i<_cols;i++) {
        for (int j=0;j<_rows;j++) {
            values[i][j] = 0;
        }
    }
    [self draw];
    [self draw];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:_refreshBoardNotif object:nil];
}

- (NSInteger)valueFor:(NSInteger)x secondParameter:(NSInteger)y {
    return values[x-1][y-1];
}

- (void) draw {
    NSInteger count = [self getEmptyFieldsNumber];

    // New tile generation logic
    if (count > 0) {
        while (YES) {
            NSInteger index = (long)arc4random_uniform(16*1000)/1000;
            if (!values[index%4][index/4]) {
                values[index%4][index/4] = 2;
                return;
            }
        }

    // Original tile generation logic
//        NSInteger index = (NSInteger)arc4random_uniform((UInt32)count);
//        NSLog(@"Drew: %ld", index);
//        for (NSInteger i = 0; i < _cols; ++i) {
//            for (NSInteger j = 0; j < _rows; ++j) {
//                if (values[i][j] == 0) {
//                    if (index-- <= 0) {
//                        // enter initial value
//                        values[i][j] = 2;
//                        return;
//                    }
//                }
//            }
//        }

    } else if ([self isBoardBlocked]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:_gameOverNotif object:nil];
    }
}

- (NSInteger) getEmptyFieldsNumber {
    NSInteger count = 0;
    for (NSInteger i = 0; i < _cols; ++i) {
        for (NSInteger j = 0; j < _rows; ++j) {
            if (values[i][j] == 0) {
                count++;
            }
        }
    }
    
    return count;
}

- (bool) isBoardBlocked {
    for (int i = 0; i < _cols - 1; ++i) {
        for (int j = 0; j < _rows; ++j) {
            if (!values[i][j] || !values[i+1][j] || values[i][j] == values[i+1][j]) {
                return false;
            }
        }
    }
    
    for (int i = 0; i < _cols; ++i) {
        for (int j = 0; j < _rows - 1; ++j) {
            if (!values[i][j] || !values[i][j+1] || values[i][j] == values[i][j+1]) {
                return false;
            }
        }
    }
    
    return true;
}

// MARK: Moving

- (void) moveUp {
    bool moved = NO;
    
    for (NSInteger i = 0; i < _cols; ++i) {
        NSMutableArray *data = [[NSMutableArray alloc]init];
        
        for (NSInteger j = 0; j < _rows; ++j) {
            [data addObject:@(values[i][j])];
        }
        
        data = [self shift: data varMoved: &moved];
        // restore
        for (NSInteger j = 0; j < _rows; ++j) {
            values[i][j] = [data[j] integerValue];
        }
    }

    if (moved) {
        [self draw];
    } else if ([self isBoardBlocked]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:_gameOverNotif object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:_refreshBoardNotif object:nil];
}

- (void) moveDown {
    bool moved = NO;
    for (NSInteger i = 0; i < _cols; ++i) {
        NSMutableArray *data = [[NSMutableArray alloc]init];
        
        for (NSInteger j = 0; j < _rows; ++j) {
            [data addObject:@(values[i][_rows-j-1])];
        }
        
        data = [self shift: data varMoved: &moved];
        // restore
        for (NSInteger j = 0; j < _rows; ++j) {
            values[i][j] = [data[_rows-j-1] integerValue];
        }
    }
    
    if (moved) {
        [self draw];
    } else if ([self isBoardBlocked]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:_gameOverNotif object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:_refreshBoardNotif object:nil];
}

- (void) moveLeft {
    bool moved = NO;
    for (NSInteger j = 0; j < _rows; ++j) {
        NSMutableArray *data = [[NSMutableArray alloc]init];
        
        for (NSInteger i = 0; i < _cols; ++i) {
            [data addObject:@(values[i][j])];
        }
        
        data = [self shift: data varMoved: &moved];
        // restore
        for (NSInteger i = 0; i < _cols; ++i) {
            values[i][j] = [data[i] integerValue];
        }
    }
    
    if (moved) {
        [self draw];
    } else if ([self isBoardBlocked]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:_gameOverNotif object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:_refreshBoardNotif object:nil];
}

- (void) moveRight {
    bool moved = NO;
    for (NSInteger j = 0; j < _rows; ++j) {
        NSMutableArray *data = [[NSMutableArray alloc]init];
        
        for (NSInteger i = 0; i < _cols; ++i) {
            [data addObject:@(values[_cols-i-1][j])];
        }
        
        data = [self shift: data varMoved: &moved];
        // restore
        for (NSInteger i = 0; i < _cols; ++i) {
            values[i][j] = [data[_cols-i-1] integerValue];
        }
    }
    
    if (moved) {
        [self draw];
    } else if ([self isBoardBlocked]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:_gameOverNotif object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:_refreshBoardNotif object:nil];
}

// TODO: Should be private
- (NSMutableArray *) shift: (NSMutableArray *)data varMoved: (bool *)moved {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSMutableArray *lock = [[NSMutableArray alloc] init];
    NSInteger size = [data count];
    
    for (int i = 0; i < size; ++i) {
        if ([data[i] integerValue] != 0) {
            [lock addObject:@-1];
        } else {
            [lock addObject:@0];
        }
    }
    
    // loop
    bool loop = true;
    
    while (loop) {
        loop = false;
        // shrink tiles
        data = [self shrink: data varMoved: moved];
        
        // merge tiles with same values
        for (int k = 0; k < (int)[data count] - 1; ++k) {
            if ([data[k] integerValue] == [data[k+1] integerValue]) {
                if ([lock[k] integerValue] != 1 && [lock[k+1] integerValue] != 1) {
                    data[k] = @([data[k] integerValue] * 2);
                    data[k+1] = @0;
                    loop = true;
                    _score += [data[k] integerValue];
                    lock[k] = @1;
                    lock = [self shrink: lock varMoved: nil];
                    
                }
            }
        }
        
    }
    
    // now, return back the shifted data
    for (int i = 0; i < size; ++i) {
        if (i < [data count]) {
            [result addObject:data[i]];
        } else {
            [result addObject:@0];
        }
    }
    
    return result;
}

- (NSMutableArray *) shrink: (NSMutableArray *) data varMoved: (bool *)moved{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    bool isEmpty = false;
    
    for (NSNumber *value in data) {
        if ([value integerValue]) {
            [result addObject:value];
            if (isEmpty && moved) {
                *moved = YES;
            }
        } else {
            isEmpty = true;
        }
    }
    
    return result;
}

@end