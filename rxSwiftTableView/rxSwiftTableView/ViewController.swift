//
//  ViewController.swift
//  rxSwiftTableView
//
//  Created by Алексей Макаров on 10.06.2020.
//  Copyright © 2020 Алексей Макаров. All rights reserved.
//

import UIKit
import SDWebImage
import RxCocoa
import RxSwift

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  // создаем Observable массивом элементов
  let food = Observable.just([
    Food(name: "Баклажан", imageUrl: "https://tutorialadvice.com/img/big/hr-health-2018/foods-that-help-prevent-cataracts.jpg"),
    Food(name: "Картофель", imageUrl: "https://rbsmi.ru/upload/iblock/fcc/fcc3ee275f06a1ba21dd8006ec76b806.jpg"),
    Food(name: "Сосиска", imageUrl: "https://topspb.tv/768x432/uploaded/covers/sausage-262396960720.jpg"),
    Food(name: "Огурец", imageUrl: "https://vannadecor.ru/wp-content/uploads/2019/08/post_5d528c0067971.jpeg"),
  ])
  
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  
  private(set) lazy var tableView: UITableView = UITableView()
  
  // MARK: - Life
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // delegate
//    tableView.delegate = self
//    tableView.dataSource = self
    
    // связываем данные с tableView
    food.bind(to: tableView.rx.items(cellIdentifier: "Cell")) { row, foods, cell in
      cell.textLabel?.text = foods.name
      let imgUrl = URL(string: foods.imageUrl ?? "")
      cell.imageView?.sd_setImage(with: imgUrl,
                                  placeholderImage: UIImage(named: "placeholder"),
                                  options: .highPriority,
                                  context: nil,
                                  progress: nil)
    }.disposed(by: disposeBag)
    
    // обработка нажатия
    tableView.rx.modelSelected(Food.self).subscribe(onNext: {
      print("Tap on the: \($0)")
    }).disposed(by: disposeBag)
    
    createUI()
    configureUI()
    layout()
  }
  
  // MARK: - Functions
  
  func createUI() {
    view.addSubview(tableView)
  }
  
  func configureUI() {
    view.backgroundColor = .white
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  
  func layout() {
    tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
  
}

//extension ViewController: UITableViewDelegate, UITableViewDataSource {
//
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return food.count
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//    let currentItem = food[indexPath.row]
//    cell.textLabel?.text = currentItem.name
//    let imgUrl = URL(string: currentItem.imageUrl ?? "")
//    cell.imageView?.sd_setImage(with: imgUrl,
//                                placeholderImage: UIImage(named: "placeholder"),
//                                options: .highPriority,
//                                context: nil,
//                                progress: nil)
//    return cell
//  }
//
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    print("\(food[indexPath.row])")
//  }
//
//}

