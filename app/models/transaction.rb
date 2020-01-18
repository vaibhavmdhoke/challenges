class Transaction < ActiveRecord::Base
  belongs_to :charity
  after_commit :update_charity_total
  validates_presence_of :charity_id, :amount

  def update_charity_total
    total = charity.transactions.pluck(:amount).inject(:+)
    charity.update_column :total, total
  end
end
