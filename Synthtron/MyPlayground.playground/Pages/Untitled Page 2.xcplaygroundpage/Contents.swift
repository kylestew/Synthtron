import UIKit
import RxSwift
import RxCocoa
import PlaygroundSupport


let disposeBag = DisposeBag()

let number = Variable(1)

number.asObservable().subscribe {
    print($0)
}.addDisposableTo(disposeBag)

number.value = 12
number.value = 1_234_567


PlaygroundPage.current.needsIndefiniteExecution = true