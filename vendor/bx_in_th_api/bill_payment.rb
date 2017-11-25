module BxInThAPI
  module BillPayment
    def bill_payment_types
      __private :billgroup
    end

    def bill_payment_providers(group_id = 1)
      __private :biller, group_id: group_id
    end

    def create_bill_payment(biller, account, amount = 0)
      __private :billpay, biller: biller, account: account, amount: amount
    end
  end
end
