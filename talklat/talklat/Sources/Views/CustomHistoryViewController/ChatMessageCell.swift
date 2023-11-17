//
//  ChatMessageCell.swift
//  talklat
//
//  Created by user on 11/12/23.
//
import Foundation
import UIKit
import SwiftUI

class ChatMessageCell: UITableViewCell, UITextViewDelegate {
    private let bubbleBackgroundView: UIView =  UIView()
    private let textView: UITextView = UITextView()
    private let iconView: UIImageView = UIImageView()
    private let webViewNotification: Notification.Name = Notification.Name("webViewNotification")
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    var chatMessage: TKContent! {
        didSet {
            textView.text = chatMessage.text
            
            switch chatMessage.type {
            case .answer:
                bubbleBackgroundView.backgroundColor = UIColor(Color.OR5)
                textView.textColor = .white
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
                iconView.alpha = 1
                
            case .question:
                bubbleBackgroundView.backgroundColor = UIColor(Color.GR1)

                textView.textColor = UIColor(Color.GR7)
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
                iconView.alpha = 0
            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        bubbleBackgroundView.layer.cornerRadius = 22
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleBackgroundView)
        
        iconView.layer.cornerRadius = 12
        iconView.setSymbolImage(UIImage(systemName: "waveform.circle.fill")!, contentTransition: .automatic)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.tintColor = UIColor(Color.OR5)
        addSubview(iconView)
        
        
        // textView
        addSubview(textView)
        
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.delegate = self
        
        
        // setup constraints
        let constraints = [
            // textView constraints
            textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            textView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.8, constant: -40),
            
            // bubbleBackgroundView constraints
            bubbleBackgroundView.topAnchor.constraint(equalTo: textView.topAnchor, constant: -10),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 16),
            
            // iconView constraints
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            iconView.bottomAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: -2)
        ]
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40)
        leadingConstraint.isActive = true
        
        trailingConstraint = textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40)
        trailingConstraint.isActive = true
        
        iconView.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textView(_ textView: UITextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        var additionalActions: [UIMenuElement] = [UIMenuElement]()
        
        let selectedWord = (textView.text as NSString).substring(with: range)
        
        let copyAction = UIAction(title: "복사하기", image: UIImage(systemName: "doc.on.doc")) { value in
            // copy text action
            UIPasteboard.general.string = selectedWord
        }
        additionalActions.append(copyAction)
        
        
        let searchAction = UIAction(title: "검색하기", image: UIImage(systemName: "magnifyingglass")) { [weak self] _ in
            
            guard let url = URL(string: "https://google.com/search?q=\(selectedWord)") else { return }
            
            guard let webViewNotification = self?.webViewNotification else { return }
            
            NotificationCenter.default.post(name: webViewNotification, object: url)
        }
        additionalActions.append(searchAction)
        
        let menu = UIMenu(options: .displayAsPalette, children: additionalActions)
        
        return menu
    }
}




