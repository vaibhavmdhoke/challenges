class Charity < ActiveRecord::Base
  validates :name, presence: true
  has_many :transactions

  def credit_amount(amount)
    transactions.create({amount: amount})
  end
end
