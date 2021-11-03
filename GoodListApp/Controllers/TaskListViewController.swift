//
//  TaskListViewController.swift
//  GoodListApp
//
//  Created by 松島悠人 on 2021/11/03.
//

import UIKit

final class TaskListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate  = self
            tableView.dataSource = self
        }
    }
    @IBOutlet private weak var prioritySegmentedControl: UISegmentedControl!

}

extension TaskListViewController: UITableViewDelegate {

}


extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
}
