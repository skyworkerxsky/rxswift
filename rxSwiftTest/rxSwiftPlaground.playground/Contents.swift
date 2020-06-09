import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift

example("Test") {
  
  // наблюдаемые значения
  let intObserv = Observable.just(30)
  let strObserv = Observable.just("Hello")
}

example("just") {
  // Observable
  let observable = Observable.just("Hello, world")

  // Observer
  observable.subscribe { (event) in
    print(event)
  }
}

example("of") {
  let observable = Observable.of(1,2,3,4,67,23)
  
  observable.subscribe { (event) in
    print(event)
  }
  
  // короткая запись
  observable.subscribe {
    print($0)
  }
}

example("create") {
  let items = [1,2,3,4]
  Observable.from(items).subscribe(onNext: { (event) in
    print(event)
  }, onError: { (error) in
    print(error)
  }, onCompleted: {
    print("COMPLETED")
  }) {
    print("DISPOSED")
  }
}

example("Disposable") {
  let seq = [1,2,3,4,5]
  Observable.from(seq).subscribe { (event) in
    print(event)
  }
  Disposables.create()
}

example("Dispose") {
  let seq = [1,2,3]
  let subsription = Observable.from(seq)
  subsription.subscribe { (event) in
    print(event)
  }.dispose()
}

example("DisposeBag") {
  let disposeBag = DisposeBag()
  let seq = [1,2,3,4]
  let subsripton = Observable.from(seq)
  subsripton.subscribe { (event) in
    print(event)
  }.disposed(by: disposeBag)
}

example("TakeUntil") {
  let stopSeq = Observable.just(1).delaySubscription(2, scheduler: MainScheduler.instance)
  let seq = Observable.from([10,20,30]).takeUntil(stopSeq)
  seq.subscribe {
    print($0)
  }
}

example("filter") {
  let seq = Observable.of(3, 28, 6, 24, 29, 19, 1, 29, 12, 7).filter { $0 > 25 }
  seq.subscribe { (event) in
    print(event)
  }
}

example("Map") {
  let seq = Observable.of(100,200,300,400).map { $0 / 10 }
  seq.subscribe { (event) in
    print(event)
  }
}

example("Merge") {
  let firstSeq = Observable.of(10, 20, 30)
  let secondSeq = Observable.of(1, 2, 3)
  
  let bothSeq = Observable.of(firstSeq, secondSeq)
  let mergeSeq = bothSeq.merge()
  
  mergeSeq.subscribe { e in
    print(e)
  }
}
