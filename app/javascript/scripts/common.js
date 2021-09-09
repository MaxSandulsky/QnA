export const disable_default_behavior = (element_class) => {
    const element = document.querySelectorAll(element_class)

    if (element) {
        element.forEach(el => {
            el.addEventListener('click', (event) => {
                event.preventDefault()
            })
        })
    }
}