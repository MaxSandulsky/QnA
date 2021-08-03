export const enable_answersInQuestion = (element_class, trigger_class) => {
  const trigger = document.querySelector(trigger_class)
  const element = document.querySelector(element_class)

  if (element) {
    trigger.addEventListener('click', (event) => {
      event.preventDefault()

      const handler = new InlineForm(element, trigger)
      handler.formHandler(handler)
    })
  }
  
  const errors = document.querySelector('.resource-errors')

  if (errors) {
    const handler = new InlineForm(element, trigger)
    handler.formHandler(handler)
  }
}

class InlineForm {
  constructor(element, trigger) {
    this.element = element
    this.trigger = trigger
    console.log(this.element)
    console.log(this.trigger)
  }

  formHandler(this_) {
    this_.element.classList.remove('hide')
    this_.trigger.classList.add('hide')
  }
}
