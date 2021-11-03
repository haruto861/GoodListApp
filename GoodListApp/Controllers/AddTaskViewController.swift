//
//  AddTaskViewController.swift
//  GoodListApp
//
//  Created by 松島悠人 on 2021/11/03.
//

import UIKit
import RxSwift

final class AddTaskViewController: UIViewController {

    @IBOutlet private weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet private weak var titleTextFiled: UITextField!
    
    let taskSubject = PublishSubject<Task>()
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }

    @IBAction func didTapSaveButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toAdd", sender: nil)
        guard
            let priority = Priority(rawValue: prioritySegmentedControl.selectedSegmentIndex),
            let title = titleTextFiled.text, !title.isEmpty else {
                return
            }
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
    }
}
