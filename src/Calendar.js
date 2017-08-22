// Generated by CoffeeScript 2.0.0-beta3
var Calendar;

import {
  Observable
} from './Observable';

import Button from './Button';

import {
  store as todoStore
} from './Todo';

Calendar = class Calendar extends Observable {
  constructor(props) {
    super(props);
    this.initState({
      date: this.props.date
    });
  }

  prevMonth() {
    return () => {
      var d;
      d = this.state.date;
      return this.state.date = new Date(d.getFullYear(), d.getMonth() - 1, 1);
    };
  }

  nextMonth() {
    return () => {
      var d;
      d = this.state.date;
      return this.state.date = new Date(d.getFullYear(), d.getMonth() + 1, 1);
    };
  }

  _currDate(d) {
    return new Date(this.state.date.getFullYear(), this.state.date.getMonth(), d);
  }

  _isToday(d) {
    var today;
    today = new Date;
    return this._currDate(d).toDateString() === today.toDateString();
  }

  _todos(d) {
    var date, n, ref, ref1;
    date = this._currDate(d).toDateString();
    n = (ref = todoStore.inDates) != null ? (ref1 = ref[date]) != null ? ref1.length : void 0 : void 0;
    if (n) {
      return `(${n})`;
    }
  }

  brew(v) {
    var dates, endDate, j, k, month, monthDesc, ref, ref1, results, startDate, w, weekStart, weeks, year;
    super.brew(v);
    year = this.state.date.getFullYear();
    month = this.state.date.getMonth();
    monthDesc = year + '-' + (month + 1);
    startDate = new Date(year, month, 1);
    endDate = new Date(year, month + 1, 0);
    dates = (function() {
      results = [];
      for (var j = 1, ref = endDate.getDate(); 1 <= ref ? j <= ref : j >= ref; 1 <= ref ? j++ : j--){ results.push(j); }
      return results;
    }).apply(this);
    weekStart = startDate.getDay();
    if (weekStart > 0) {
      for (k = 1, ref1 = weekStart; 1 <= ref1 ? k <= ref1 : k >= ref1; 1 <= ref1 ? k++ : k--) {
        dates.unshift('');
      }
    }
    weeks = (function() {
      var l, ref2, results1;
      results1 = [];
      for (w = l = 0, ref2 = Math.ceil(dates.length / 7); 0 <= ref2 ? l <= ref2 : l >= ref2; w = 0 <= ref2 ? ++l : --l) {
        results1.push(dates.slice(w * 7 + 0, +(w * 7 + 6) + 1 || 9e9));
      }
      return results1;
    })();
    return v.div(() => {
      v.h1(monthDesc);
      v.com(Button, {
        onClick: this.prevMonth(),
        label: "<<"
      });
      v.com(Button, {
        onClick: this.nextMonth(),
        label: ">>"
      });
      return v.table(() => {
        v.thead(() => {
          return v.tr(() => {
            var i, l, len, ref2, results1, wd;
            ref2 = 'S M T W T F S'.split(' ');
            results1 = [];
            for (i = l = 0, len = ref2.length; l < len; i = ++l) {
              wd = ref2[i];
              results1.push(v.th({
                key: 'weekday' + i
              }, wd));
            }
            return results1;
          });
        });
        return v.tbody(() => {
          var l, len, results1, wIndex;
          results1 = [];
          for (wIndex = l = 0, len = weeks.length; l < len; wIndex = ++l) {
            w = weeks[wIndex];
            results1.push(v.tr({
              key: monthDesc + '-week' + wIndex
            }, () => {
              var d, dIndex, len1, m, results2;
              results2 = [];
              for (dIndex = m = 0, len1 = w.length; m < len1; dIndex = ++m) {
                d = w[dIndex];
                results2.push(v.td({
                  key: monthDesc + '-week' + wIndex + '-day' + dIndex
                }, () => {
                  var cell;
                  cell = () => {
                    v.span(d);
                    return v.sup(this._todos(d));
                  };
                  if (this._isToday(d)) {
                    return v.b(cell);
                  } else {
                    return v.p(cell);
                  }
                }));
              }
              return results2;
            }));
          }
          return results1;
        });
      });
    });
  }

};

export default Calendar;
