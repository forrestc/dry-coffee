# SuperDry

I am a big fan of [the Philosophy of Ruby](http://www.artima.com/intv/rubyP.html). Matz, the creator of the language, said "I want to concentrate the things I do, not the magical rules of the language." And that is the motivation I created "SuperDry".

SuperDry, as the name indicates, it is super [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself). Compare to the modern JavaScript Frameworks like React, you only need to write 1/3 of the code for the same features set, and the vocabulary of the SuperDry is limited to only 10. So -

* Less code, less opportunity to introduce bugs. Or, when having bugs, they are easier to be caught;
* Easier to learn, easier to focus on the innovations "I do".

Those are the benefits SuperDry brings.
  
## Prerequisites

* HTML
* CSS
* [CoffeeScript](http://coffeescript.org/v2/#top) or JavaScript
* [LoDash](https://lodash.com/docs/4.17.4)

## Vocabulary

The vocabulary of SuperDry is very small, it has only 3 top level classes, and inside each of them, there are no more than 3 keywords.

### Component

The components defines how to render data that saved in store, whenever the store data changed, components knows how to re-render them automatically.

If you have heard of [React](https://reactjs.org/), SuperDry Component is a superset of React Component.

* **render** Function where the styled elements are layed out. The styled elements are either defined in the theme, or is another component.
* **instance functions** The instance functions of a component class are usually called by an element action, like button click or input change. Most of the times the store data are changed in these instance functions, but not necessarily, and once the store data are changed, the related components will be rerendered coordinately.

### Store

The stores save data, and also listen to data changes, and trigger relative behaviors.

* **setup** Function where you can define the data structure in the format of an object. If the value is a string, number, array, or an object, we call it a primary attribute; if the value is a function that computes primary attributes, we call it a computed attribute. The computed attribute changes automatically when primary attribute values change.

  If you have heard of [MobX](https://mobx.js.org/), the setup function of SuperDry Store is a more instinct wrapper of MobX observable feature.

* **load** There are two ways to load the store data. You can give an simple object as an argument of `setup` function, or you can define an `load` function that reads data from some external resources like a result of an ajax call.

* **`on[Field]<Action>`**` Once data are changed in store, and you want to sync the changed data with the local storage, or some data persistency in the backend through ajax calls. These `onFieldAction` functions are your friends. In other frameworks, Data sync is usually done on UI actions, on button click or enter key-stroke in input boxes.

  For instance, if you have a button to delete a todo entry, and another button to clear all completed todo entries, you have to write different code for the same feature. And in SuperDry, you only need to write it once in `TodoStore#onEntriesDelete` function.

### Theme

Where you define the styled elements, which can be "extended" from basic HTML elements with CSS definitions, and can also be "extended" from another styled element and additional CSS definitions.

If you have heard of styled-components, SuperDry Theme is a simplied version of that.

* **extends** A preserved key in styled element definition to identify which HTML element or styled element it inherits from. The value of `extends` can be a string, like `'h1'`, and it can also be an object, defines both base element and the common HTML attributes, like `{ element: 'input', type: 'checkbox', autoFocus: true }`

* **apply** Function defined in SuperDry Theme class, that you can just call it in `Component#render`. The only argument of `apply` is a function, whose variable `t` has all the styled elements defined in that theme. E.g.

  ```coffee
  render: ->
    theme.apply (t) ->
      t.wrapper ->
        t.app ->
          t.header 'todos'
          t.com Input
          t.com EntryList
          t.com Footer
        t.info ->
          t.infoLine 'Double-click to edit a todo'
  ```

* **with** Function that enables a state-sensitive style element. For example, a todo entry shows as a `label` element with some CSS definitions, as defined in theme:

  ```coffee
  entryLabel:
    extends: 'label'
    whiteSpace: 'pre-line'
    wordBreak: 'break-all'
    padding: [15, 60, 15, 15]
    marginLeft: 45
    display: 'block'
    lineHeight: 1.2
    transition: 'color 0.4s'
  ```

  While it is completed, we want to show the label with a `line-through`, so another styled element is defined in theme that extends `entryLabel`:

  ```coffee
  'entryLabel.completed':
    color: '#d9d9d9'
    textDecoration: 'line-through'
  ```

  In the component render function, just one line of code can draw a enty label, by:

  ```coffee
  t.with('entryLabel', pick(entry, 'completed')) entry.description
  ```

## Code Walk Through - TodoMVC

[TodoMVC](http://todomvc.com/) is a test stone that every JavaScript Framework try to provide as an example, and compete with each others on features. SuperDry wins in many aspects among many other top frameworks on [this comparison table](https://github.com/forrestc/superdry/wiki/Comparison). So in this introduction section, I use TodoMVC as an example to show how to write it step by step.

### TODO
