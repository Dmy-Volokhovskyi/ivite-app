//
//  PaymentOption.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/11/2024.
//


struct PaymentOption {
    let title: String
    let detail: String
    let price: Double
    let billingCycle: BillingCycle
}

extension PaymentOption: Equatable {
    static func == (lhs: PaymentOption, rhs: PaymentOption) -> Bool {
        lhs.price == rhs.price
    }
}

enum BillingCycle {
    case monthly
    case yearly
}

extension BillingCycle {
    var cycleString: String {
        switch self {
        case .monthly: return "/mon"
        case .yearly: return "/year"
        }
    }
}
