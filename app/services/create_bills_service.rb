class CreateBillsService < ApplicationService

  attr_reader :registration

  def initialize(registration)
    @registration = registration
  end

  def call
    create_bills(registration)
  end

  private

  def create_bills(registration)
    count = 0
    today = Date.today
    bill_values = calculate_bill_values(registration)
    registration.quantidade_faturas.times do
      if count == 0 && registration.vencimento < today.mday
        date = Date.new(today.year, today.mon, 10)
      else
        date = today + count.months
        last_day_of_month = date.end_of_month.day
        if registration.vencimento > last_day_of_month
          date = date.change(day: last_day_of_month)
        else
          date = date.change(day: registration.vencimento)
        end
      end
      Bill.new(valor_fatura: bill_values[count], data_vencimento: date, registration_id: registration.id, status: 'Aberta').save
      count += 1
    end
  end

  def calculate_bill_values(registration)
    bill_values = []
    registration.quantidade_faturas.times do
      bill_values << registration.valor_total / registration.quantidade_faturas
    end
    total_bill_value = bill_values.sum
    rounded_total_bill_value = total_bill_value.round(2)
    diff = (rounded_total_bill_value - total_bill_value).round(2)
    bill_values[0] += diff
    bill_values
  end
end
