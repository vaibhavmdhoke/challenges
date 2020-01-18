class Donate
  attr_accessor :params, :charity, :charge, :omise_token, :amount

  def initialize(params)
    @params = params
    @amount = params[:amount]
    @omise_token = params[:omise_token]
  end

  def find_or_pick_random_charity
    @charity =  if params[:charity] == 'random'
                  Charity.find_by_id Charity.ids.sample
                else
                  Charity.find_by_id params[:charity]
                end
  end

  def process_donation
    find_or_pick_random_charity
    return false if !(can_donate? && amount_greater_than_twenty?)

    @charge = build_charge_object
    capture_charge && credit_charged_amount
  end

  def can_donate?
    return false if omise_token.nil? || charity.nil?
    true
  end

  def amount_greater_than_twenty?
    amount.present? && amount.to_i > 20
  end

  def build_charge_object
    if Rails.env.test?
      charge = OpenStruct.new({
        amount: amount.to_f * 100,
        paid: (amount.to_i != 999),
      })
    else
      charge = Omise::Charge.create({
        amount: amount.to_f * 100,
        currency: "THB",
        card: params[:omise_token],
        description: "Donation to #{charity.name} [#{charity.id}]",
      })
    end
    charge
  end

  def capture_charge
    charge.paid
  end

  def credit_charged_amount
    charity.credit_amount(charge.amount)
  end

end
