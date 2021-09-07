import {InlineForm} from 'utilities/form_inline'

export const question_InlineForm_with_target = (element_class, trigger_class, target_class) => {
    const trigger = document.querySelector(trigger_class)

    if (trigger) {
        trigger.addEventListener('click', (event) => {
            if (event.target.classList.contains(target_class.substring(1))) {
                event.preventDefault()

                const element = document.querySelector(element_class)
                const handler = new InlineForm(element, event.target)
                handler.formHandler(handler)
            }
        })
    }

    const errors = document.querySelector('.resource-errors')

    if (errors) {
        const handler = new InlineForm(element, trigger)
        handler.formHandler(handler)
    }
}