//
//  ViewController.m
//  TestForThread
//
//  Created by new on 16-5-31.
//  Copyright (c) 2016年 new. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

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
    
    /*
    // GCD
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
    */
    
    /*
    // NSOperation和NSOperationQueue
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    // 设置NSOperationQueue的最大并发数，如果是1那么是串行队列
    operationQueue.maxConcurrentOperationCount = 1;
    // 添加任务
    [operationQueue addOperationWithBlock:^{
        NSLog(@"operationQueue addOperationWithBlock");
    }];
    */
    
    /*
    // NSOperation依赖方法使用
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        // task
        NSLog(@"operation1");
    }];
    // 添加任务,该方法需在start方法之前执行
    [operation1 addExecutionBlock:^{
        NSLog(@"operation1 add new task");
    }];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation2");
    }];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation3");
    }];
    [operation2 addDependency:operation1];
    [operation3 addDependency:operation2];
    NSOperationQueue *dependecyQueue = [[NSOperationQueue alloc] init];
    [dependecyQueue addOperations:@[operation3, operation1, operation2] waitUntilFinished:NO];
    */
    
    // 延时执行
    Person *person = [[Person alloc] init];
    person.name = @"testuser";
    person.age = 20;
    [self performSelector:@selector(testForDelayAction:) withObject:person afterDelay:1.5];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"dispatch_after() function isMainThread:%@",[NSThread currentThread].isMainThread?@"yes":@"no");
        [self testForDelayAction:person];
    });
    
    
    dispatch_queue_t queue = dispatch_queue_create("temQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"temQueue isMainThread:%@",[NSThread currentThread].isMainThread?@"yes":@"no");
        Person *temPerson = [[Person alloc] init];
        temPerson.name = @"temPerson";
        temPerson.age = 20;
        dispatch_after(3, queue, ^{
//            NSLog(@"dispatch_after function isMainThread:%@",[NSThread currentThread].isMainThread?@"yes":@"no");
            [self testForDelayAction:temPerson];
        });
    });
}

- (void)testForDelayAction:(id)object {
    Person *person = (Person *)object;
    NSLog(@"delay action, person's name is %@",person.name);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
