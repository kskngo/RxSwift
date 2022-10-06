/*:
 > # IMPORTANT: To use **Rx.playground**:
 1. Open **Rx.xcworkspace**.
 1. Build the **RxExample-macOS** scheme (**Product** → **Build**).
 1. Open **Rx** playground in the **Project navigator** (under RxExample project).
 1. Show the Debug Area (**View** → **Debug Area** → **Show Debug Area**).
 ----
 [Previous](@previous)
 */

import RxSwift

/*:
# Introduction

## Why use RxSwift?

A vast majority of the code we write involves responding to external events. When a user manipulates a control, we need to write an `@IBAction` handler to respond. We need to observe notifications to detect when the keyboard changes position. We must provide closures to execute when URL sessions respond with data. And we use KVO to detect changes to variables.
All of these various systems makes our code needlessly complex. Wouldn't it be better if there was one consistent system that handled all of our call/response code? Rx is such a system.
 
 RxSwift is the official implementation of [Reactive Extensions](http://reactivex.io) (aka Rx), which exist for [most major languages and platforms](http://reactivex.io/languages.html).
*/
/*:
 ## Concepts

 **Every `Observable` instance is just a sequence.**
 
 The key advantage for an `Observable` sequence vs. Swift's `Sequence` is that it can also receive elements asynchronously. _This is the essence of RxSwift._ Everything else expands upon this concept.

 * An `Observable` (`ObservableType`) is equivalent to a `Sequence`.
 * The `ObservableType.subscribe(_:)` method is equivalent to `Sequence.makeIterator()`.
 * `ObservableType.subscribe(_:)` takes an observer (`ObserverType`) parameter, which will be subscribed to automatically receive sequence events and elements emitted by the `Observable`, instead of manually calling `next()` on the returned generator.
 */
/*:
 If an `Observable` emits a next event (`Event.next(Element)`), it can continue to emit more events. However, if the `Observable` emits either an error event (`Event.error(ErrorType)`) or a completed event (`Event.completed`), the `Observable` sequence cannot emit additional events to the subscriber.

 Sequence grammar explains this more concisely:

 `next* (error | completed)?`

 And this can also be explained more visually using diagrams:

 `--1--2--3--4--5--6--|----> // "|" = Terminates normally`

 `--a--b--c--d--e--f--X----> // "X" = Terminates with an error`

 `--tap--tap----------tap--> // "|" = Continues indefinitely, such as a sequence of button taps`

 > These diagrams are called marble diagrams. You can learn more about them at [RxMarbles.com](http://rxmarbles.com).
*/
/*:
 ### Observables and observers (aka subscribers)
 
 `Observable`s will not execute their subscription closure unless there is a subscriber. In the following example, the closure of the `Observable` will never be executed, because there are no subscribers:
 */
//すべてのObservableインスタンスは、単なるシーケンスです。
//ObservableシーケンスとSwiftのSequenceを比較した場合の主な利点は、非同期で要素を受け取ることもできることです。
//これは、RxSwiftの本質です。他のすべては、このコンセプトに基づいて拡張されています。
//・Observable (ObservableType) は Sequence と同等です。
//・ObservableType.subscribe(_:) メソッドは Sequence.makeIterator() と等価です。
//・ObservableType.subscribe(_:) は、Observer (ObserverType) パラメータを取り、これは、返されたジェネレータ上で手動で next() を呼ぶ代わりに、 Observableが発するシーケンスイベントと要素を自動的に受信するために購読されるものである。

//Observable が next event (Event.next(Element)) を発する場合、それはさらにイベントを発し続けることができます。しかし、Observable がエラーイベント (Event.error(ErrorType)) や完了イベント (Event.completed) を発すると、Observable のシーケンスはサブスクライバーに追加のイベントを発することができません。
//シーケンスの文法は、これをより簡潔に説明しています。
//next* (error | completed)?

//Observableは、サブスクライバーが存在しない限り、そのサブスクリプションのクロージャを実行しません。次の例では、サブスクライバーがいないので、Observableのクロージャは決して実行されません。
example("Observable with no subscribers") {
    _ = Observable<String>.create { observerOfString -> Disposable in
        print("This will never be printed")
        observerOfString.on(.next("😬"))
        observerOfString.on(.completed)
        return Disposables.create()
    }
}
/*:
 ----
 In the following example, the closure will be executed when `subscribe(_:)` is called:
 */
//次の例では、subscribe(_:)が呼ばれたときにクロージャが実行されます。
example("Observable with subscriber") {
  _ = Observable<String>.create { observerOfString in
            print("Observable created")
            observerOfString.on(.next("😉"))
            observerOfString.on(.completed)
            return Disposables.create()
        }
        .subscribe { event in
            print(event)
    }
}
/*:
 > Don't concern yourself with the details of how these `Observable`s were created in these examples. We'll get into that [next](@next).
 #
 > `subscribe(_:)` returns a `Disposable` instance that represents a disposable resource such as a subscription. It was ignored in the previous simple example, but it should normally be properly handled. This usually means adding it to a `DisposeBag` instance. All examples going forward will include proper handling, because, well, practice makes _permanent_ 🙂. You can learn more about this in the [Disposing section](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md#disposing) of the [Getting Started guide](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md).
 */
//これらの例で、これらのObservableがどのように作成されたかの詳細については気にしないでください。それは次に説明します。
//subscribe(_:) は、サブスクリプションのような使い捨てのリソースを表す Disposable のインスタンスを返します。これは前の簡単な例では無視されましたが、通常は適切に処理されるべきものです。これは通常、それを DisposeBag インスタンスに追加することを意味します。これからのすべての例では、適切な処理を行う予定です。なぜなら、実践は永久に続くものだからです。これについては、Getting Started GuideのDisposeのセクションで詳しく説明されています。
//: [Next](@next) - [Table of Contents](Table_of_Contents)
