//
//  SearchResultsV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

class SearchResultsV: UITableViewController,UISearchResultsUpdating {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        self.tableView.backgroundColor = UIColor(rgbValue: 0xFFFFFF, alpha: 0.35)
        let blurEffect = UIBlurEffect(style: .regular)
        let effectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = effectView
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
    }
}

// MARK: - UISearchResultsUpdating

extension SearchResultsV{
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "")
    }
}
