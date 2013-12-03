require 'test_helper'

class SuperTest < SuperSpec

  let(:cookies)  { Supermarket::Stock.new("cookies", 100) }
  let(:dogfood)  { Supermarket::Stock.new("dog food", 500) }
  let(:eggs)     { Supermarket::Stock.new("eggs", 250) }

  # 100 credits off dogfood!
  let(:dogfood_deal)     { Supermarket::WeeklySpecials.new(dogfood, 100) }
  # buy one carton of eggs, get one free!
  let(:egg_extravaganza) { Supermarket::WeeklySpecials.new(eggs, 250, 2) }

  describe "stock" do

    it "creates stock items" do
      cookies.name.must_be_kind_of Symbol
      dogfood.name.must_equal :dogfood
      eggs.price.must_equal 250      
    end

  end

  describe "weekly_specials" do
    
    it "creates weekly specials" do
      dogfood_deal.sale_item.must_equal :dogfood
      dogfood_deal.discount.must_equal 100
      dogfood_deal.quantity.must_equal 1
      
      egg_extravaganza.sale_item.must_equal :eggs
      egg_extravaganza.discount.must_equal 250
      egg_extravaganza.quantity.must_equal 2
    end

  end

  describe "register" do

    let(:no_sale_register) { Supermarket::Register.new }
    let(:register)         { Supermarket::Register.new(egg_extravaganza, dogfood_deal) }
    let(:junkfood_diet)    { register.scan(cookies, cookies, cookies, cookies) }
    let(:mostly_cookies)   { register.scan(cookies, cookies, dogfood, eggs, cookies, cookies) }
    let(:bargain_hunter)   { register.scan(dogfood, dogfood, dogfood, eggs, eggs, eggs, eggs) }

    it "creates a register" do
      no_sale_register.specials.wont_be_nil
      register.specials.size.must_equal 2
    end

    it "sorts the specials by sale_item" do
      register.specials.first.sale_item.must_equal :dogfood
    end

    it "scans items" do
      mostly_cookies

      register.items.must_be_kind_of Hash
      register.items.keys.size.must_equal 3
      register.items[:twenty_three_tons_of_flax].must_be_nil
      register.items[:dogfood].wont_be_nil
      register.items[:cookies][:quantity].must_equal 4
      register.items[:eggs][:cost].must_equal 250
    end

    it "applies no discount if there are no sale items" do
      junkfood_diet

      register.subtotal.must_equal 400
      register.discounts.must_equal 0
      register.total.must_equal 400
    end

    it "applies discounts based on sale items" do
      bargain_hunter

      register.subtotal.must_equal 2500
      register.discounts.must_equal 800
      register.total.must_equal 1700
    end

  end

end