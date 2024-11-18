//
//  NoteFromHostView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 12/10/2024.
//

import UIKit
import PureLayout

final class NoteFromHostView: BaseView {
    private let model: EventDetailsViewModel
    
    private let headerLabel = IVHeaderLabel(text: "Note from host")
    private let noteEntryView = EntryWithTitleView(title: "Note")
    private let noteTextView: IVTextView
    
    init(model: EventDetailsViewModel) {
        self.model = model
        self.noteTextView = IVTextView(text: model.note, placeholder: "Provide additional details about your event. The message will appear next to your invitation.")
        
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        // Configure text view appearance if needed
        noteTextView.layer.cornerRadius = 16
        noteTextView.backgroundColor = .lightGray.withAlphaComponent(0.1)
        // Set the text view as content for the entry view
        noteTextView.delegate = self
        noteEntryView.setContentView(noteTextView)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        // Add subviews to the view
        addSubview(headerLabel)
        addSubview(noteEntryView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        // Constraints for header label
        headerLabel.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        noteTextView.autoMatch(.width, to: .height, of: noteEntryView, withMultiplier: 344.0 / 132.0)
        // Constraints for the entry view
        noteEntryView.autoPinEdge(.top, to: .bottom, of: headerLabel, withOffset: 16)
        noteEntryView.autoPinEdge(toSuperviewEdge: .leading, withInset: 0)
        noteEntryView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 0)
        noteEntryView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
    }
}

extension NoteFromHostView: IVTextViewdDelegate {
    func textViewdDidChange(_ textView: IVTextView) {
        model.note = textView.text
    }
}
