// Generated by CoffeeScript 2.0.0-beta3
var element;

import {
  get
} from 'lodash';

import React from 'react';

import reactKup from 'react-kup';

import {
  render
} from 'react-dom';

import {
  AppContainer
} from 'react-hot-loader';

import Todo from './Todo';

import Calendar from './Calendar';

import TodoMvc from './todomvc/TodoMvc';

element = function() {
  return reactKup(function(k) {
    return k.build(AppContainer, function() {
      return k.div(function() {
        k.build(Calendar, {
          date: new Date
        });
        k.build(Todo, {
          name: 'Home'
        });
        return k.build(TodoMvc);
      });
    });
  });
};

render(element(), document.getElementById('root'));
