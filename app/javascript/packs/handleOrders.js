window.addEventListener('DOMContentLoaded', (_event) => {

  // Settings
  const orderForm = document.querySelector("#orderForm")
  const submit = document.querySelector("#submit")
  const orderError = document.querySelector("#orderError")

  const data = {
    client_eni: orderForm.client_eni.value,
    client_id: orderForm.client_id.value,
    client_name: orderForm.client_name.value,
    cupom_code: null,
    cupom_discount: 0,
    domain_products: orderForm.domain_products.value,
    domain_payments: orderForm.domain_payments.value,
    gross_value: 0,
    group_name: null,
    period: null,
    plan_id: null,
    user_id: orderForm.user_id.value,
    user_name: orderForm.user_name.value,
  }

  // Functions
  const handleSubmit = async () => {
    
    let error_message = ""
    if (data.group_name === null) error_message += "<p>Grupo não pode ficar em branco</p>" 
    if (data.plan_id === null) error_message += "<p>Plano não pode ficar em branco</p>" 
    if (data.period === null) error_message += "<p>Periodicidade não pode ficar em branco</p>" 
    orderError.innerHTML = error_message
    if (!error_message) {
      const csrfToken = document.querySelector("[name='csrf-token']").content
      let res = await fetch(`/clients/${orderForm.client_id.value}/orders`, {
        method: "POST",
        headers: {
          "X-CSRF-Token": csrfToken,
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          client: {
            plan_id: data.plan_id,
            client_id: data.client_id,
            user_id: data.user_id,
            value: data.gross_value,
            period: data.period,
            client_eni: data.client_eni,
            discount: data.cupom_discount,
          }})
      });
      window.location.href = res.url;
    }
    // console.log(data)
  }

  const renderSummary = () => {
    document.querySelector('#show_client').innerText = data.client_name
    document.querySelector('#show_user').innerText = data.user_name
    document.querySelector("#show_price").innerText = parseFloat(data.gross_value)
                                                            .toFixed(2)
                                                            .replace('.',',')
    document.querySelector("#show_discount").innerText = parseFloat(data.cupom_discount)
                                                         .toFixed(2)
                                                         .replace('.',',')

  }

  const lockCupomField = () => {
    orderForm.cupom_code.disabled = true
    orderForm.submitCupom.disabled = true
  }

  const unlockCupomField = () => {
    orderForm.cupom_code.disabled = false
    orderForm.submitCupom.disabled = false
  }

  const handleSubmitCupom = async (e) => {
    e.preventDefault()

    const url = `${data.domain_payments}/api/v1/coupons/validate_coupon/?code=${orderForm.cupom_code.value};product_group=${data.group_name};total=${data.gross_value}`
    const res = await fetch(url, {
      method: "GET",
      headers: {
        "Content-Type": "application/json"
      }
    });
    const cupom_res = await res.json()
    if (cupom_res.coupon === 'válido') {
      data.cupom_discount = parseFloat(cupom_res.desconto)
      console.log(cupom_res)
      data.cupom_code = orderForm.cupom_code.value
      orderForm.submitCupom.innerText = 'Cupom aplicado!'
      renderSummary()
      lockCupomField()
    } else {
      orderForm.submitCupom.innerText = cupom_res.error
    }
   
  }


  const clearCupomData = () => {
    orderForm.submitCupom.innerText = "Validar cupom"
    document.querySelector("#cupom_code").value = ""
    data.cupom_code = null
    data.cupom_discount = 0
    lockCupomField()
    renderSummary()
  }

  const getGroups = async() => {
    clearCupomData()
    const res = await fetch(`${data.domain_products}/api/v1/product_groups`)
    const groups = await res.json()

    orderForm.group.innerHTML = ''
    const option = document.createElement('option')
    option.textContent = 'Selecione uma opção'
    orderForm.group.appendChild(option)

    groups.forEach((group) => {
      const option = document.createElement('option')
      option.value = group.id
      option.textContent = group.name
      orderForm.group.appendChild(option)
    })
  }

  const getPlans = async() => {
    data.plan_id = null
    data.period = null

    data.group_name = orderForm.group.options[orderForm.group.selectedIndex].text

    const res = await fetch(`${data.domain_products}/api/v1/plans`)
    let plans = await res.json()
    plans = plans.filter((plan) => plan.product_group.name == data.group_name)

    orderForm.plan.innerHTML = ''
    orderForm.period.innerHTML = ''
    data.gross_value = 0
    renderSummary()

    const option = document.createElement('option')
    option.textContent = 'Selecione uma opção'
    orderForm.plan.appendChild(option)

    plans.forEach((plan) => {
      const option = document.createElement('option')
      option.value = plan.id
      option.textContent = plan.name
      orderForm.plan.appendChild(option)
    })
    clearCupomData()
    
  }

  const getPeriods = async() => {
    data.period = null

    data.plan_id = orderForm.plan.value
    
    const res = await fetch(`${data.domain_products}/api/v1/plans/${orderForm.plan.value}/prices`)
    const period = await res.json()
    orderForm.period.innerHTML = ''
    data.gross_value = 0
    renderSummary()


    const option = document.createElement('option')
    option.textContent = 'Selecione uma opção'
    orderForm.period.appendChild(option)

    period.forEach((period) => {
      const option = document.createElement('option')
      option.value = period.id
      option.textContent = period.period
      orderForm.period.appendChild(option)
    })
  }

  const getPrice = async() => {
    data.period = orderForm.period.options[orderForm.period.selectedIndex].text

    const res = await fetch(`${data.domain_products}/api/v1/plans/${orderForm.plan.value}/prices`)
    const prices = await res.json()
    const idPeriod = orderForm.period.value
    let price = 0
    prices.forEach((priceItem) => {
      if (priceItem.id == idPeriod) {
        price = priceItem.value
      }
    })
    data.gross_value = price

    renderSummary()
    if (!data.cupom_discount) {
      unlockCupomField()
    }
  }

  // Triggers
  getGroups()
  renderSummary()
  orderForm.submitCupom.addEventListener("click", handleSubmitCupom)
  orderForm.group.addEventListener("change", getPlans)
  orderForm.plan.addEventListener("change", getPeriods)
  orderForm.period.addEventListener("change", getPrice)
  submit.addEventListener("click", handleSubmit)
})



