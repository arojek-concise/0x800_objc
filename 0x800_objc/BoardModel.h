//
//  BoardModel.h
//  0x800_objc
//
//  Created by Artur Rojek on 23/02/15.
//  Copyright (c) 2015 Artur Rojek. All rights reserved.
//

@interface BoardModel : NSObject

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSInteger rows;
@property (nonatomic, readonly) NSInteger cols;

@property (nonatomic, readonly) NSString *refreshBoardNotif;
@property (nonatomic, readonly) NSString *gameOverNotif;

+ (instancetype)sharedInstance;
- (instancetype)init;
- (void)clear;
- (NSInteger)valueFor:(NSInteger)x secondParameter:(NSInteger)y;
- (void) draw;
- (void) moveUp;
- (void) moveDown;
- (void) moveLeft;
- (void) moveRight;

@end

