//
//  ViewController.m
//  性能优化—启动优化
//
//  Created by 赵鹏 on 2019/9/3.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
 APP的启动可以分为两种：
 1、冷启动（Cold Launch）：从零开始启动APP；
 2、热启动（Warm Launch）：APP已经在内存中了，在后台存活着了，再次点击图标启动APP；
 APP启动时间的优化主要是针对冷启动进行的优化。
 
 通过添加环境变量可以打印出APP的启动时间分析：Edit scheme -> Run -> Arguments，然后在Arguments界面中的Environment Variables部分中添加"DYLD_PRINT_STATISTICS"并且设置它的值为1。如果想要知道更详细的信息就需要把"DYLD_PRINT_STATISTICS"修改为"DYLD_PRINT_STATISTICS_DETAILS"并且设置它的值为1。
 
 APP的冷启动可以概括为三大阶段：
 1、dyld(dynamic link editor)：dyld是Apple的动态链接器，可以用来装载Mach-O文件（可执行文件、动态库等）。当启动APP以后，dyld会装载APP的可执行文件，同时会递归加载所有依赖的动态库，当dyld把可执行文件、动态库都装载完毕后，会通知Runtime进行下一步的处理；
 2、runtime：先调用map_images，进行可执行文件内容的解析和处理。然后在load_images中调用call_load_methods，调用所有的Class和Category的+load方法。然后再进行各种objc结构的初始化（注册Objc类 、初始化类对象等等）。然后调用C++静态初始化器和__attribute__((constructor))修饰的函数；
 到此为止，可执行文件和动态库中所有的符号(Class，Protocol，Selector，IMP，…)都已经按格式成功加载到内存中了，被runtime所管理；
 3、调用main函数。
 综上所述：APP的启动由dyld主导，将可执行文件加载到内存，顺便加载所有依赖的动态库，并由runtime负责加载成objc定义的结构。所有初始化工作结束以后，dyld就会调用main函数，接下来就是调用UIApplicationMain函数和AppDelegate文件中的application:didFinishLaunchingWithOptions:方法了。
 
 APP的冷启动优化：
 按照上述的三个阶段来进行优化：
 1、dyld：
 （1）减少动态库、合并一些动态库（定期清理不必要的动态库）；
 （2）减少Objc类、分类的数量、减少Selector数量（定期清理不必要的类、分类）；
 （3）减少C++虚函数的数量；
 （4）Swift尽量使用struct。
 2、runtime：
 用+initialize方法和dispatch_once取代所有的__attribute__((constructor))、C++静态构造器和ObjC的+load；
 3、main：
 （1）在不影响用户体验的前提下，尽可能将一些操作延迟，不要全部都放在finishLaunching方法中；
 （2）按需加载。
 */
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
