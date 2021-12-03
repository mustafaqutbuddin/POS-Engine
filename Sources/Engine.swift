//
//  Engine.swift
//  POS
//
//  Created by Mustafa on 2021-11-29.
//

import Foundation

public typealias Item = (name: String, category: String, price: NSDecimalNumber, isTaxExempt: Bool)
public typealias Discount = (label: String, amount: Double, isEnabled: Bool)
public typealias Tax = (label: String, amount: Double, isEnabled: Bool)

public class POSEngine {
    //MARK: - Properties
    public static var subtotal: Observable<Double> = Observable(0.0)
    public static var discountAmount: Observable<Double> = Observable(0.0)
    public static var total: Observable<Double> = Observable(0.0)
    public static var taxAmount: Observable<Double> = Observable(0.0)
    public static var addedDiscounts: Observable<[Discount]> = Observable([])
    public static var addedTaxes: Observable<[Tax]> = Observable([])

    //MARK: - init
    public init (with taxes: [Tax]) {
        POSEngine.addedTaxes.value = taxes
    }

    public func calculateSubTotal(with orderItems: [Item]) {
        POSEngine.subtotal.value = 0.0
        for item in orderItems {
            POSEngine.subtotal.value += Double(truncating: item.price)
            POSEngine.total.value = POSEngine.subtotal.value
        }

        calculateDiscount()
        calculateTax(with: orderItems)
    }

    func calculateDiscount() {
        POSEngine.discountAmount.value = 0.0
        POSEngine.total.value = POSEngine.subtotal.value

        for discount in POSEngine.addedDiscounts.value {
            if discount.isEnabled {
                if discount.amount > 1 {
                    POSEngine.discountAmount.value = discount.amount
                } else {
                    POSEngine.discountAmount.value += (POSEngine.subtotal.value * discount.amount)
                }
            }
        }

        POSEngine.total.value -= POSEngine.discountAmount.value
    }

    func calculateTax(with orderItems: [Item]) {
        POSEngine.taxAmount.value = 0.0

        for item in orderItems {
            for tax in POSEngine.addedTaxes.value {
//                if tax.isEnabled {
                    if item.isTaxExempt {
                        break
                    } else {
                        if tax.label.contains("Alcohol") {
                            if item.category == "Alcohol" {
                                POSEngine.taxAmount.value += (Double(truncating: item.price) * tax.amount)
                            } else {
                                 break
                            }
                        } else {
                            POSEngine.taxAmount.value += (Double(truncating: item.price) * tax.amount)
                        }
                    }
//                }
            }
        }



        POSEngine.total.value += POSEngine.taxAmount.value

        if POSEngine.total.value < 0 { POSEngine.total.value = 0 }
        if POSEngine.subtotal.value == 0 {
            POSEngine.taxAmount.value = 0
            POSEngine.discountAmount.value = 0
        }
    }
}

