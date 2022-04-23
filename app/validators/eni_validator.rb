class EniValidator < ActiveModel::EachValidator
  def validate_each(client, _eni, value)
    eni_length(client, value)
    eni_valid(client, value)
  end

  private

  def eni_length(client, value)
    return if value.length == 11 || value.length == 14

    client.errors.add :base, 'documento não possui o tamanho esperado (11 ou 14 caracteres)'
  end

  # rubocop:disable all
  def first_cpf_digit(value)
    sum = (value[0].to_i * 10) + (value[1].to_i * 9) + (value[2].to_i * 8) +
           (value[3].to_i * 7) + (value[4].to_i * 6) + (value[5].to_i * 5) +
           (value[6].to_i * 4) + (value[7].to_i * 3) + (value[8].to_i * 2)
    result = sum % 11

    return 0 if [0, 1].include?(result)

    11 - result
    
  end

  def second_cpf_digit(value)
    sum = (value[0].to_i * 11) + (value[1].to_i * 10) + (value[2].to_i * 9) +
           (value[3].to_i * 8) + (value[4].to_i * 7) + (value[5].to_i * 6) +
           (value[6].to_i * 5) + (value[7].to_i * 4) + (value[8].to_i * 3) +
           (first_cpf_digit(value) * 2)
    result = sum % 11

    return 0 if [0, 1].include?(result)

    11 - result
  end
  # rubocop:enable all

  def cpf_valid(value)
    value[9].to_i == first_cpf_digit(value) && value[10].to_i == second_cpf_digit(value)
  end

  # rubocop:disable all
  def first_cnpj_digit(value)
    sum = (value[0].to_i * 5) + (value[1].to_i * 4) + (value[2].to_i * 3) +
          (value[3].to_i * 2) + (value[4].to_i * 9) + (value[5].to_i * 8) +
          (value[6].to_i * 7) + (value[7].to_i * 6) + (value[8].to_i * 5) +
          (value[9].to_i * 4) + (value[10].to_i * 3) + (value[11].to_i * 2)
    result = sum % 11

    return 0 if  result < 2

    11 - result
  end

  def second_cnpj_digit(value)
    sum = (value[0].to_i * 6) + (value[1].to_i * 5) + (value[2].to_i * 4) +
          (value[3].to_i * 3) + (value[4].to_i * 2) + (value[5].to_i * 9) +
          (value[6].to_i * 8) + (value[7].to_i * 7) + (value[8].to_i * 6) +
          (value[9].to_i * 5) + (value[10].to_i * 4) + (value[11].to_i * 3) +
          (value[12].to_i * 2)
    result = sum % 11

    return 0 if result < 2

    11 - result
  end
  # rubocop:enable all

  def cnpj_valid(value)
    value[12].to_i == first_cnpj_digit(value) && value[13].to_i == second_cnpj_digit(value)
  end

  def eni_valid(client, value)
    return if cpf_valid(value) || cnpj_valid(value)

    client.errors.add :base, 'CPF/CNPJ com formato inválido'
  end
end
