//
//  ViewController.swift
//  rxSwiftTest
//
//  Created by Алексей Макаров on 09.06.2020.
//  Copyright © 2020 Алексей Макаров. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet var gestureRecognizer: UITapGestureRecognizer!
  
  @IBOutlet weak var textFieldLabel: UILabel!
  @IBOutlet weak var textfield: UITextField!
  
  @IBOutlet weak var textviewLabel: UILabel!
  @IBOutlet weak var textview: UITextView!
  
  @IBOutlet weak var btnLabel: UILabel!
  @IBOutlet weak var btnTapMe: UIButton!
  
  @IBOutlet weak var mySlider: UISlider!
  @IBOutlet weak var myProgressView: UIProgressView!
  
  @IBOutlet weak var segment: UISegmentedControl!
  @IBOutlet weak var segmentLabel: UILabel!
  
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var datePickerLabel: UILabel!
  
  @IBOutlet weak var stepper: UIStepper!
  @IBOutlet weak var stepperLabel: UILabel!
  
  @IBOutlet weak var myswitch: UISwitch!
  @IBOutlet weak var activ: UIActivityIndicatorView!
  
  
  
  lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
  }()
  
  // MARK: - Properties
  
  let disposeBag = DisposeBag()
  let textFieldText = BehaviorRelay(value: "")
  let buttonSubject = PublishSubject<String>()

  // MARK: - Life
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    gestureRecognizer.rx.event.asDriver().drive(onNext: { [weak self] _ in
      self?.view.endEditing(true)
      }).disposed(by: disposeBag)
    
    textfield.rx.text.orEmpty.bind {
      self.textFieldLabel.text = $0
    }.disposed(by: disposeBag)
    
    textview.rx.text.bind {
      guard let count = $0?.count else { return }
      self.textviewLabel.text = "Character count: \(count)"
    }.disposed(by: disposeBag)
    
    btnTapMe.rx.tap.asDriver().drive(onNext: {
      self.btnLabel.text! += "tap RX SWIFT"
      self.view.endEditing(true)
      UIView.animate(withDuration: 0.5, animations: {
        self.view.layoutIfNeeded()
      })
    }).disposed(by: disposeBag)
    
    mySlider.rx.value.asDriver().drive(myProgressView.rx.progress).disposed(by: disposeBag)
    
    segment.rx.value.asDriver().drive(onNext: {
      self.segmentLabel.text = "Current segment: \($0)"
    }).disposed(by: disposeBag)
    
    datePicker.rx.date.asDriver()
      .map {
        self.dateFormatter.string(from: $0)
    }.drive(onNext: {
      self.datePickerLabel.text = "Date: \($0)"
    }).disposed(by: disposeBag)
    
    stepper.rx.value.asDriver().map { String(Int($0)) }.drive(stepperLabel.rx.text).disposed(by: disposeBag)
    
    myswitch.rx.value.asDriver().map { !$0 }.drive(activ.rx.isHidden).disposed(by: disposeBag)
    myswitch.rx.value.asDriver().drive(activ.rx.isAnimating).disposed(by: disposeBag )
    
  }

}

