//
//  GroupsListViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 12/01/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit

class GroupsListViewController: UIViewController
{
    @IBOutlet fileprivate var tableView: UITableView!
    var activeSection: Int = -1


    override func viewDidLoad()
    {
        self.tableView.estimatedRowHeight = 20
        self.tableView.rowHeight = UITableViewAutomaticDimension

        registerCells()
        loadData()
    }


    private func registerCells()
    {
        self.tableView.register(UINib(nibName: "GroupHeader", bundle: nil),
                                forHeaderFooterViewReuseIdentifier: GroupHeader.identifier)
        self.tableView.register(UINib(nibName: "GroupCell", bundle: nil),
                                forCellReuseIdentifier: GroupCell.identifier)
    }


    private func loadData()
    {
        WordsDataSource.sharedInstance.loadAllSharedFiles()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "WordsListViewController" {
            let destination = segue.destination as! WordsListViewController

            if let indexPath = sender as? IndexPath {
                let languageCodes = WordsDataSource.sharedInstance.languageCodes()
                let groups = WordsDataSource.sharedInstance.groups(forLanguageCode: languageCodes[indexPath.section])
                destination.setup(forGroup: groups[indexPath.row])
            }
        }
    }
}


extension GroupsListViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return WordsDataSource.sharedInstance.languageCodesCount()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == activeSection || WordsDataSource.sharedInstance.languageCodesCount() <= 1 {
            let languageCodes = WordsDataSource.sharedInstance.languageCodes()
            return WordsDataSource.sharedInstance.groupsCount(forLanguageCode: languageCodes[section])
        }

        return 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.identifier, for: indexPath) as! GroupCell

        let languageCodes = WordsDataSource.sharedInstance.languageCodes()
        let groups = WordsDataSource.sharedInstance.groups(forLanguageCode: languageCodes[indexPath.section])

        cell.setup(withGroup: groups[indexPath.row])

        return cell
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            let languageCode = WordsDataSource.sharedInstance.languageCodes()[indexPath.section]
            let groups = WordsDataSource.sharedInstance.groups(forLanguageCode: languageCode)

            if groups.count == 1 {
                tableView.deleteSections(IndexSet([indexPath.section]), with: .automatic)
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}


extension GroupsListViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if WordsDataSource.sharedInstance.languageCodesCount() > 1 {
            return 44.0
        }

        return 0.0
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if WordsDataSource.sharedInstance.languageCodesCount() <= 1 {
            return nil
        }

        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: GroupHeader.identifier) as! GroupHeader

        let languageCodes = WordsDataSource.sharedInstance.languageCodes()

        cell.setup(withLanguageCode: languageCodes[section], callback: { [weak self] in
            self?.tableView(tableView, didSelectHeaderInSection: section)
        })

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectHeaderInSection section: Int)
    {
        let indexesToRefresh = NSMutableIndexSet()

        if self.activeSection >= 0 {
            indexesToRefresh.add(self.activeSection)
        }

        if self.activeSection == section {
            self.activeSection = -1
        } else {
            self.activeSection = section
            indexesToRefresh.add(section)
        }

        tableView.reloadSections(indexesToRefresh as IndexSet, with: .automatic)
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "WordsListViewController", sender: indexPath)
    }
}
