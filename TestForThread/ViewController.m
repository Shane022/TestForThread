//
//  ViewController.m
//  TestForThread
//
//  Created by new on 16-5-31.
//  Copyright (c) 2016年 new. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testForThread];
}

- (void)testForThread {
    /*
    // 创建队列，第二个参数用来表示创建的队列是串行的还是并行的，传入 DISPATCH_QUEUE_SERIAL 或 NULL 表示创建串行队列。传入 DISPATCH_QUEUE_CONCURRENT 表示创建并行队列。
    dispatch_queue_t newQueue = dispatch_queue_create("testForDispatchQueue", nil);
    dispatch_queue_t syncQueue = dispatch_queue_create("syncQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t asyncQueue = dispatch_queue_create("asyncQueue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_queue_t asyncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    // 创建异步任务，将任务放到异步队列中去执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"testForThread");
    });
    */
    
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSThread *curThread = [NSThread currentThread];
        curThread.name = @"Thread1";
        for (int i = 0; i < 5; i++) {
            NSLog(@"%d - currentThreadName:%@",i,curThread.name);
        }
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSThread *curThread = [NSThread currentThread];
        curThread.name = @"Thread2";
        for (int i = 0; i < 3; i++) {
            NSLog(@"%d - currentThreadName:%@",i,curThread.name);
        }
        dispatch_group_leave(group);
    });
    // 所有任务完成后进行通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"finish");
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
