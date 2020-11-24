list = 
  items: []
  add: (event) ->
    event.preventDefault()
    item = document.getElementById 'add_item'
    list.items.unshift
      name: item.value
      done: false
    item.value = ''
    
    list.draw()
    list.save()
    return

  draw: ->
    container = document.getElementById 'todo_list'
    container.innerHTML = ''

    if list.items.length > 0
      row = ''
      button = ''

      for i of list.items
        row = document.createElement 'div'
        row.innerHTML = list.items[i].name
        row.title = list.items[i].name
        if list.items[i].done
          row.style = 'text-decoration:line-through;'
        container.appendChild row

        row = document.createElement 'div' 

        button = document.createElement 'input'
        button.type = 'button'
        button.value = if list.items[i].done then 'Not check' else 'Check'
        button.dataset.id = i
        if button.value == 'Not check'
          button.classList.add 'check_button'
        else
          button.classList.add 'notcheck_button'
        button.addEventListener 'click', list.toggle
        row.appendChild button

        button = document.createElement 'input'
        button.type = 'button'
        button.value = 'Delete'
        button.dataset.id = i
        button.classList.add 'delete_button'
        button.addEventListener 'click', list.delete
        row.appendChild button
        container.appendChild row

        document.getElementById("delete_all").addEventListener('click', list.deleteAllCheck)
    return
    
  save: ->
    unless localStorage.items?
      localStorage.items = '[]'
    localStorage.items = JSON.stringify(list.items)
    return

  load: ->
    unless localStorage.items?
      localStorage.items = '[]'
    list.items = JSON.parse(localStorage.items)
    list.draw()
    return

  delete: ->
    if confirm 'Delete selected item?'
      list.items.splice @dataset.id, 1
      list.save()
      list.draw()
    return

  deleteAllCheck: ->
    i=0
    if confirm 'Delete selected item?'
      while i < list.items.length
        if list.items[i].done
          list.items.splice i, 1
          i--
        i++
      list.save()
      list.draw()
    return

  toggle: ->
    id = @dataset.id
    list.items[id].done = !list.items[id].done
    list.save()
    list.draw()
    return
    
window.addEventListener 'load', ->
  list.load()
  document.getElementById('todo_add').addEventListener 'submit', list.add
  return