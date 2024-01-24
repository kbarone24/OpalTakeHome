//
//  ViewController.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/23/24.
//

import UIKit

class RewardsViewController: UIViewController {
    private lazy var viewModel = RewardsViewModel(serviceContainer: ServiceContainer.shared)

    override func viewDidLoad() {
        print("view did load")
        super.viewDidLoad()

    }
}

