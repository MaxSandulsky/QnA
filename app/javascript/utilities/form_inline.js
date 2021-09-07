export class InlineForm {
  constructor(element, trigger) {
    this.element = element
    this.trigger = trigger
  }

  formHandler(this_) {
    this_.element.classList.remove('hide')
    this_.trigger.classList.add('hide')
  }
}
