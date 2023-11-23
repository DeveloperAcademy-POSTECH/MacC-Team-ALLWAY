//
//  CustomTableViewController.swift
//  talklat
//
//  Created by user on 11/12/23.
//

import Combine
import Foundation
import UIKit

class CustomTableViewController: UITableViewController {
    private let cellId: String = "Cell"
    private let floatingButtonNotification: Notification.Name = Notification.Name("showFloatingButton")
    private let swipeDetectedNotification: Notification.Name = Notification.Name("swipeDetected")
    var conversation: TKConversation!
    var messages: [[TKContent]]!
    
    override func loadView() {
        super.loadView()
        
        // sticky header를 없애기 위해서 새로 UITableView를 만들어서 넣어줌
        self.tableView = UITableView(frame: .zero, style: .grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        tableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: "TableHeader")
        tableView.indicatorStyle = .black
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.canCancelContentTouches = false
        tableView.estimatedSectionHeaderHeight = 0 // section header로 잡힌 높이만큼 안내려가던 거였음
    }
    
    // section 갯수 메서드
    override func numberOfSections(in tableView: UITableView) -> Int {
//        guard let messages = messages  else { return 0 }
        return messages.count
    }
    
    // haeder section view를 결정하는 메서드
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeader") as? TableHeader
        guard let header = header else { return UIView() }
        guard let firstItem = messages[section].first else { return header }
        
        header.dateLabel.text = firstItem.createdAt.convertToDate()
        header.timeLabel.text = firstItem.createdAt.convertToTime()
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 104
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let emptyView = UILabel()
        return emptyView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    // tableView가 몇개의 cell을 만들건지에 대한 메서드
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let messages = messages else { return 0}
        return messages[section].count
    }
    
    // tableView의 각 cell에 대한 메서드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.chatMessage = messages[indexPath.section][indexPath.row]
        cell.contentView.isHidden = true
        cell.contentView.alpha = 0
        return cell
    }
    
    // floating button을 넣기 위한 메서드
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = tableView.contentSize.height - (tableView.contentOffset.y + tableView.frame.size.height)
        if scrollOffset > 500 { // floating button 보이기
            NotificationCenter.default.post(name: floatingButtonNotification, object: true)
        } else if scrollOffset < 200{ // floating button 안보이기
            NotificationCenter.default.post(name: floatingButtonNotification, object: false)
        }
    }
    
    // 스와이프해서 typingview 이동하기 위한 메서드
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let height = scrollView.frame.size.height // 화면 안의 tableView의 frame size
        let contentYOffset = scrollView.contentOffset.y // tableView 내부의 content가 얼마나 이동했는지 계산
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset
        
        if distanceFromBottom + 75 < height {
            NotificationCenter.default.post(name: swipeDetectedNotification, object: nil)
        }
    }
}
