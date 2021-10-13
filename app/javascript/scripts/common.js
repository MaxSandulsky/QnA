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

    if (trigger) {
        trigger.addEventListener('ajax:success', event => {
            if (event.target.classList.contains((target_class).substring(1))) {
                const xhr = event.detail[0]
                const container = document.getElementById(container_class + xhr.obj_id)
                const updating = container.querySelector(updating_class)

                updating.textContent = xhr.votes_sum
                switch_promotion(container, event.detail[2].responseURL)
            }
        })
    }
}

export const switch_promotion = (container, responseURL) => {
    const chevron_up = container.querySelector('.chevron.up')
    const chevron_down = container.querySelector('.chevron.down')

    if (responseURL.includes('upvote')) {
      if (chevron_up.classList.contains('selected')) {
        chevron_up.classList.remove('selected')
      }
      else {
        chevron_up.classList.add('selected')
        chevron_down.classList.remove('selected')
      }
    }
    else
    {
      if (chevron_down.classList.contains('selected')) {
        chevron_down.classList.remove('selected')
      }
      else {
        chevron_down.classList.add('selected')
        chevron_up.classList.remove('selected')
      }
    }
}
