//
//  EmojiArtView.swift
//  emojiArt
//
//  Created by 1C on 25/06/2022.
//

import UIKit

protocol EmojiArtViewDelegate: AnyObject {
    func emojiArtViewDidChange(_ sender: EmojiArtView)
}

class EmojiArtView: UIView, UIDropInteractionDelegate {

    weak var delegate: EmojiArtViewDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func addLabel(with attributedString: NSAttributedString, centered point: CGPoint) {
        let label = UILabel()
        label.backgroundColor = .clear
        label.attributedText = attributedString
        label.sizeToFit()
        label.center = point
        addEmojiArtGestureRecognizers(to: label)
        addSubview(label)
    }
    
    private func setup() {
        addInteraction(UIDropInteraction(delegate: self))
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        session.loadObjects(ofClass: NSAttributedString.self) {
            providers in
            let point = session.location(in: self)
            for attributedString in providers as? [NSAttributedString] ?? [] {
                self.addLabel(with: attributedString, centered: point)
                self.delegate?.emojiArtViewDidChange(self)
            }
        }
        
    }
        
    var backGroundImage: UIImage? {didSet {setNeedsDisplay()}}
    
    override func draw(_ rect: CGRect) {
        
        backGroundImage?.draw(in: bounds)
        
    }
  

}
