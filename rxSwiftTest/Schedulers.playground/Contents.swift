import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift
import UIKit

example("Without observeOn") {
  _ = Observable.of(1,2,3)
    .subscribe(onNext: {
      print("\(Thread.current): ", $0)
    }, onError: nil, onCompleted: {
      print("completed")
    }, onDisposed: nil)
}

example("ObserveOn") {
  _ = Observable.of(1,2,3)
    .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    .subscribe(onNext: {
      print("\(Thread.current): ", $0)
    }, onError: nil, onCompleted: {
      print("completed")
    }, onDisposed: nil)
}

example("SubscribeOn + observeOn") {
  let queue1 = DispatchQueue.global(qos: .default)
  let queue2 = DispatchQueue.global(qos: .default)
  
  print("Init Thread: \(Thread.current)")
  _ = Observable<Int>.create({ (observer) -> Disposable in
    print("Observale thread: \(Thread.current)")
    
    observer.onNext(1)
    observer.onNext(2)
    observer.onNext(3)
    
    return Disposables.create()
  })
    .subscribeOn(SerialDispatchQueueScheduler(internalSerialQueueName: "queue1"))
    .observeOn(SerialDispatchQueueScheduler(internalSerialQueueName: "queue2"))
    
    .subscribe(onNext: {
      print("Observale thread: \(Thread.current)", $0)
    })
}
