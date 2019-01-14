/// Dart 使用说明
/// 1 Dart是强类型的，但类型声明是可选的，因为Dart可以推断类型，如果要明确说明不需要任何类型，则使用dynamic
///  List<int>  整数列表
///  List<dynamic> 任何类型的对象列表
///
/// 2 变量
///  String name = "Bob"; 显式声明类型
///  var name = "BOb";  name变量的类型被推断为String，但可以指定它来更改
///  dynamic name = "Bob"; 若变量不限制于单一类型，则应声明对象为dynamic
///  int line;  未初始化的变量初始值为null，变量中存放的所有东西都是对象，所有对象都继承自Object类
///  final a; 最终变量，只能设置一次，最终顶级货类变量在第一次使用时被初始化
///  const b; 编译时常量，注意实例变量可以是final，但不能是const
///  var foo = const[]; const关键字不只是声明常量变量。您还可以使用它来创建常量值，以及声明创建常量值的构造函数
///  foo = [1,2,3];  可以更改一个非final的非const变量的值，即使它曾经有一个const值
///
/// 3 内建类型
///  可以使用字面量初始化任何内建类型的对象，可以使用构造函数来初始化变量
///  数字num:
///   int: 平台的不同,范围也不同。整数值不大于64位。在Dart VM上，值可以从-2^63到2^63 - 1
///   double: 64位(双精度)浮点数
///   数字和字符串转换 int.parse('1') 3.14159.toStringAsFixed(2);
///  字符串String:
///   是UTF-16编码单元的序列，可以使用${expression}将表达式的值放入字符串中。如果表达式是一个标识符，可以不用{},
///   可以用三重引号创建多行字符串，用r前缀创建一个原始字符串（不会因为有\n换行）
///  布尔型(bool):true, false
///
///  列表List:
///   数组即为列表对象，
///   var list = [1,2,3]; 推断为List<int> 类型，若添加非int对象，则会报错
///  映射Map:
///   可以通过map字面量直接创建，也可以通过Map()构造方法创建, 类型会自动推断
///   var g = { 1: 'a', 2: 'b', 3: 'c'}
///   var g1 = Map();
///   g1[1] = 'a1'
///   final constantMap = const {2: 'b', 3: 'c'};
///  字符Runes:
///   字符是字符串的UTF-32编码
///  符号Symbols:
///   #bar
///
/// 4 运算符
///   取摸
///   assert(5 ~/ 2 == 2);
///   相等(==)
///   若两者都为空则返回true，若只有一空返回false；返回调用x.=(y) 的结果
///   需要知道两个对象是否完全相同的情况下，可以使用identical()函数)
///   类型测试
///   若obj 实现了T，则 obj is T 为真
///   as操作符将对象转换为特定类型
///   赋值
///   b ??= value; 仅仅在b为空的情况下b被赋值value否则b的值不变
///   条件表达式
///   expr1 ?? expr2  如果expr1是非空的，则返回其值;否则，计算并返回expr2的值
///   级联 (..)
///   在同一个对象上创建一个操作序列,可以访问同一对象上的字段,调用函数，省去创建临时变量的步骤
///   不能再一个返回void结果上继续构建级联操作
///   其他
///   ?. 根据条件访问成员，foo?.bar 如果foo为空则返回null
///
/// 5 函数Function
///   函数也是对象，可以赋给函数，也可以赋给变量，甚至可以使函数的返回值。函数可以省略返回类型声明，所有函数都有返回一个值，默认返回null
///   isBelowZero(int n) => n < 0; 只包含一个表达式的函数简写
///   命名参数：
///   在定义函数时，使用{param1, param2，…}来指定命名参数
///   void enableFlags({bool bold, bool hidden}) {...}
///   enableFlags(bold: true, hidden: false);
///   可选参数:
///   在普通的位置参数里，可以通过[]包装为一组可选参数，在命名参数里，可以通过@required标识必传参数，其他都是可选的。
///   say(String from, String msg, [String device])
///   Scrollbar({Key key, @required Widget child})
///   默认参数：
///   用 = 来定义参数的默认值。默认值必须是编译时常量。如果没有提供默认值，则默认值为null
///   void enableFlags({bool bold = false, bool hidden = false})
///   main()函数:
///   应用程序的入口点。返回void，并有一个可选的列表参数作为参数
///   void main(List<String> arguments) {
///     print(arguments);
///     assert(arguments.length == 2);
///     assert(int.parse(arguments[0]) == 1);
///     assert(arguments[1] == 'test');
///   }
///   匿名函数:
///     ([[Type] param1[, …]]) {
///     codeBlock;
///     };
///   函数类型：
///   typedef或function-type为函数提供一个类型别名
///     typedef Compare<T> = int Function(T a, T b);
///     int sort(int a, int b) => a - b;
///     void main() {
///       assert(sort is Compare<int>); // True!
///     }
///
/// 6 流程控制
///   若对象是可迭代的
///   candidates.forEach((candidate) => candidate.interview());
///   List和Set等支持for in迭代
///   for (var x in collection) { }
///   过滤器where
///   即使where筛选后为空也没问题，只是不会执行后面的forEach
///   candidates
///    .where((c) => c.yearsExperience >= 5)
///    .forEach((c) => c.interview());
///   switch
///   每个非空的case子句以一个break语句结束,否则会报错,default 可以没有。
///
/// 7 异常处理
///   Dart的所有异常都是未检查异常，不要求去声明和捕获，异常有Exception和Error类型
///   throw可以抛出异常或者其他非空对象（比如String）
///   void distanceTo(Point other) => throw "OutOfLlamas"
///   try {
///     distanceTo(Point());
///   } on OutOfLlamasException catch(e){
///      print(e）；
///   } catch (e) {
///     print(e);
///   }
///   rethrow 捕获处理异常后，再允许其传播
///
/// 8 类
///   所有类都是Object子类，并且是单继承
///   泛型的使用（类型校验，减少代码冲怒）
///   var nmae = List<String>();
///   class Foo<T extends BaseClass> {
///
///   }
///   导入库
///   import
///   import 'package:lib1/lib1.dart';
///   import 'package:lib2/lib2.dart' as lib2; 导入有冲突时指定前缀
///   import 'package:lib1/lib1.dart' show foo; 只导入foo
///   import 'package:lib2/lib2.dart' hide foo; 除了foo其他导入
///   import 'package:greetings/hello.dart' deferred as hello; 延时加载
///   Future greet() async {
///     await hello.loadLibrary(); 需要时加载，可以在库上多次调用loadLibrary()。该库只加载一次
///     hello.printGreeting();
///   }
///   可调用类
///   类实现call方法，则可以通过类对象直接调用函数
///
/// 9 异步
///   await必须是在一个使用async标注的异步函数使用,await表达式会让程序执行挂起，直到返回的对象可用
///   在await表达式中，表达式的值通常是一个Future对象。如果不是，那么这个值将被自动包装成Future
///   Future checkVersion() async {
///     var version = await lookUpVersion();
///     Do something with version
///   }
///   声明异步函数
///   函数体用async修饰符标记，将使其返回一个Future，如果您的函数没有返回一个有用的值，那么将其返回Future<void>类型
///   String lookUpVersion() => '1.0.0' 同步函数
///   Future<String> lookUpVersion() async => '1.0.0'; 异步函数
///   流处理
///   Future main() async {
///     // ...
///   await for (var request in requestServer) {
///    handleRequest(request);
///   }
///     // ...
///   }
///   隔离器
///   不同于线程，所有Dart代码都运行在隔离器内部，而不是线程。每个隔离都有它自己的内存堆，确保任何其他隔离器都不能访问隔离状态
///
/// 10 生成器
///   同步生成器：将函数体标记为sync*，并使用yield语句传递值。返回Iterable对象
///   Iterable<int> naturalsTo(int n) sync* {
///     int k = 0;
///     while (k < n) yield k++;
///   }
///   异步生成器：将函数体标记为async*，并使用yield语句传递值，返回Iterable对象
///   Stream<int> asynchronousNaturalsTo(int n) async* {
///     int k = 0;
///     while (k < n) yield k++;
///   }
///
///
///
///

class WannabeFunction {
  call(String a, String b, String c) => '$a $b $c!';
}

printInteger(int n) {
  print('the number is $n');
}

// 只包含一个表达式的函数简写
isBelowZero(int n) => n < 0;

// 返回一个加上addBy的函数
Function makeAdder(num addBy) {
  // 返回一个匿名函数
  return (num i) => addBy + i;
}

main() {
  var number = 26;
  print(isBelowZero(number));
  printInteger(number);
  // 原始字符串
  var s = r'In a raw string, not even \n gets special treatment.';
  print(s);
  // 符号类型
  print(#bar);
  // 匿名函数
  var list = ['apples', 'bananas', 'oranges'];
  list.forEach((item) {
    print('${list.indexOf(item)}: $item');
  });
  // 函数作为函数的返回值
  var add2 = makeAdder(2);
  var add4 = makeAdder(4);
  print(add2(3));
  print(add4(3));
  var wf = new WannabeFunction();
  var out = wf("Hi", "there,", "gang");
  print('$out');
}
