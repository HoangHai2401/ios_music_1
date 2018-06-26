//
//  PlayerViewController.swift
//  SoundClound
//
//  Created by Hai on 6/26/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit

final class PlayerViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    var track: TrackInfo? //tranfer TrackInfo
    private struct Constant {
        static let playerCellHeight = 350
        static let relatedTrackCellHeight = 100
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellType: PlayerTableViewCell.self)
        tableView.register(cellType: RelatedTrackTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension PlayerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell") as? PlayerTableViewCell else { return UITableViewCell() }
            cell.setContentForPlayerCell(track: track)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RelatedTrackTableViewCell") as? RelatedTrackTableViewCell else { return UITableViewCell() }
            return cell
        }
    }
}

extension PlayerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(Constant.playerCellHeight)
        } else {
            return CGFloat(Constant.relatedTrackCellHeight)
        }
    }
}
