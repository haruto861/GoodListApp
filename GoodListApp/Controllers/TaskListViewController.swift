//
//  TaskListViewController.swift
//  GoodListApp
//
//  Created by 松島悠人 on 2021/11/03.
//

import UIKit
import RxSwift
import RxRelay

final class TaskListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate  = self
            tableView.dataSource = self
        }
    }
    @IBOutlet private weak var prioritySegmentedControl: UISegmentedControl! {
        didSet {
            prioritySegmentedControl.addTarget(self, action: #selector(didChangedPriorityValue(_:)), for: .valueChanged)
        }
    }
    private let disposeBag = DisposeBag()
    private var filterdTasks = [Task]()
    private var tasks = BehaviorRelay<[Task]>(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func filterTasks(by priority: Priority?) {
        if priority == nil {
            self.filterdTasks = self.tasks.value
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            self.tasks.map { tasks in
                return tasks.filter({$0.priority == priority! })
            }.subscribe(onNext: { tasks in
                self.filterdTasks = tasks
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
        }

    }

    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard let addVC = segue.source as? AddTaskViewController else { return }
        addVC.taskSubjectObservable.subscribe(onNext: { [ weak self] in
            guard let self = self else { return }
            let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
            self.tasks.accept( self.tasks.value + [$0])
            self.filterTasks(by: priority)
        }).disposed(by: disposeBag)
    }

    @objc private func didChangedPriorityValue(_ sender: UISegmentedControl) {
        let priority = Priority(rawValue: sender.selectedSegmentIndex - 1)
        filterTasks(by: priority)
    }

}

extension TaskListViewController: UITableViewDelegate {}

extension TaskListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterdTasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.filterdTasks[indexPath.row].title
        return cell
    }
}
