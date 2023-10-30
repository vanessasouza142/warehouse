require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#description' do
  it 'exibe o nome e o email' do
    #Arrange
    user = User.new(name: 'Julia Almeida', email: 'julia@yahoo.com')

    #Act
    result = user.description()

    #Arrange
    expect(result).to eq('Julia Almeida - julia@yahoo.com')
  end
end
end
