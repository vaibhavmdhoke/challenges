require 'test_helper'

class TransactionTest < ActiveSupport::TestCase

  test "that transaction should not be valid without charity" do
    transaction_one = Transaction.new({amount: 1})
    assert_equal false, transaction_one.valid?
  end

  test "that transaction should not be valid without amount" do
    charity = charities(:charity_for_transaction)
    transaction_one = Transaction.new({charity_id: charity.id})
    assert_equal false, transaction_one.valid?
  end

end
