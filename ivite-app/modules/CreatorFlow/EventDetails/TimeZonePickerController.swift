//
//  TimeZonePickerDelegate.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 17/11/2024.
//


import UIKit
import Reusable

protocol TimeZonePickerDelegate: AnyObject {
    func didSelectTimeZone(_ timeZone: String)
}

final class TimeZonePickerController: BaseTableViewController {
    private static let defaultWidth: CGFloat = 200
    
    private static let cellReuseIdentifier = "Cell"
    
    private let timeZones: [TimeZone]
    private let selectedTimeZone: TimeZone?
    
    weak var delegate: TimeZonePickerDelegate?
    
    init(selectedTimeZoneIdentifier: String?) {
        self.timeZones = TimeZone.knownTimeZoneIdentifiers
            .filter { $0.starts(with: "America/") }
            .compactMap { TimeZone(identifier: $0) }
            .sorted { $0.identifier < $1.identifier }
        
        // Convert the selectedTimeZoneIdentifier string into a TimeZone
        if let identifier = selectedTimeZoneIdentifier,
           let timeZone = TimeZone(identifier: identifier) {
            self.selectedTimeZone = timeZone
        } else {
            self.selectedTimeZone = nil
        }
        
        super.init()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        let width = timeZones
            .map { $0.identifier.replacingOccurrences(of: "America/", with: "") }
            .map {
                ($0 as NSString).size(withAttributes: [
                    .font: UIFont.interFont(ofSize: 11)
                ])
            }
            .map { $0.width }
            .max() ?? Self.defaultWidth
        
        preferredContentSize = CGSize(width: width + 32,
                                      height: CGFloat(min(timeZones.count * 44 - 1, 400))) // Limit height
    }
}

// MARK: - UITableViewDataSource

extension TimeZonePickerController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        timeZones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseIdentifier) ??
        UITableViewCell(style: .default, reuseIdentifier: Self.cellReuseIdentifier)
        let timeZone = timeZones[indexPath.row]
        cell.textLabel?.text = timeZone.formattedDescription
        if timeZone == selectedTimeZone {
            cell.textLabel?.font = UIFont.interFont(ofSize: 11, weight: .semiBold)
        } else {
            cell.textLabel?.font = UIFont.interFont(ofSize: 11, weight: .regular)
            
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TimeZonePickerController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTimeZone = timeZones[indexPath.row]
        delegate?.didSelectTimeZone(selectedTimeZone.identifier)
    }
}
