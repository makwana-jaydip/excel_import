# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  context 'validations' do
    context 'when value is empty or invalid' do
      it 'should validate presence of first_name' do
        user.first_name = nil
        expect(user.valid?).to be(false)
        expect(user.errors.full_messages).to eq(["First name can't be blank"])
      end

      it 'should validate presence of last_name' do
        user.last_name = nil
        expect(user.valid?).to be(false)
        expect(user.errors.full_messages).to eq(["Last name can't be blank"])
      end

      it 'should validate presence of email_id' do
        user.email_id = nil
        expect(user.valid?).to be(false)
        expect(user.errors.full_messages).to eq(["Email can't be blank", 'Email is invalid'])
      end

      it 'should validate format of email_id' do
        user.email_id = 'email_id_present_with_invalid_format@com'
        expect(user.valid?).to be(false)
        expect(user.errors.full_messages).to eq(['Email is invalid'])
      end
    end

    context 'when value is present and correct format' do
      it 'should return true for validate values' do
        expect(user.valid?).to be(true)
      end
    end
  end
end
