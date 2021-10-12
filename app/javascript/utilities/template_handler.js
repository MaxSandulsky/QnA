export class TemplateHandler {
    constructor(row_html) {
        this.template = document.createElement('template')
        this.template.innerHTML = row_html.trim()
        this.content = this.template.content
        this.firstChild = this.content.firstChild
        this.commentableType = this.firstChild.dataset.commentableType
        this.commentableId = this.firstChild.dataset.commentableId
    }

    comment() {
        if (this.commentableType) {
            return true
        }
        false
    }

    answer() {
        if (this.firstChild.classList.contains('answer')) {
          return true
        }
        false
    }

    question() {
        if (this.firstChild.classList.contains('question')) {
          return true
        }
        false
    }

    insert_comment() {
        alert('ins')
        const container = document.getElementById(this.commentableType + '-' + this.commentableId)
        container.querySelector('.comments').appendChild(this.firstChild)
    }

    insert_answer() {
        const container = document.querySelector('.answers')
        container.appendChild(this.content)
    }

    insert_question() {
        const container = document.querySelector('.questions-list')
        container.appendChild(this.firstChild)
    }
}
