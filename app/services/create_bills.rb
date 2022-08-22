class CreateBills < ApplicationService
  def initialize(registration)
    @registration = registration
  end

  def call
    create_bills(@registration)
  end

  private

  def create_bills(registration)
    count = 0
    today = Date.today
    registration.quantidade_faturas.times do
      bill_value = registration.valor_total / registration.quantidade_faturas
      if count == 0 && registration.vencimento < today.mday
        date = Date.new(today.year, today.mon, 10)
        Bill.new(valor_fatura: bill_value, data_vencimento: date, registration_id: 2, status: 'Aberta').save
        count += 1
      else
        date = today + count.months
        date = if date.mon == 2 && registration.vencimento > 29
                 if date.leap?
                   date.change(day: 29)
                 else
                   date.change(day: 28)
                 end
               elsif [4, 6, 9, 11].include?(date.mon) && registration.vencimento > 30
                 date.change(day: 30)
               else
                 date.change(day: registration.vencimento)
               end
        Bill.new(valor_fatura: bill_value, data_vencimento: date, registration_id: @registration.id,
                 status: 'Aberta').save
        count += 1
      end
    end
  end
end
