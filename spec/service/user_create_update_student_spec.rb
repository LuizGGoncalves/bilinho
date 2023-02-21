require 'rails_helper'

RSpec.describe UserCreateUpdateStudent, type: :model do
  it 'Create student to user' do
    user = create(:user)
    params = {
      nome: 'testeCriado',
      cpf: '20548269017',
      data_nascimento: '1981-11-12',
      telefone: 11_111_111,
      genero: 'm',
      meio_pagamento: 'cartao'
    }
    response = UserCreateUpdateStudent.call(user, params)

    expect(User.find(user.id).student.nome).to eq('testeCriado')
    expect(User.find(user.id).student.cpf).to eq('20548269017')
    expect(User.find(user.id).student.data_nascimento).to eq(Date.parse('1981-11-12'))
    expect(User.find(user.id).student.telefone).to eq(11_111_111)
    expect(User.find(user.id).student.genero).to eq('m')
    expect(User.find(user.id).student.meio_pagamento).to eq('cartao')
    expect(response[:status]).to eq(200)
  end
  it 'Invalid params to student create' do
    user = create(:user)
    params = {
      nome: 256_787,
      cpf: '205489085',
      data_nascimento: '1981-11-126',
      telefone: 'sting',
      genero: 'P',
      meio_pagamento: 'carne'
    }
    response = UserCreateUpdateStudent.call(user, params)
    expect(response[:status]).to eq(400)
  end

  it 'update student values' do
    user = create(:user)
    student = create(:student)
    student.change_user_id(user)
    params = {
      nome: 'testeUpdate',
      data_nascimento: '1981-11-15',
      genero: 'f',
    }
    response = UserCreateUpdateStudent.call(user, params)
    expect(User.find(user.id).student.nome).to eq('testeUpdate')
    expect(User.find(user.id).student.cpf).to eq('20548269017')
    expect(User.find(user.id).student.data_nascimento).to eq(Date.parse('1981-11-15'))
    expect(User.find(user.id).student.telefone).to eq(11_111_111)
    expect(User.find(user.id).student.genero).to eq('f')
    expect(User.find(user.id).student.meio_pagamento).to eq('cartao')
    expect(response[:status]).to eq(200)
  end

  it 'update student whit invalid value' do
    user = create(:user)
    student = create(:student)
    student.change_user_id(user)
    params = {
      nome: 5549841654,
      genero: 'passaro',
    }
    response = UserCreateUpdateStudent.call(user, params)
    expect(response[:status]).to eq(400)
  end
end
