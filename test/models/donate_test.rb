require 'test_helper'

class DonateTest < ActiveSupport::TestCase
  setup do
    @charity = charities(:children)
    @params = ActionController::Parameters.new({
      "amount"=>"39",
      "omise_token"=>"tokn_X",
      "charity"=> @charity.id.to_s
    })
    @donate = Donate.new(@params)
  end

  test "for finding charity" do
    @donate.find_or_pick_random_charity

    assert_equal @donate.charity, @charity
  end

  test "for finding random charity" do
    @params["charity"] ='random'

    donate = Donate.new(@params)
    donate.find_or_pick_random_charity
    assert_equal true, donate.charity.present?
  end

  test "for omise_token & charity check" do
    donate = Donate.new(@params)
    donate.find_or_pick_random_charity

    @params[:omise_token] = nil
    donate_without_token = Donate.new(@params)
    donate_without_token.find_or_pick_random_charity

    @params[:omise_token] = 'tokn_X'
    @params[:charity] = ''
    donate_without_charity = Donate.new(@params)
    donate_without_charity.find_or_pick_random_charity

    assert_equal true, donate.can_donate?
    assert_equal false, donate_without_token.can_donate?
    assert_equal false, donate_without_charity.can_donate?
  end

  test "for check if amount is greater than 20" do
    donate = Donate.new(@params)
    @params[:amount] = '19'
    donate_below_twenty = Donate.new(@params)

    assert_equal true, donate.amount_greater_than_twenty?
    assert_equal false, donate_below_twenty.amount_greater_than_twenty?
  end

  test "for process donation if all params are correct" do
    donate = Donate.new(@params)

    assert_not_nil donate.process_donation
  end

  test "for process donation if carity is absent" do
    @params[:charity] = ''
    donate = Donate.new(@params)

    assert_equal false, donate.process_donation
  end

end
