export const disable_default_behavior = (element_class) => {
    const element = document.querySelectorAll(element_class)

    if (element) {
        element.forEach(el => {
            el.addEventListener('click', event => {
                event.preventDefault()
            })
        })
    }
}

export const votes_by_ajaj_with_target = (trigger_class, updating_class, target_class, container_class) => {
    const trigger = document.querySelector(trigger_class)
    const target = document.querySelectorAll(target_class)

    if (trigger) {
        trigger.addEventListener('ajax:success', event => {
            if (event.target.classList.contains((target_class).substring(1))) {
                const xhr = event.detail[0]

                const container = document.querySelector(container_class + xhr.obj_id)
                const updating = container.querySelector(updating_class)

                updating.textContent = xhr.votes_sum
                switch_promotion(container, event.detail[2].responseURL)
            }
        })
    }
}

export const switch_promotion = (container, responseURL) => {
    if (responseURL.includes('upvote')) {
      container.querySelector('.chevron.up').classList.add('selected')
      container.querySelector('.chevron.down').classList.remove('selected')
    }
    else
    {
      container.querySelector('.chevron.up').classList.remove('selected')
      container.querySelector('.chevron.down').classList.add('selected')
    }
}
