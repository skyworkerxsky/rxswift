import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift

example("PublishSubject") {
  let disposeBag = DisposeBag()
  
  let subject = PublishSubject<String>()
  subject.subscribe{
    print("First subscribe: ", $0)
  }.disposed(by: disposeBag)
  
  subject.on(.next("RX"))
  subject.onNext("SWIFT")
  
  subject.subscribe {
    print("Second subscribe: ", $0)
  }.disposed(by: disposeBag)
  
  subject.onNext("hello")
  subject.onNext("world")
}

// хранит последнее значение
example("BehaviorSubject") {
  let disposeBag = DisposeBag()
  let subject = BehaviorSubject(value: 1) // в буфере: 1
  
  let firstSub = subject.subscribe(onNext: {
    print(#line, $0)
  }).disposed(by: disposeBag)
  
  subject.onNext(2)
  subject.onNext(3)
  
  let secondSub = subject.subscribe(onNext: {
    print(#line, $0) // 3
  }).disposed(by: disposeBag)
}

example("ReplaySubject") {
  let disposeBag = DisposeBag()
  let subject = ReplaySubject<String>.create(bufferSize: 1) // последнее 1 значение
  
  subject.subscribe {
    print("First subscription: ", $0)
  }.disposed(by: disposeBag)
  
  subject.onNext("X")
  subject.onNext("Y")
  
  subject.subscribe {
    print("Second subscription: ", $0)
  }.disposed(by: disposeBag)
  
  subject.onNext("A")
  subject.onNext("B")
}

// обертка над BehaviorSubject
example("Variables") {
  let disposeBag = DisposeBag()
  
  let variable = Variable("A")
  variable.asObservable().subscribe(onNext: {
    print($0)
  }).disposed(by: disposeBag)
  
  variable.value = "B"
}
