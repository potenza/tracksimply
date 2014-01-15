module CostTest
  def test_validates_amount
    @cost.amount = 0.00
    @cost.valid?
    assert_equal ["must be greater than 0"], @cost.errors[:amount]
  end

  def test_to_s_returns_friendly_name
    name = (Cost::TYPES.find { |t| t.last == @cost.type }).first
    assert_equal name, @cost.to_s
  end
end
