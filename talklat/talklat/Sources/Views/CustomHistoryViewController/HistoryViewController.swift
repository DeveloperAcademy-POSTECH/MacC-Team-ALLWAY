//
//  HistoryViewController.swift
//  talklat
//
//  Created by user on 11/12/23.
//

import Combine
import UIKit
import SwiftUI


class HistoryViewController: UIViewController {
    private var customTableViewController: CustomTableViewController!
    private var floatingButton: UIButton!
    private var cancellableBag: Set<AnyCancellable> = Set<AnyCancellable>()
    private var cancellable: Cancellable?
    private var floatingButtonNotification: Notification.Name = Notification.Name("showFloatingButton")
    var conversation: TKConversation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTableViewController = CustomTableViewController()
        customTableViewController.conversation = conversation
        customTableViewController.messages = sortMessages(conversation)
        customTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(customTableViewController)
        self.view.addSubview(customTableViewController.view)
        
        
        createFloatingButton()
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(floatingButton)
        
        NSLayoutConstraint.activate([
            customTableViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            customTableViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTableViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTableViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            floatingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            floatingButton.widthAnchor.constraint(equalToConstant: 44),
            floatingButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        
        // floatingbutton notification
        cancellable = NotificationCenter.default
            .publisher(for: floatingButtonNotification, object: nil)
            .sink { [weak self] result in
                if let floatingButtonToggle = result.object as? Bool {
                    self?.showFloatingButton(floatingButtonToggle)
                }
            }
            .store(in: &cancellableBag) as? any Cancellable
    }
    
    
    // 화면을 켰을 시 스크롤 최하단
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customTableViewController.tableView.scrollToBottom(animated: false)
    }
    
    // 플로팅 버튼 생성
    private func createFloatingButton() {
        floatingButton = UIButton()
        floatingButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        floatingButton.backgroundColor = .systemGray3
        floatingButton.layer.cornerRadius = 22
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        floatingButton.setImage(UIImage(systemName: "chevron.down", withConfiguration: imageConfig), for: .normal)
        floatingButton.tintColor = .systemGray
        floatingButton.alpha = 0
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
    }
    
    // 버튼 눌렀을시 스크롤 최하단
    @objc private func floatingButtonTapped() {
        self.customTableViewController.tableView.scrollToBottom(animated: false)
    }
    
    private func showFloatingButton(_ isShowing: Bool) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            if isShowing {
                self?.floatingButton.alpha = 1
            } else {
                self?.floatingButton.alpha = 0
            }
        }
    }
    
    private func sortMessages(_ conversation: TKConversation) -> [[TKContent]] {
        // 우선 dictionary에 created: [Content] 형식으로 저장
        var contentDict = [String: [TKContent]]()
        
        conversation.content.forEach { item in
            if contentDict[item.createdAt.convertToDate()] == nil {
                // 해당 Date에 해당하는 값이 없으면 배열을 만들어주고 넣어줌
                contentDict[item.createdAt.convertToDate()] = [TKContent]()
            }
            contentDict[item.createdAt.convertToDate()]!.append(item)
        }
        
        // key(Date)를 뽑아내고 오름차순으로 정렬
        let dateKeys = contentDict.keys
        let sortedDateKeys = dateKeys.sorted(by: { $0 < $1 })
        
        var sortedMessages = [[TKContent]]()
        sortedDateKeys.forEach { key in
            if let contentArray = contentDict[key] {
                sortedMessages.append(contentArray)
            }
        }
        
        return sortedMessages
    }
}

extension UITableView {
    func scrollToBottom(animated: Bool) {
        
        let sectionCount = numberOfSections - 1
        guard sectionCount >= 0 else { return }
        let rowCount = numberOfRows(inSection: sectionCount) - 1
        self.scrollToRow(at: IndexPath(row: rowCount, section: sectionCount), at: .bottom, animated: animated)
    }
}

