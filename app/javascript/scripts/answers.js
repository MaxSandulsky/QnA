import {InlineForm} from 'utilities/form_inline'

export const answer_InlineForm = (element_class, trigger_class) => {
    const trigger = document.querySelector(trigger_class)

    if (trigger) {
        trigger.addEventListener('click', event => {
            event.preventDefault()

            const element = document.querySelector(element_class)
            const handler = new InlineForm(element, event.target)
            handler.formHandler(handler)
        })
    }

    const errors = document.querySelector('.resource-errors')

    if (errors) {
        const handler = new InlineForm(element, trigger)
        handler.formHandler(handler)
    }
}

export const answer_InlineForm_with_target = (element_class, trigger_class, target_class) => {
    const trigger = document.querySelector(trigger_class)

    if (trigger) {
        trigger.addEventListener('click', event => {
            if (event.target.classList.contains((target_class + event.target.dataset.answerId ).substring(1))) {
                event.preventDefault()
                const element = document.querySelector(element_class + event.target.dataset.answerId)
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
