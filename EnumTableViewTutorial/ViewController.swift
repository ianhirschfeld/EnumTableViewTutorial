//
//  ViewController.swift
//  EnumTableViewTutorial
//
//  Created by Ian Hirschfeld on 6/22/17.
//  Copyright © 2017 Ian Hirschfeld. All rights reserved.
//

import UIKit

let MovieData = [
  ["title": "Jason Bourne", "cast": "Matt Damon, Alicia Vikander, Julia Stiles", "genre": "action"],
  ["title": "Suicide Squad", "cast": "Margot Robbie, Jared Leto, Will Smith", "genre": "action"],
  ["title": "Star Trek Beyond", "cast": "Chris Pine, Zachary Quinto, Zoe Saldana", "genre": "action"],
  ["title": "Deadpool", "cast": "Ryan Reynolds, Morena Baccarin, Gina Carano", "genre": "action"],
  ["title": "London Has Fallen", "cast": "Gerard Butler, Aaron Eckhart, Morgan Freeman, Angela Bassett", "genre": "action"],
  ["title": "Ghostbusters", "cast": "Kate McKinnon, Leslie Jones, Melissa McCarthy, Kristen Wiig", "genre": "comedy"],
  ["title": "Central Intelligence", "cast": "Dwayne Johnson, Kevin Hart", "genre": "comedy"],
  ["title": "Bad Moms", "cast": "Mila Kunis, Kristen Bell, Kathryn Hahn, Christina Applegate", "genre": "comedy"],
  ["title": "Keanu", "cast": "Jordan Peele, Keegan-Michael Key", "genre": "comedy"],
  ["title": "Neighbors 2: Sorority Rising", "cast": "Seth Rogen, Rose Byrne", "genre": "comedy"],
  ["title": "The Shallows", "cast": "Blake Lively", "genre": "drama"],
  ["title": "The Finest Hours", "cast": "Chris Pine, Casey Affleck, Holliday Grainger", "genre": "drama"],
  ["title": "10 Cloverfield Lane", "cast": "Mary Elizabeth Winstead, John Goodman, John Gallagher Jr.", "genre": "drama"],
  ["title": "A Hologram for the King", "cast": "Tom Hanks, Sarita Choudhury", "genre": "drama"],
  ["title": "Miracles from Heaven", "cast": "Jennifer Garner, Kylie Rogers, Martin Henderson", "genre": "drama"],
]

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  // The magic enum to end our pain and suffering!
  // For the most part the order of our cases do not matter.
  // What is important is that our first case is set to 0, and that our last case is always `total`.
  enum TableSection: Int {
    case action = 0, comedy, drama, indie, total
  }

  // This is the size of our header sections that we will use later on.
  let SectionHeaderHeight: CGFloat = 25

  // Data variable to track our sorted data.
  var data = [TableSection: [[String: String]]]()

  override func viewDidLoad() {
    super.viewDidLoad()
    sortData()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.reloadData()
  }

  // When generating sorted table data we can easily use our TableSection to make look up simple and easy to read.
  func sortData() {
    data[.action] = MovieData.filter({ $0["genre"] == "action" })
    data[.comedy] = MovieData.filter({ $0["genre"] == "comedy" })
    data[.drama] = MovieData.filter({ $0["genre"] == "drama" })
    data[.indie] = MovieData.filter({ $0["genre"] == "indie" })
  }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

  // As long as `total` is the last case in our TableSection enum,
  // this method will always be dynamically correct no mater how many table sections we add or remove.
  func numberOfSections(in tableView: UITableView) -> Int {
    return TableSection.total.rawValue
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Using Swift's optional lookup we first check if there is a valid section of table.
    // Then we check that for the section there is data that goes with.
    if let tableSection = TableSection(rawValue: section), let movieData = data[tableSection] {
      return movieData.count
    }
    return 0
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    // If we wanted to always show a section header regardless of whether or not there were rows in it,
    // then uncomment this line below:
    //return SectionHeaderHeight

    // First check if there is a valid section of table.
    // Then we check that for the section there is more than 1 row.
    if let tableSection = TableSection(rawValue: section), let movieData = data[tableSection], movieData.count > 0 {
      return SectionHeaderHeight
    }
    return 0
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
    view.backgroundColor = UIColor(red: 253.0/255.0, green: 240.0/255.0, blue: 196.0/255.0, alpha: 1)
    let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
    label.font = UIFont.boldSystemFont(ofSize: 15)
    label.textColor = UIColor.black
    if let tableSection = TableSection(rawValue: section) {
      switch tableSection {
      case .action:
        label.text = "Action"
      case .comedy:
        label.text = "Comedy"
      case .drama:
        label.text = "Drama"
      case .indie:
        label.text = "Indie"
      default:
        label.text = ""
      }
    }
    view.addSubview(label)
    return view
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    // Similar to above, first check if there is a valid section of table.
    // Then we check that for the section there is a row.
    if let tableSection = TableSection(rawValue: indexPath.section), let movie = data[tableSection]?[indexPath.row] {
      if let titleLabel = cell.viewWithTag(10) as? UILabel {
        titleLabel.text = movie["title"]
      }
      if let subtitleLabel = cell.viewWithTag(20) as? UILabel {
        subtitleLabel.text = movie["cast"]
      }
    }
    return cell
  }

}
